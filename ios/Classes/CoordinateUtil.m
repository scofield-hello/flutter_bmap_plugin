//
//  CoordinateUtil.m
//  flutter_bmap_plugin
//
//  Created by Nick on 2020/4/6.
//

#import "CoordinateUtil.h"
#import <Flutter/Flutter.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

NSString * const CoordConvertMethod = @"convert";
NSString * const CoordListConvertMethod = @"convertList";
NSString * const CoordGetDistanceMethod = @"getDistance";
NSString * const CoordCalculateAreaMethod = @"calculateArea";
NSString * const CoordGetNearestPointFromLineMethod = @"getNearestPointFromLine";
NSString * const CoordIsPolygonContainsPointMethod = @"isPolygonContainsPoint";
NSString * const CoordIsCircleContainsPointMethod = @"isCircleContainsPoint";

@implementation CoordinateUtil

- (void)onMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result{
    NSLog(@"onMethodCall method name: %@ with args: %@", call.method, call.arguments);
    if ([CoordConvertMethod isEqualToString:call.method]) {
        result([self convert:call.arguments]);
    }else if ([CoordListConvertMethod isEqualToString:call.method]) {
        result([self convertList:call.arguments]);
    }else if ([CoordGetDistanceMethod isEqualToString:call.method]) {
        result([NSNumber numberWithDouble:[self getDistance:call.arguments]]);
    }else if ([CoordCalculateAreaMethod isEqualToString:call.method]) {
        result(FlutterMethodNotImplemented);
    }else if ([CoordGetNearestPointFromLineMethod isEqualToString:call.method]) {
        result([self getNearestPointFromLine:call.arguments]);
    }else if ([CoordIsPolygonContainsPointMethod isEqualToString:call.method]) {
        result([NSNumber numberWithBool:[self isPolygonContainsPoint:call.arguments]]);
    }else if ([CoordIsCircleContainsPointMethod isEqualToString:call.method]) {
        result([NSNumber numberWithBool:[self isCircleContainsPoint:call.arguments]]);
    }else {
        result(FlutterMethodNotImplemented);
    }
}

- (NSDictionary*)convert:(NSDictionary*)arguments{
    NSString *coordType = [arguments objectForKey:@"coordType"];
    NSDictionary *srcCoord = [arguments objectForKey:@"srcCoord"];
    BMK_COORD_TYPE srcType;
    if ([@"GPS" isEqualToString:coordType]) {
        srcType = BMK_COORDTYPE_GPS;
    }else if ([@"GCJ02" isEqualToString:coordType]) {
        srcType = BMK_COORDTYPE_COMMON;
    }else {
        srcType = BMK_COORDTYPE_GPS;
        NSLog(@"Unknown coordtype for:%@.", coordType);
    }
    return [self convert:srcCoord srcType:srcType];
}

- (NSArray*)convertList:(NSDictionary*)arguments{
    NSString *coordType = [arguments objectForKey:@"coordType"];
    NSArray *srcCoordList = [arguments objectForKey:@"srcCoordList"];
    BMK_COORD_TYPE srcType;
    if ([@"GPS" isEqualToString:coordType]) {
        srcType = BMK_COORDTYPE_GPS;
    }else if ([@"GCJ02" isEqualToString:coordType]) {
        srcType = BMK_COORDTYPE_COMMON;
    }else {
        srcType = BMK_COORDTYPE_GPS;
        NSLog(@"Unknown coordtype for:%@.", coordType);
    }
    NSMutableArray *destCoordList = [[NSMutableArray alloc] initWithCapacity:srcCoordList.count];
    for (NSDictionary *coord in srcCoordList) {
        [destCoordList addObject: [self convert:coord srcType:srcType]];
    }
    return destCoordList;
}

/**
 *将其他坐标转换为百度经纬度坐标.
 */
- (NSDictionary*)convert:(NSDictionary *)srcCoord srcType:(BMK_COORD_TYPE)srcType{
    double latitude = [[srcCoord objectForKey:@"latitude"] doubleValue];
    double longitude = [[srcCoord objectForKey:@"longitude"] doubleValue];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    CLLocationCoordinate2D coord = BMKCoordTrans(coordinate, srcType, BMK_COORDTYPE_BD09LL);
    NSDictionary *coordDictionary = @{
        @"latitude": [NSNumber numberWithDouble:coord.latitude],
        @"longitude": [NSNumber numberWithDouble:coord.longitude]
    };
    return coordDictionary;
}

/**
 *计算两点间的距离.
 */
- (double)getDistance:(NSDictionary*)arguments{
    NSDictionary *from = [arguments objectForKey:@"from"];
    NSDictionary *to = [arguments objectForKey:@"to"];
    double fromLatitude = ((NSNumber*)[from objectForKey:@"latitude"]).doubleValue;
    double fromLongitude = ((NSNumber*)[from objectForKey:@"longitude"]).doubleValue;
    double toLatitude = ((NSNumber*)[to objectForKey:@"latitude"]).doubleValue;
    double toLongitude = ((NSNumber*)[to objectForKey:@"longitude"]).doubleValue;
    BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(fromLatitude,fromLongitude));
    BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(toLatitude,toLongitude));
    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
    return distance;
}

/**
 *获取折线上与折线外指定位置最近点.
 */
- (NSDictionary*)getNearestPointFromLine:(NSDictionary*)arguments{
    NSArray<NSDictionary*> *pointList = [arguments objectForKey:@"points"];
    NSDictionary *point = [arguments objectForKey:@"point"];
    double pLatitude = ((NSNumber*)[point objectForKey:@"latitude"]).doubleValue;
    double pLongitude = ((NSNumber*)[point objectForKey:@"longitude"]).doubleValue;
    BMKMapPoint mapPoint = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(pLatitude,pLongitude));
    BMKMapPoint polylinePoints[pointList.count];
    for (int i = 0; i < pointList.count; i++) {
        NSDictionary *coordinate = [pointList objectAtIndex:i];
        double latitude = ((NSNumber*)[coordinate objectForKey:@"latitude"]).doubleValue;
        double longitude = ((NSNumber*)[coordinate objectForKey:@"longitude"]).doubleValue;
        polylinePoints[i] = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(latitude,longitude));
    }
    BMKMapPoint nearestPoint = BMKGetNearestMapPointFromPolyline(mapPoint, polylinePoints, pointList.count);
    NSMutableDictionary *nearestPointResult = [[NSMutableDictionary alloc] initWithCapacity:2];
    [nearestPointResult setObject:[NSNumber numberWithDouble:nearestPoint.x] forKey:@"latitude"];
    [nearestPointResult setObject:[NSNumber numberWithDouble:nearestPoint.y] forKey:@"longitude"];
    return nearestPointResult;
}

/**
 *判断点与多边形位置关系.
 *@return BOOL YES代表点在多边形内, NO 反之.
 */
- (BOOL)isPolygonContainsPoint:(NSDictionary*)arguments{
    NSArray<NSDictionary*> *pointList = [arguments objectForKey:@"points"];
    NSDictionary *point = [arguments objectForKey:@"point"];
    double pLatitude = ((NSNumber*)[point objectForKey:@"latitude"]).doubleValue;
    double pLongitude = ((NSNumber*)[point objectForKey:@"longitude"]).doubleValue;
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(pLatitude,pLongitude);
    CLLocationCoordinate2D coords[pointList.count];
    for (int i = 0; i < pointList.count; i++) {
        NSDictionary *coordinate = [pointList objectAtIndex:i];
        double latitude = ((NSNumber*)[coordinate objectForKey:@"latitude"]).doubleValue;
        double longitude = ((NSNumber*)[coordinate objectForKey:@"longitude"]).doubleValue;
        coords[i] = CLLocationCoordinate2DMake(latitude,longitude);
    }
    return BMKPolygonContainsCoordinate(coord, coords, pointList.count);
}

/**
 *判断点与圆位置关系.
 *@return BOOL YES代表点在圆内, NO 反之.
 */
- (BOOL)isCircleContainsPoint:(NSDictionary*)arguments{
    NSDictionary *center = [arguments objectForKey:@"center"];
    NSDictionary *point = [arguments objectForKey:@"point"];
    int radius = ((NSNumber*)[arguments objectForKey:@"radius"]).intValue;
    double cLatitude = ((NSNumber*)[center objectForKey:@"latitude"]).doubleValue;
    double cLongitude = ((NSNumber*)[center objectForKey:@"longitude"]).doubleValue;
    double pLatitude = ((NSNumber*)[point objectForKey:@"latitude"]).doubleValue;
    double pLongitude = ((NSNumber*)[point objectForKey:@"longitude"]).doubleValue;
    CLLocationCoordinate2D pointCoord = CLLocationCoordinate2DMake(pLatitude,pLongitude);
    CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake(cLatitude,cLongitude);
    return BMKCircleContainsCoordinate(pointCoord, centerCoord, radius);
}
@end
