//
//  MethodHandler.h
//  flutter_bmap_plugin
//
//  Created by iMac on 2019/10/18.
//
#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
NS_ASSUME_NONNULL_BEGIN

@class FlutterMethodCall;

//region 地图
@protocol MapMethodHandler <NSObject>
@required
- (NSObject <MapMethodHandler> *)initWith:(BMKMapView *)mapView;
@required
- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result;
@end

@protocol MapEventsHandler <NSObject>
@required
- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events;
@required
- (FlutterError *_Nullable)onCancelWithArguments:(id _Nullable)arguments;
@end

//region 定位
@protocol LocationMethodHandler <NSObject>
@required
- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result;
@end

@protocol LocationEventsHandler <NSObject>
@required
- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events;
@required
- (FlutterError *_Nullable)onCancelWithArguments:(id _Nullable)arguments;
@end

//region 工具
@protocol UtilsMethodHandler <NSObject>
@required
- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result;
@end

NS_ASSUME_NONNULL_END
