//
// Created by Yohom Bao on 2018-12-15.
//

#import <Foundation/Foundation.h>
#import "MethodHandler.h"
#import "BMKLocationComponent.h"

@class BMKLocationManager;
#pragma mark - 初始化

@interface Init : NSObject<LocationEventsHandler>
@end

#pragma mark - 是否开启定位

@interface IsStart : NSObject <LocationMethodHandler>
@end

#pragma mark - 连续定位

@interface StartLocation : NSObject <LocationMethodHandler, BMKLocationManagerDelegate>
@end

#pragma mark - 单次定位

@interface RequestLocation : NSObject <LocationMethodHandler, BMKLocationManagerDelegate>
@end

#pragma mark - 结束定位
@interface StopLocation : NSObject <LocationMethodHandler>
@end
