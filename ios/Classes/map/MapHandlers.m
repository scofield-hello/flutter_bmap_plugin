//
// Created by Yohom Bao on 2018-12-15.
//

#import "MapHandlers.h"
#import "MJExtension.h"
#import "UnifiedAssets.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BaiduMapAPI_Map//BMKPinAnnotationView.h>
#import <BaiduMapAPI_Map/BMKOverlay.h>
#import <BaiduMapAPI_Map/BMKPolylineView.h>
@implementation MapInit {
    
}
- (instancetype)init {
    self = [super init];
    if (self) {
       
    }

    return self;
}
-(FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events
{
    return nil;
}
-(FlutterError *)onCancelWithArguments:(id)arguments
{
    return nil;
}
@end

@implementation SetMapViewResume {
    BMKMapView *_mapView;
}

- (NSObject <MapMethodHandler> *)initWith:(BMKMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {

}
@end

@implementation SetMapViewPause {
    BMKMapView *_mapView;
}

- (NSObject <MapMethodHandler> *)initWith:(BMKMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {

}
@end

@implementation SetMapViewDestroy {
    BMKMapView *_mapView;
}

- (NSObject <MapMethodHandler> *)initWith:(BMKMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {

}
@end

@implementation AddMarkers {
    BMKMapView *_mapView;
    NSMutableArray *_iconArr;
    
}

- (NSObject <MapMethodHandler> *)initWith:(BMKMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    NSLog(@"-----addmarkers------ %@", call.arguments);
    _mapView.zoomLevel = 18;
    _mapView.delegate = self;
    NSArray *paramArr = call.arguments;
    _iconArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i =0; i< paramArr.count; i++) {
        NSDictionary *dic = paramArr[i];
        [_iconArr addObject:dic[@"icon"]];
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        annotation.title = dic[@"extraInfo"][@"name"];
        annotation.subtitle = dic[@"extraInfo"][@"address"];
        annotation.coordinate = CLLocationCoordinate2DMake([dic[@"position"][@"latitude"] doubleValue], [dic[@"position"][@"longitude"] doubleValue]);
        [_mapView addAnnotation:annotation];
    }

}
#pragma mark - BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        BMKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation
                                                              reuseIdentifier:reuseIndetifier];
        }
        for (int i = 0; i < _iconArr.count; i++) {
           annotationView.image =  [UIImage imageWithContentsOfFile:[UnifiedAssets getAssetPath:_iconArr[i]]];
        }
        
        return annotationView;
    }
    return nil;
}

- (void)addAnnotations:(NSArray *)annotations;
{
    
}
@end

@implementation AddTexts {
    BMKMapView *_mapView;
}

- (NSObject <MapMethodHandler> *)initWith:(BMKMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
      NSLog(@"-----AddTexts------ %@", call.arguments);
}
@end

@implementation AddTexturePolyline {
    BMKMapView *_mapView;
    NSMutableArray *_iconArr;
}

- (NSObject <MapMethodHandler> *)initWith:(BMKMapView *)mapView {
    _mapView = mapView;
    
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
      NSLog(@"-----AddTexturePolyline------ %@", call.arguments);
    NSDictionary *parmDic = call.arguments;
    NSArray *textList = parmDic[@"textureIndex"];
  _iconArr = [[NSMutableArray alloc] initWithCapacity:0];
    [_iconArr addObject:parmDic[@"customTextureList"]];
    _mapView.delegate = self;
    _mapView.zoomLevel = 18;
    //构建顶点数组
    
    NSArray *coordsList = parmDic[@"points"];
    
    CLLocationCoordinate2D coords[1000] = {0};
    for (int i = 0; i < coordsList.count; i++) {
        NSDictionary *dic = coordsList[i];
        
      coords[i] = CLLocationCoordinate2DMake([dic[@"latitude"] doubleValue], [dic[@"longitude"] doubleValue]);
    }
    BMKPolyline *polyline  = [BMKPolyline polylineWithCoordinates:coords count:coordsList.count textureIndex:textList];
    [_mapView addOverlay:polyline];
}
//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]){
           BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithPolyline:overlay];
           //设置polylineView的画笔宽度为12
             polylineView.lineWidth = 10;
            /**
             *加载分段纹理绘制 所需的纹理图片
             @param textureImages 必须UIImage数组，opengl要求图片宽高必须是2的n次幂，否则，返回NO，无法分段纹理绘制
             @return 是否成功
             */
        
            [polylineView loadStrokeTextureImages:@[[UIImage imageNamed:@"Icon_road_blue_arrow.png"],
                                                    [UIImage imageNamed:@"Icon_road_green_arrow.png"],
                                                    [UIImage imageNamed:@"Icon_road_red_arrow.png"],
                                                    [UIImage imageNamed:@"Icon_road_yellow_arrow.png"]]];
             //拐角处尖角衔接，V5.0.0新增
 //           polylineView.lineJoinType = kBMKLineJoinMiter;//尖角
 //            polylineView.lineJoinType = kBMKLineJoinRound//圆角
            return polylineView;
    }
    return nil;
}

@end

@implementation HideInfoWindow {
    BMKMapView *_mapView;
}

- (NSObject <MapMethodHandler> *)initWith:(BMKMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {

}
@end

@implementation ShowInfoWindow {
    BMKMapView *_mapView;
}

- (NSObject <MapMethodHandler> *)initWith:(BMKMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {

}
@end

@implementation AnimateMapStatusNewLatLng {
    BMKMapView *_mapView;
}

- (NSObject <MapMethodHandler> *)initWith:(BMKMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
     NSDictionary *paramDic = call.arguments;
    _mapView.showsUserLocation = YES;
    _mapView.zoomLevel = 16;
    _mapView.centerCoordinate = CLLocationCoordinate2DMake([paramDic[@"center"][@"latitude"] doubleValue], [paramDic[@"center"][@"longitude"] doubleValue]);
    
   
}

@end

@implementation AnimateMapStatusNewBounds {
    BMKMapView *_mapView;
}

- (NSObject <MapMethodHandler> *)initWith:(BMKMapView *)mapView {
    _mapView = mapView;
    return self;
}


- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {

}
@end

@implementation AnimateMapStatusNewBoundsPadding {
    BMKMapView *_mapView;
}

- (NSObject <MapMethodHandler> *)initWith:(BMKMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {

}
@end

@implementation AnimateMapStatusNewBoundsZoom {
    BMKMapView *_mapView;
}

- (NSObject <MapMethodHandler> *)initWith:(BMKMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {

}
@end

@implementation ClearMap {
    BMKMapView *_mapView;
}

- (NSObject <MapMethodHandler> *)initWith:(BMKMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    [_mapView removeOverlays:_mapView.overlays];
    [_mapView removeAnnotations:_mapView.annotations];
}
@end

