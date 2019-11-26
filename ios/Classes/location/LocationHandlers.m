//
// Created by Yohom Bao on 2018-12-15.
//

#import "LocationHandlers.h"
#import <BMKLocationkit/BMKLocationComponent.h>
#import "FlutterBMapPlugin.h"
#import "LocationModels.h"
#import "MJExtension.h"
static BMKLocationManager *_locationManager;
static FlutterEventSink _eventSink;

@implementation Init {

}

- (instancetype)init {
    self = [super init];
    if (self) {
       
    }

    return self;
}
-(FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events
{
    _eventSink = events;
    return nil;
}
-(FlutterError *)onCancelWithArguments:(id)arguments
{
    return nil;
}
@end

@implementation IsStart {
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _locationManager = [[BMKLocationManager alloc] init];
    }

    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    result(@([self determineWhetherTheAPPOpensTheLocation]));
}
#pragma mark 判断是否打开定位
-(BOOL)determineWhetherTheAPPOpensTheLocation{
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        return YES;
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"message:@"请到设置->隐私->定位服务中开启【康复驿站】定位服务，以便于能够准确获得你的位置信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置",nil];
        [alert show];
        return NO;
    }
    return nil;
}

#pragma mark - 跳转设置打开定位
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{//点击弹窗按钮后
     if (buttonIndex ==1){//确定
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
     }
}

@end


#pragma 开始定位

@implementation StartLocation {
}

- (instancetype)init {
    self = [super init];
    if (self) {
       
    }

    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
   //初始化实例
   //设置delegate
   _locationManager.delegate = self;
   //设置返回位置的坐标系类型
   _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
   //设置距离过滤参数
   _locationManager.distanceFilter = kCLDistanceFilterNone;
   //设置预期精度参数
   _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
   //设置应用位置类型
   _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
   //设置是否自动停止位置更新
   _locationManager.pausesLocationUpdatesAutomatically = NO;
   //设置是否允许后台定位
   _locationManager.allowsBackgroundLocationUpdates = YES;
   //设置位置获取超时时间
   _locationManager.locationTimeout = 10;
   //设置获取地址信息超时时间
   _locationManager.reGeocodeTimeout = 10;
    [_locationManager setLocatingWithReGeocode:YES];
    [_locationManager startUpdatingLocation];
    
}
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didUpdateLocation:(BMKLocation * _Nullable)location orError:(NSError * _Nullable)error
{
    if (error)
    {
        NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
    } if (location) {//得到定位信息，添加annotation
            BDLocation *bL = [[BDLocation alloc] initWithLocation:location withError:nil];
                   NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
                   [dic setValue:[NSNumber numberWithInt:0] forKeyPath:@"event"];
                   [dic setValue:[bL mj_JSONObject] forKeyPath:@"data"];
        if (_eventSink) {
             _eventSink(dic);
        }
                  
                if (location.location) {
                    NSLog(@"LOC = %@",location.location);
                }
                if (location.rgcData) {
                    NSLog(@"rgc = %@",[location.rgcData description]);
                }
                
                if (location.rgcData.poiList) {
                    for (BMKLocationPoi * poi in location.rgcData.poiList) {
                        NSLog(@"poi = %@, %@, %f, %@, %@", poi.name, poi.addr, poi.relaiability, poi.tags, poi.uid);
                    }
                }
                
                if (location.rgcData.poiRegion) {
                    NSLog(@"poiregion = %@, %@, %@", location.rgcData.poiRegion.name, location.rgcData.poiRegion.tags, location.rgcData.poiRegion.directionDesc);
                }

            }
}
@end


#pragma 定位一次

@implementation RequestLocation

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    
     _locationManager.delegate = self;
       _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
       _locationManager.distanceFilter = kCLDistanceFilterNone;
                      _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
                      _locationManager.pausesLocationUpdatesAutomatically = NO;
                      _locationManager.locationTimeout = 10;
                      _locationManager.reGeocodeTimeout = 10;
    [_locationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        BDLocation *bL = [[BDLocation alloc] initWithLocation:location withError:nil];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
        [dic setValue:[NSNumber numberWithInt:0] forKeyPath:@"event"];
        [dic setValue:[bL mj_JSONObject] forKeyPath:@"data"];
        _eventSink(dic);
        }];

}

@end

#pragma 结束定位

@implementation StopLocation {

}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    [_locationManager stopUpdatingLocation];
}

@end
