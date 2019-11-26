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
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BMKLocationKit/BMKLocationComponent.h>
#define BMAPVIEW_REGISTRY_NAME  @"com.chuangdun.flutter/BMapApi.FlutterBMapView"
#define LOCATION_CHANEL_NAME @"com.chuangdun.flutter/BMapApi.LocationClient"
#define COORDINATE_CHANEL_NAME @"com.chuangdun.flutter/BMapApi.Utils"

static NSObject <FlutterPluginRegistrar> *_registrar;

@interface FlutterBMapPlugin ()<BMKLocationAuthDelegate>
@end
@implementation FlutterBMapPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    
    //百度地图key
    BMKMapManager *mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [mapManager start:@"jCMNGMFPf795bxXwhNYaeTbcgfAQOzqd"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }else{
      NSLog(@"manager start 成功!");
    }
    
    //定位key
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:@"jCMNGMFPf795bxXwhNYaeTbcgfAQOzqd" authDelegate:self];
    
    _registrar = registrar;

    
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
    FlutterEventChannel *locEventChannel = [FlutterEventChannel eventChannelWithName:@"com.chuangdun.flutter/BMapApi.LocationChanged"
                                                             binaryMessenger:[registrar messenger]];
    NSObject<FlutterStreamHandler> * Streamhandler = [LocationFunctionRegistry locationEventsHandler][@"init"];
    [locEventChannel setStreamHandler:Streamhandler];
    
    FlutterMethodChannel* utilsChannel = [FlutterMethodChannel
    methodChannelWithName:COORDINATE_CHANEL_NAME
          binaryMessenger:[registrar messenger]];
    [utilsChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        NSObject <UtilsMethodHandler> *handler = [UtilsFunctionRegistry utilsMethodHandler][call.method];
               if (handler) {
                   [[handler init] onMethodCall:call :result];
                  
               } else {
                   result(FlutterMethodNotImplemented);
               }
    }];
    
    //生成注册类
    BMapViewFactory* viewFactory = [[BMapViewFactory alloc] initWithMessenger:registrar.messenger];
    //生成视图工厂
    [registrar registerViewFactory:viewFactory withId:BMAPVIEW_REGISTRY_NAME];
}

+ (NSObject <FlutterPluginRegistrar> *)registrar {
    return _registrar;
}



@end
