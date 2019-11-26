//
//  BMapViewFactory.m
//  flutter_bmap_plugin
//
//  Created by iMac on 2019/10/23.
//

#import "BMapViewFactory.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BMKLocationkit/BMKLocationComponent.h>
#import "FlutterBMapPlugin.h"
#import "MapHandlers.h"
#import "FunctionRegistry.h"
static NSString *MAP_CHANNEL_NAME = @"com.chuangdun.flutter/BMapApi.FlutterBMapView";
static NSString *MAP_MARKER_CLICKE_CHANNEL_NAME = @"com.chuangdun.flutter/BMapApi.FlutterBMapViewEvent";

@implementation BMapViewFactory{
    NSObject<FlutterBinaryMessenger> *_messenger;
}
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messager{
    self = [super init];
    if (self) {
        _messenger = messager;
    }
    return self;
    
}
-(NSObject<FlutterMessageCodec> *)createArgsCodec{
    return [FlutterStandardMessageCodec sharedInstance];
    
}

-(NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args{
    BMapView *activity = [[BMapView alloc] initWithWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
    return activity;
    
}
@end

@implementation BMapView{
    BMKMapView *_mapView;
    FlutterMethodChannel *_methodChannel;
    FlutterEventChannel *_markerClickedEventChannel;
    MapInit *_eventHandler;
    int64_t _viewId;
}
//创建原生视图
- (instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject *)messenger{
    if ([super init])
    {
        NSLog(@"----- %@", args);
          _mapView = [[BMKMapView alloc] initWithFrame:frame];
          _mapView.delegate = self;
          _viewId = viewId;
         _mapView.logoPosition = BMKLogoPositionRightBottom;
           _mapView.zoomLevel = 12;
           _methodChannel = [FlutterMethodChannel methodChannelWithName:[NSString stringWithFormat:@"%@_%lld", MAP_CHANNEL_NAME, _viewId]
                                                         binaryMessenger:[FlutterBMapPlugin registrar].messenger];
            __weak __typeof__(self) weakSelf = self;
            [_methodChannel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
              NSObject <MapMethodHandler> *handler = [MapFunctionRegistry mapMethodHandler][call.method];
              if (handler) {
                __typeof__(self) strongSelf = weakSelf;
                [[handler initWith:strongSelf->_mapView] onMethodCall:call :result];
              } else {
                result(FlutterMethodNotImplemented);
              }
            }];
           NSLog(@"%@", [NSString stringWithFormat:@"%@_%lld", MAP_MARKER_CLICKE_CHANNEL_NAME, _viewId]);
            _eventHandler = [[MapInit alloc] init];
            _markerClickedEventChannel = [FlutterEventChannel eventChannelWithName:[NSString stringWithFormat:@"%@_%lld", MAP_MARKER_CLICKE_CHANNEL_NAME, _viewId]
                                                                   binaryMessenger:[FlutterBMapPlugin registrar].messenger];
           NSObject<FlutterStreamHandler> * Streamhandler = [MapFunctionRegistry mapEventsHandler][@"mapInit"];
              [_markerClickedEventChannel setStreamHandler:Streamhandler];
        
    }
    return self;
}
-(UIView *)view{
    return _mapView;
}

@end
