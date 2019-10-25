//
//  UtilsHandlers.h
//  flutter_bmap_plugin
//
//  Created by iMac on 2019/10/25.
//

#import <Foundation/Foundation.h>
#import "MethodHandler.h"
#import "BMKLocationComponent.h"
NS_ASSUME_NONNULL_BEGIN

#pragma mark -将指定类型坐标转换成百度坐标
@interface Convert : NSObject<UtilsMethodHandler>
@end

#pragma mark -将指定类型坐标列表转换成百度坐标.
@interface ConvertList : NSObject<UtilsMethodHandler>
@end

#pragma mark - 计算两点之间的距离,单位米.
@interface GetDistance : NSObject <UtilsMethodHandler>
@end

#pragma mark - 计算地图上矩形区域的面积，单位平方米.
@interface Northeast : NSObject <UtilsMethodHandler, BMKLocationManagerDelegate>
@end

#pragma mark - 返回某点距线上最近的点.
@interface GetNearestPointFromLine : NSObject <UtilsMethodHandler, BMKLocationManagerDelegate>
@end

#pragma mark - 返回一个点是否在一个多边形区域内.
@interface IsPolygonContainsPoint : NSObject <UtilsMethodHandler>
@end

#pragma mark - 判断圆形是否包含传入的经纬度点.
@interface IsCircleContainsPoint : NSObject <UtilsMethodHandler>
@end

NS_ASSUME_NONNULL_END
