//
//  FlutterBMapPlugin.m
//  flutter_bmap_plugin
//
//  Created by iMac on 2019/10/22.
//

#import "FlutterBMapPlugin.h"
#import "LocationHandlers.h"
#import "FunctionRegistry.h"
#import "MethodHandler.h"
#import "BMapViewFactory.h"
#define BMAPVIEW_REGISTRY_NAME  @"com.chuangdun.flutter/BMapApi.FlutterBMapView"
#define LOCATION_CHANEL_NAME @"com.chuangdun.flutter/BMapApi.LocationClient"
#define COORDINATE_CHANEL_NAME @"com.chuangdun.flutter/BMapApi.Utils"

static NSObject <FlutterPluginRegistrar> *_registrar;
static FlutterMethodChannel *_methodChannel;

static FlutterEventChannel *_locEventChannel;
static FlutterEventSink _eventSink;
static id _arguments;

@interface FlutterBMapPlugin ()<FlutterStreamHandler, BMKLocationAuthDelegate>
@end
@implementation FlutterBMapPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    BMKMapManager *mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [mapManager start:@"2pE6g2BOaObmjiNh2QUGfFBgQE8zSB2V"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:@"2pE6g2BOaObmjiNh2QUGfFBgQE8zSB2V" authDelegate:self];
    _registrar = registrar;
//  FlutterMethodChannel* bMapViewChannel = [FlutterMethodChannel
//      methodChannelWithName:BMAPVIEW_REGISTRY_NAME
//            binaryMessenger:[registrar messenger]];
//    [bMapViewChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
//
//    }];
   
    FlutterMethodChannel* locationChannel = [FlutterMethodChannel
    methodChannelWithName:LOCATION_CHANEL_NAME
          binaryMessenger:[registrar messenger]];
    
    [locationChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
       NSObject <LocationMethodHandler> *handler = [LocationFunctionRegistry locationMethodHandler][call.method];
        if (handler) {
            [[handler init] onMethodCall:call :result];
           
        } else {
            result(FlutterMethodNotImplemented);
        }
    }];
    _methodChannel = locationChannel;
    FlutterEventChannel *locEventChannel = [FlutterEventChannel eventChannelWithName:@"com.chuangdun.flutter/BMapApi.LocationChanged"
                                                             binaryMessenger:[registrar messenger]];
    NSObject<FlutterStreamHandler> * Streamhandler = [LocationFunctionRegistry locationEventsHandler][@"init"];
    [locEventChannel setStreamHandler:Streamhandler];
    
    FlutterMethodChannel* utilsChannel = [FlutterMethodChannel
    methodChannelWithName:COORDINATE_CHANEL_NAME
          binaryMessenger:[registrar messenger]];
    [utilsChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        
    }];
    
    //生成注册类
    BMapViewFactory* viewFactory = [[BMapViewFactory alloc] initWithMessenger:registrar.messenger];
    //生成视图工厂
    [registrar registerViewFactory:viewFactory withId:BMAPVIEW_REGISTRY_NAME];
}

+ (NSObject <FlutterPluginRegistrar> *)registrar {
    return _registrar;
}

+ (FlutterMethodChannel *)methodChannel
{
    return _methodChannel;
}

+ (FlutterEventChannel *)locEventChannel
{
    return _locEventChannel;
}
+ (FlutterEventSink)eventSink
{
    return _eventSink;
}
+ (id)arguments
{
    return _arguments;
}
@end
