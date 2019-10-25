//
//  UtilsHandlers.m
//  flutter_bmap_plugin
//
//  Created by iMac on 2019/10/25.
//

#import "UtilsHandlers.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
@implementation Convert {
    CLLocationCoordinate2D _bd09Coord;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    NSDictionary *dic = call.arguments;
    double lat = [dic[@"srcCoord"][@"latitude"] doubleValue];
    double log = [dic[@"srcCoord"][@"longitude"] doubleValue];
    CLLocationCoordinate2D gcj02Coord = CLLocationCoordinate2DMake(lat, log);
    // 转为百度经纬度类型的坐标
    if ([dic[@"coordType"] isEqualToString:@"GPS"]) {
      _bd09Coord = BMKCoordTrans(gcj02Coord, BMK_COORDTYPE_GPS, BMK_COORDTYPE_BD09LL);
    }else if ([dic[@"coordType"] isEqualToString:@"BD09LL"]){
       _bd09Coord = BMKCoordTrans(gcj02Coord, BMK_COORDTYPE_BD09LL, BMK_COORDTYPE_BD09LL);
    }else if ([dic[@"coordType"] isEqualToString:@"BD09MC"]){
        _bd09Coord = BMKCoordTrans(gcj02Coord, BMK_COORDTYPE_BD09LL, BMK_COORDTYPE_BD09LL);
    }else if ([dic[@"coordType"] isEqualToString:@"COMMON"]){
       _bd09Coord = BMKCoordTrans(gcj02Coord, BMK_COORDTYPE_COMMON, BMK_COORDTYPE_BD09LL);
    }
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [resultDic setValue:[NSNumber numberWithDouble:_bd09Coord.latitude] forKeyPath:@"latitude"];
    [resultDic setValue:[NSNumber numberWithDouble:_bd09Coord.longitude] forKeyPath:@"longitude"];
    result(resultDic);
    
}

@end

@implementation ConvertList {
      CLLocationCoordinate2D _bd09Coord;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    NSDictionary *dic = call.arguments;
    NSArray *coordArr = dic[@"srcCoordList"];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSMutableArray *resultArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < coordArr.count; i++) {
        NSDictionary *coordDic = coordArr[i];
        double lat = [coordDic[@"latitude"] doubleValue];
        double log = [coordDic[@"longitude"] doubleValue];
        CLLocationCoordinate2D gcj02Coord = CLLocationCoordinate2DMake(lat, log);
        // 转为百度经纬度类型的坐标
        if ([dic[@"coordType"] isEqualToString:@"GPS"]) {
          _bd09Coord = BMKCoordTrans(gcj02Coord, BMK_COORDTYPE_GPS, BMK_COORDTYPE_BD09LL);
        }else if ([dic[@"coordType"] isEqualToString:@"BD09LL"]){
           _bd09Coord = BMKCoordTrans(gcj02Coord, BMK_COORDTYPE_BD09LL, BMK_COORDTYPE_BD09LL);
        }else if ([dic[@"coordType"] isEqualToString:@"BD09MC"]){
            _bd09Coord = BMKCoordTrans(gcj02Coord, BMK_COORDTYPE_BD09LL, BMK_COORDTYPE_BD09LL);
        }else if ([dic[@"coordType"] isEqualToString:@"COMMON"]){
           _bd09Coord = BMKCoordTrans(gcj02Coord, BMK_COORDTYPE_COMMON, BMK_COORDTYPE_BD09LL);
        }
        [resultDic setValue:[NSNumber numberWithDouble:_bd09Coord.latitude] forKeyPath:@"latitude"];
        [resultDic setValue:[NSNumber numberWithDouble:_bd09Coord.longitude] forKeyPath:@"longitude"];
        [resultArr addObject:resultDic];
    }
        result(resultArr);
}

@end


@implementation GetDistance {

}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    NSDictionary *parmDic = call.arguments;
    double fromlat = [parmDic[@"from"][@"latitude"] doubleValue];
    double fromlog = [parmDic[@"from"][@"longitude"] doubleValue];
    double tolat = [parmDic[@"to"][@"latitude"] doubleValue];
    double tolog = [parmDic[@"to"][@"longitude"] doubleValue];
    BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(fromlat,fromlog));
    BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(tolat,tolog));
    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
    result(@(distance));
}

@end

@implementation Northeast {

}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
}

@end

@implementation GetNearestPointFromLine {

}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
}

@end

@implementation IsPolygonContainsPoint {

}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
}

@end

@implementation IsCircleContainsPoint {

}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
}

@end
