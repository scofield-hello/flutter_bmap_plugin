//
// Created by Yohom Bao on 2018-12-15.
//

#import "MapHandlers.h"
#import "MJExtension.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BaiduMapAPI_Map//BMKPinAnnotationView.h>
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
}

- (NSObject <MapMethodHandler> *)initWith:(BMKMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {

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

}
@end

@implementation AddTexturePolyline {
    BMKMapView *_mapView;
}

- (NSObject <MapMethodHandler> *)initWith:(BMKMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {

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
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = CLLocationCoordinate2DMake([paramDic[@"center"][@"latitude"] doubleValue], [paramDic[@"center"][@"longitude"] doubleValue]);
    //设置标注的标题
    annotation.title = @"北京";
    //副标题
    annotation.subtitle = @"天安门";
    [_mapView addAnnotation:annotation];
   
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

        annotationView.image = [UIImage imageNamed:@"poi.png"];
        return annotationView;
    }
    return nil;
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

