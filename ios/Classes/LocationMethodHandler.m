//
//  LocationMethodCallHandler.m
//  flutter_bmap_plugin
//
//  Created by Nick on 2020/4/1.
//

#import "LocationMethodHandler.h"
#import <Flutter/Flutter.h>
#import <BMKLocationkit/BMKLocationComponent.h>
#import "MethodCallDelegate.h"

@interface LocationMethodHandler()<BMKLocationManagerDelegate,UIAlertViewDelegate>
@property (nonatomic,assign) BOOL start;
@property (nonatomic,strong) BMKLocationManager *locationManager;
@property (nonatomic,strong) FlutterEventSink events;
@property (nonatomic,strong) NSDateFormatter *dateFormatter;
@end

@implementation LocationMethodHandler
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.locationManager = [[BMKLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setAMSymbol:@"AM"];
        [self.dateFormatter setPMSymbol:@"PM"];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return self;
}
- (void)onMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result{
    NSLog(@"onMethodCall method name: %@ with args: %@", call.method, call.arguments);
    if ([call.method isEqualToString:@"isStart"]) {
        result([NSNumber numberWithBool:_start]);
    }else if([call.method isEqualToString:@"startLocation"]){
        if ([self checkLocationServiceEnabled]) {
            [self startLocation:call.arguments];
            if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
                result([FlutterError errorWithCode:@"PERMISSION_DENIED" message:@"请在设置中打开应用的[位置]权限后重试" details:nil]);
                NSString * message = @"是否打开应用设置中的[位置]权限,以便获得您的位置信息?";
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                               message:message
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                     otherButtonTitles:@"打开",nil];
                [alert show];
            }else{
                result(nil);
            }
        }else{
            NSLog(@"用户未打开定位.");
            result([FlutterError errorWithCode:@"PERMISSION_DENIED" message:@"请在设置中打开应用的[位置]权限后重试" details:nil]);
        }
    }else if([call.method isEqualToString:@"requestLocation"]){
        if ([self checkLocationServiceEnabled]) {
            [self requestLocation:call.arguments];
            if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
                result([FlutterError errorWithCode:@"PERMISSION_DENIED" message:@"请在设置中打开应用的[位置]权限后重试" details:nil]);
                NSString * message = @"是否打开应用设置中的[位置]权限,以便获得您的位置信息?";
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                               message:message
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                     otherButtonTitles:@"打开",nil];
                [alert show];
            }else{
                result(nil);
            }
        }else{
            NSLog(@"用户未打开定位.");
            result([FlutterError errorWithCode:@"PERMISSION_DENIED" message:@"请在设置中打开应用的[位置]权限后重试" details:nil]);
        }
    }else if([call.method isEqualToString:@"stopLocation"]){
        [self stopLocation];
        result(nil);
    }else{
        result(FlutterMethodNotImplemented);
    }
}

#pragma mark - 定位SDK相关方法实现
- (void) startLocation:(NSDictionary *)arguments{
    [_locationManager stopUpdatingLocation];
    NSString *coordName = [arguments valueForKey:@"coorType"];
    if ([coordName isEqualToString: @"bd09ll"]) {
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    }else if([coordName isEqualToString:@"gcJ02"]){
        _locationManager.coordinateType = BMKLocationCoordinateTypeGCJ02;
    }else if([coordName isEqualToString:@"bd09"]){
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09MC;
    }else if([coordName isEqualToString:@"wgs84"]){
        _locationManager.coordinateType = BMKLocationCoordinateTypeWGS84;
    }else {
        NSLog(@"不合法的参数coorType: %@. 将使用默认值: bd09ll", coordName);
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    }
    double autoNotifyMinDistance = [[arguments objectForKey:@"autoNotifyMinDistance"] doubleValue];
    _locationManager.distanceFilter = autoNotifyMinDistance > 0.0 ? autoNotifyMinDistance:kCLDistanceFilterNone;
    NSString *locationMode = [arguments objectForKey:@"locationMode"];
    if ([@"Battery_Saving" isEqualToString:locationMode]) {
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    } else if ([@"Hight_Accuracy" isEqualToString:locationMode]) {
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    } else if ([@"Device_Sensors" isEqualToString:locationMode]) {
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    } else {
        NSLog(@"不合法的参数locationMode: %@. 将使用默认值: Battery_Saving",locationMode);
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    }
    _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    _locationManager.allowsBackgroundLocationUpdates = NO;
    NSInteger locationTimeout = [[arguments objectForKey:@"timeOut"] integerValue] / 1000;
    _locationManager.locationTimeout = locationTimeout;
    BOOL isNeedAddress = [[arguments objectForKey:@"isNeedAddress"] boolValue];
    _locationManager.locatingWithReGeocode = isNeedAddress;
    BOOL isNeedNewVersionRgc = [[arguments objectForKey:@"isNeedNewVersionRgc"] boolValue];
    _locationManager.isNeedNewVersionReGeocode = isNeedNewVersionRgc;
    BOOL isNeedDeviceDirect = [[arguments objectForKey:@"mIsNeedDeviceDirect"] boolValue];
    NSString *userId = [arguments objectForKey:@"prodName"];
    _locationManager.userID = userId;
    [_locationManager startUpdatingLocation];
    if (isNeedDeviceDirect) {
        [_locationManager startUpdatingHeading];
    }
    _start = YES;
}

- (void) requestLocation:(NSDictionary *)arguments{
    [_locationManager stopUpdatingLocation];
    NSString *coordName = [arguments valueForKey:@"coorType"];
    if ([coordName isEqualToString: @"bd09ll"]) {
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    }else if([coordName isEqualToString:@"gcJ02"]){
        _locationManager.coordinateType = BMKLocationCoordinateTypeGCJ02;
    }else if([coordName isEqualToString:@"bd09"]){
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09MC;
    }else if([coordName isEqualToString:@"wgs84"]){
        _locationManager.coordinateType = BMKLocationCoordinateTypeWGS84;
    }else {
        NSLog(@"不合法的参数coorType: %@. 将使用默认值: bd09ll", coordName);
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    }
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.allowsBackgroundLocationUpdates = NO;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    NSString *locationMode = [arguments objectForKey:@"locationMode"];
    if ([@"Battery_Saving" isEqualToString:locationMode]) {
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    } else if ([@"Hight_Accuracy" isEqualToString:locationMode]) {
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    } else if ([@"Device_Sensors" isEqualToString:locationMode]) {
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    } else {
        NSLog(@"不合法的参数locationMode: %@. 将使用默认值: Battery_Saving",locationMode);
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    }
    NSInteger locationTimeout = [[arguments objectForKey:@"timeOut"] integerValue] / 1000;
    _locationManager.locationTimeout = locationTimeout;
    BOOL isNeedAddress = [[arguments objectForKey:@"isNeedAddress"] boolValue];
    _locationManager.locatingWithReGeocode = isNeedAddress;
    BOOL isNeedNewVersionRgc = [[arguments objectForKey:@"isNeedNewVersionRgc"] boolValue];
    _locationManager.isNeedNewVersionReGeocode = isNeedNewVersionRgc;
    BOOL isNeedDeviceDirect = [[arguments objectForKey:@"mIsNeedDeviceDirect"] boolValue];
    NSString *userId = [arguments objectForKey:@"prodName"];
    _locationManager.userID = userId;
    if (isNeedDeviceDirect) {
        [_locationManager startUpdatingHeading];
    }
    __weak LocationMethodHandler *weakSelf = self;
    [_locationManager requestLocationWithReGeocode:YES
                                  withNetworkState:YES
                                   completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        LocationMethodHandler *innerRef = weakSelf;
        if (error) {
            NSLog(@"定位失败, 错误码:%ld, 错误描述: %@", error.code, error.localizedDescription);
        }
        if (!location) {
            return;
        }
        if (location.location) {
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
            [innerRef BMKLocation:location toDictionary:dictionary];
            if (innerRef.events) {
                NSDictionary *event = @{
                    @"event":@0,
                    @"data":dictionary
                };
                innerRef.events(event);
            }
        }
        innerRef.start = NO;
    }];
    _start = YES;
}

- (void) stopLocation{
    if (_start) {
        [_locationManager stopUpdatingHeading];
        [_locationManager stopUpdatingLocation];
        _start = NO;
    }
}

#pragma mark - BMKLocationManagerDelegate 实现

/**
 *  @brief 连续定位回调函数。
 *  @param manager 定位 BMKLocationManager 类。
 *  @param location 定位结果，参考BMKLocation。
 *  @param error 错误信息。
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didUpdateLocation:(BMKLocation * _Nullable)location orError:(NSError * _Nullable)error{
    if (error) {
        NSLog(@"定位失败, 错误码:%ld, 错误描述: %@", error.code, error.localizedDescription);
    }
    if (!location) {
        return;
    }
    if (location.location) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
        [self BMKLocation:location toDictionary:dictionary];
        if (_events) {
            NSDictionary *event = @{
                @"event":@0,
                @"data":dictionary
            };
            _events(event);
        }
    }
}

- (void)BMKLocation:(BMKLocation * _Nonnull)location
       toDictionary:(NSMutableDictionary * _Nonnull)dictionary{
    NSString *time = [_dateFormatter stringFromDate:location.location.timestamp];
    [dictionary setValue:time forKey:@"time"];
    NSString *country = location.rgcData ? location.rgcData.country : @"";
    [dictionary setValue:country forKey:@"country"];
    NSString *countryCode = location.rgcData ? location.rgcData.countryCode : @"";
    [dictionary setValue:countryCode forKey:@"countryCode"];
    NSString *province = location.rgcData ? location.rgcData.province : @"";
    [dictionary setValue:province forKey:@"province"];
    NSString *city = location.rgcData ? location.rgcData.city : @"";
    [dictionary setValue:city forKey:@"city"];
    NSString *cityCode = location.rgcData ? location.rgcData.cityCode : @"";
    [dictionary setValue:cityCode forKey:@"cityCode"];
    NSString *adCode = location.rgcData ? location.rgcData.adCode : @"";
    [dictionary setValue:adCode forKey:@"adCode"];
    NSString *district = location.rgcData ? location.rgcData.district : @"";
    [dictionary setValue:district forKey:@"district"];
    NSString *streeet = location.rgcData ? location.rgcData.street : @"";
    [dictionary setValue:streeet forKey:@"street"];
    NSString *streetNumber = location.rgcData ? location.rgcData.streetNumber : @"";
    [dictionary setValue:streetNumber forKey:@"streetNumber"];
    NSString *town = location.rgcData ? location.rgcData.town : @"";
    [dictionary setValue:town forKey:@"town"];
    NSString *addrStr = [NSString stringWithFormat:@"%1$@%2$@%3$@%4$@%5$@%6$@",
                         province, city,district,town, streeet, streetNumber];
    addrStr = [addrStr stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    addrStr = [addrStr stringByReplacingOccurrencesOfString:@"null" withString:@""];
    [dictionary setValue:addrStr forKey:@"addrStr"];
    [dictionary setValue:location.floorString forKey:@"floor"];
    [dictionary setValue:location.buildingID forKey:@"buildingID"];
    [dictionary setValue:location.buildingName forKey:@"buildingName"];
    [dictionary setValue:location.locationID forKey:@"locationID"];
    [dictionary setValue:@"" forKey:@"coorType"];
    [dictionary setValue:@"None" forKey:@"networkLocationType"];
    [dictionary setValue:@0 forKey: @"locType"];
    NSNumber *altitude = [NSNumber numberWithDouble:location.location.altitude];
    NSNumber *latitude = [NSNumber numberWithDouble: location.location.coordinate.latitude];
    NSNumber *longitude = [NSNumber numberWithDouble: location.location.coordinate.longitude];
    [dictionary setValue:altitude forKey:@"altitude"];
    [dictionary setValue:latitude forKey:@"latitude"];
    [dictionary setValue:longitude forKey:@"longitude"];
    NSNumber *speed = [NSNumber numberWithDouble: location.location.speed];
    [dictionary setValue:speed forKey:@"speed"];
    NSNumber *direction = [NSNumber numberWithDouble:location.location.course];
    [dictionary setValue:direction forKey:@"direction"];
    NSNumber *radius = [NSNumber numberWithDouble:location.location.horizontalAccuracy];
    [dictionary setValue:radius forKey:@"radius"];
    NSNumber *provider = [NSNumber numberWithInt:location.provider];
    [dictionary setValue:provider forKey:@"provider"];
    NSMutableArray *poiList = [[NSMutableArray alloc] init];
    [dictionary setValue:poiList forKey:@"poiList"];
    if (location.rgcData) {
        if (location.rgcData.poiList) {
            for (BMKLocationPoi * poi in location.rgcData.poiList) {
                NSMutableDictionary *poiDictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
                [poiDictionary setValue:poi.uid forKey:@"id"];
                [poiDictionary setValue:poi.name forKey:@"name"];
                NSNumber *rank = [NSNumber numberWithFloat:poi.relaiability];
                [poiDictionary setValue:rank forKey:@"rank"];
                [poiDictionary setValue:poi.tags forKey:@"tags"];
                [poiDictionary setValue:poi.addr forKey:@"addr"];
                [poiList addObject:poiDictionary];
            }
        }
        if (location.rgcData.poiRegion) {
            NSMutableDictionary *poiRegion = [[NSMutableDictionary alloc] initWithCapacity:3];
            [poiRegion setValue:location.rgcData.poiRegion.name forKey:@"name"];
            [poiRegion setValue:location.rgcData.poiRegion.tags forKey:@"tags"];
            [poiRegion setValue:location.rgcData.poiRegion.directionDesc forKey:@"directionDesc"];
            [dictionary setValue:poiRegion forKey:@"poiRegion"];
        }else{
            [dictionary setValue:nil forKey:@"poiRegion"];
        }
    }
    
}

/**
 *  @brief 定位权限状态改变时回调函数
 *  @param manager 定位 BMKLocationManager 类。
 *  @param status 定位权限状态。
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
}

- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events{
    self.events = events;
    return nil;
}

- (FlutterError *)onCancelWithArguments:(id)arguments{
    self.events = nil;
    return nil;
}
#pragma mark - 判断或申请定位权限
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        if([CLLocationManager locationServicesEnabled]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

- (BOOL)checkLocationServiceEnabled{
    BOOL enabled = [CLLocationManager locationServicesEnabled];
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (!enabled){
        NSLog(@"打开系统定位设置");
        NSString * message = @"您需要前往系统设置并打开[隐私]中的定位服务,以便获得您的位置信息";
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:message
                                                      delegate:self
                                             cancelButtonTitle:nil
                                             otherButtonTitles:@"确定",nil];
        [alert show];
        return NO;
    }
    if (status == kCLAuthorizationStatusRestricted
        || status == kCLAuthorizationStatusDenied) {
        //|| status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"打开应用设置");
        NSString * message = @"是否打开应用设置中的[位置]权限,以便获得您的位置信息?";
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:message
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"打开",nil];
        [alert show];
        return NO;
    }
    return YES;
}


- (void)dealloc{
    if (_start) {
        [self stopLocation];
    }
    _locationManager = nil;
    _dateFormatter = nil;
}
@end
