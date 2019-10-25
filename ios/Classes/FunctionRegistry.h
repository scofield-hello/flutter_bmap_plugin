//
//  FunctionRegistry.h
//  flutter_bmap_plugin
//
//  Created by iMac on 2019/10/18.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
NS_ASSUME_NONNULL_BEGIN
@protocol MapMethodHandler;
@protocol MapEventsHandler;
@interface MapFunctionRegistry : NSObject
+ (NSDictionary<NSString *, NSObject <MapMethodHandler> *> *)mapMethodHandler;
+ (NSDictionary<NSString *, NSObject <MapEventsHandler> *> *)mapEventsHandler;
@end

@protocol LocationMethodHandler;
@protocol LocationEventsHandler;
@interface LocationFunctionRegistry : NSObject
+ (NSDictionary<NSString *, NSObject <LocationMethodHandler> *> *)locationMethodHandler;
+ (NSDictionary<NSString *, NSObject <LocationEventsHandler> *> *)locationEventsHandler;
@end

@protocol UtilsMethodHandler;
@interface UtilsFunctionRegistry : NSObject
+ (NSDictionary<NSString *, NSObject <UtilsMethodHandler> *> *)utilsMethodHandler;
@end

NS_ASSUME_NONNULL_END
