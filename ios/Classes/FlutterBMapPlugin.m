//
//  FlutterBMapPlugin.m
//  flutter_bmap_plugin
//
//  Created by Nick on 2019/10/22.
//

#import "FlutterBMapPlugin.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BMKLocationKit/BMKLocationComponent.h>
#import "LocationMethodHandler.h"
#import "MethodCallDelegate.h"
#import "CoordinateUtil.h"
#import "BMapViewViewFactory.h"
#import "BMapViewCons.h"
#import "LocationCons.h"

static NSObject <FlutterPluginRegistrar> *_registrar;
static FlutterBMapPlugin *instance;

@interface FlutterBMapPlugin ()<BMKLocationAuthDelegate,BMKGeneralDelegate>
@property (nonatomic)id<MethodCallDelegate> locationDelegate;
@property (nonatomic)id<MethodCallDelegate> coordinateDelegate;
@end

@implementation FlutterBMapPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    instance = [[FlutterBMapPlugin alloc] init];
    _registrar = registrar;
    //初始化百度定位SDK,从Info.plist中读取BaiduMap配置
    NSDictionary *infoPlistDict = [[NSBundle mainBundle] infoDictionary];
    NSDictionary *baiduMapConfiguration = [infoPlistDict objectForKey:@"BaiduMap"];
    NSString *sdkKey = [baiduMapConfiguration objectForKey:@"sdk_key"];
    NSLog(@"获取到百度定位SDK Key:%@", sdkKey);
    if(sdkKey && sdkKey.length == 32){
        NSLog(@"初始化百度定位SDK,鉴权中...");
        [[BMKLocationAuth sharedInstance] checkPermisionWithKey:sdkKey
                                                   authDelegate:instance];
        NSLog(@"初始化百度地图SDK,鉴权中...");
        BMKMapManager *mapManager = [[BMKMapManager alloc] init];
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
        BOOL ret = [mapManager start:sdkKey generalDelegate:instance];
        if (!ret) {
            NSLog(@"启动百度地图引擎失败");
        }
    }else{
        NSLog(@"百度定位SDK Key不正确,请在Info.plist中配置正确的值");
    }
    FlutterMethodChannel *locationChannel = [FlutterMethodChannel
                                             methodChannelWithName:CDLocationMethodChannel
                                             binaryMessenger:_registrar.messenger];
    
    FlutterEventChannel *locationEventChannel = [FlutterEventChannel
                                                 eventChannelWithName:CDLocationEventChannel
                                                 binaryMessenger:_registrar.messenger];
    LocationMethodHandler * locationMethodHandler = [[LocationMethodHandler alloc] init];
    [locationEventChannel setStreamHandler:locationMethodHandler];
    instance.locationDelegate = locationMethodHandler;
    __weak FlutterBMapPlugin *flutterBMapPlugin = instance;
    [locationChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result){
        FlutterBMapPlugin *innerInstance = flutterBMapPlugin;
        if(innerInstance.locationDelegate && [innerInstance.locationDelegate respondsToSelector:@selector(onMethodCall:result:)]){
            [innerInstance.locationDelegate onMethodCall:call result:result];
        }
    }];
    CoordinateUtil *coordinateUtil = [[CoordinateUtil alloc] init];
    instance.coordinateDelegate = coordinateUtil;
    FlutterMethodChannel *coordinateChannel = [FlutterMethodChannel
    methodChannelWithName:CDCoordinateMethodChannel
    binaryMessenger:_registrar.messenger];
    [coordinateChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result){
        FlutterBMapPlugin *innerInstance = flutterBMapPlugin;
        if(innerInstance.coordinateDelegate && [innerInstance.coordinateDelegate respondsToSelector:@selector(onMethodCall:result:)]){
            [innerInstance.coordinateDelegate onMethodCall:call result:result];
        }
    }];
    BMapViewViewFactory *viewFactory = [[BMapViewViewFactory alloc]initWithMessager:_registrar.messenger];
    [_registrar registerViewFactory:viewFactory withId:CDBMapViewRegistry];
}

+ (NSObject <FlutterPluginRegistrar> *)registrar {
    return _registrar;
}

#pragma mark - BMKLocationAuthDelegate 实现

- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError{
    NSLog(@"百度定位鉴权结果:%ld", (long)iError);
}

#pragma mark - BMKGeneralDelegate 实现
- (void)onGetPermissionState:(int)iError{
    NSLog(@"百度地图鉴权结果:%ld", (long)iError);
}
@end
