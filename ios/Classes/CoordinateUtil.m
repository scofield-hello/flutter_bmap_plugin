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
        result(FlutterMethodNotImplemented);
    }else if ([CoordCalculateAreaMethod isEqualToString:call.method]) {
        result(FlutterMethodNotImplemented);
    }else if ([CoordGetNearestPointFromLineMethod isEqualToString:call.method]) {
        result(FlutterMethodNotImplemented);
    }else if ([CoordIsPolygonContainsPointMethod isEqualToString:call.method]) {
        result(FlutterMethodNotImplemented);
    }else if ([CoordIsCircleContainsPointMethod isEqualToString:call.method]) {
        result(FlutterMethodNotImplemented);
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


@end
