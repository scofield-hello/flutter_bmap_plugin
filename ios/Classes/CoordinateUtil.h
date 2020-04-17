//
//  CoordinateUtil.h
//  flutter_bmap_plugin
//
//  Created by Nick on 2020/4/6.
//

#import <Foundation/Foundation.h>
#import "MethodCallDelegate.h"

NS_ASSUME_NONNULL_BEGIN
extern NSString * const CoordConvertMethod;
extern NSString * const CoordListConvertMethod;
extern NSString * const CoordGetDistanceMethod;
extern NSString * const CoordCalculateAreaMethod;
extern NSString * const CoordGetNearestPointFromLineMethod;
extern NSString * const CoordIsPolygonContainsPointMethod;
extern NSString * const CoordIsCircleContainsPointMethod;

@interface CoordinateUtil : NSObject <MethodCallDelegate>
/**
 *将WGS84或JCJ02类型的坐标转换为BD09LL坐标.
 */
- (NSDictionary*)convert:(NSDictionary*)arguments;
/**
 *批量将WGS84或JCJ02类型的坐标转换为BD09LL坐标.
 */
- (NSArray*)convertList:(NSDictionary*)arguments;
@end

NS_ASSUME_NONNULL_END
