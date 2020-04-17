//
//  FlutterBMapView.m
//  flutter_bmap_plugin
//
//  Created by Nick on 2020/4/12.
//
#import <Flutter/Flutter.h>
#import "FlutterBMapView.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "CDPointAnnotation.h"
#import "CDPolyline.h"
#import "BMapViewCons.h"
@interface FlutterBMapView()<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView;
@end

@implementation FlutterBMapView{
}

- (instancetype)initWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args messager:(NSObject<FlutterBinaryMessenger> *)messager{
    self = [super init];
    if (self) {
        self.mapView = [[BMKMapView alloc]initWithFrame:frame];
        self.mapView.delegate = self;
        NSDictionary *createParams = (NSDictionary*)args;
        NSLog(@"create BMKMapView with args: %@", createParams);
        NSString *logoPositionName = [createParams objectForKey:@"logoPosition"];
        if ([@"logoPostionleftBottom" isEqualToString:logoPositionName]){
            [self.mapView setLogoPosition:BMKLogoPositionLeftBottom];
        }else if ([@"logoPostionleftTop" isEqualToString:logoPositionName]){
            [self.mapView setLogoPosition:BMKLogoPositionLeftTop];
        }else if ([@"logoPostionCenterBottom" isEqualToString:logoPositionName]){
            [self.mapView setLogoPosition:BMKLogoPositionCenterBottom];
        }else if ([@"logoPostionCenterTop" isEqualToString:logoPositionName]){
            [self.mapView setLogoPosition:BMKLogoPositionCenterTop];
        }else if ([@"logoPostionRightBottom" isEqualToString:logoPositionName]){
            [self.mapView setLogoPosition:BMKLogoPositionRightBottom];
        }else if ([@"logoPostionRightTop" isEqualToString:logoPositionName]){
            [self.mapView setLogoPosition:BMKLogoPositionRightBottom];
        }else{
            [self.mapView setLogoPosition:BMKLogoPositionLeftBottom];
        }
        int mapTypeId = ((NSNumber *)[createParams objectForKey:@"mapType"]).intValue;
        if (mapTypeId == 1) {
            [self.mapView setMapType:BMKMapTypeStandard];
        }else if (mapTypeId == 2) {
            [self.mapView setMapType:BMKMapTypeSatellite];
        }else{
            [self.mapView setMapType:BMKMapTypeNone];
        }
        BOOL overlookingEnabled = ((NSNumber *)[createParams objectForKey:@"overlookingGesturesEnabled"]).boolValue;
        NSLog(@"overlookingEnabled:%d", overlookingEnabled);
        [self.mapView setOverlookEnabled:overlookingEnabled];
        BOOL rotateEnabled = ((NSNumber *)[createParams objectForKey:@"rotateGesturesEnabled"]).boolValue;
        NSLog(@"rotateEnable:%d", rotateEnabled);
        [self.mapView setRotateEnabled:rotateEnabled];
        BOOL showMapScaleBar = ((NSNumber *)[createParams objectForKey:@"scaleControlEnabled"]).boolValue;
        NSLog(@"showMapScaleBar:%d", showMapScaleBar);
        [self.mapView setShowMapScaleBar:showMapScaleBar];
        BOOL scrollEnabled = ((NSNumber *)[createParams objectForKey:@"scrollGesturesEnabled"]).boolValue;
        NSLog(@"scrollEnabled:%d", scrollEnabled);
        [self.mapView setScrollEnabled:scrollEnabled];
        BOOL zoomEnabled = ((NSNumber *)[createParams objectForKey:@"zoomControlsEnabled"]).boolValue;
        NSLog(@"zoomEnabled:%d", zoomEnabled);
        [self.mapView setZoomEnabled:zoomEnabled];
        BOOL zoomEnabledWithTap = ((NSNumber *)[createParams objectForKey:@"zoomGesturesEnabled"]).boolValue;
        NSLog(@"zoomEnabledWithTap:%d", zoomEnabledWithTap);
        [self.mapView setZoomEnabledWithTap:zoomEnabledWithTap];
        NSDictionary *mapStatutsData = [createParams objectForKey:@"mapStatus"];
        if (mapStatutsData) {
            float overlook = ((NSNumber*)[mapStatutsData objectForKey:@"overlook"]).floatValue;
            float rotate = ((NSNumber*)[mapStatutsData objectForKey:@"rotate"]).floatValue;
            float zoom = ((NSNumber*)[mapStatutsData objectForKey:@"zoom"]).floatValue;
            NSDictionary *target = (NSDictionary *)[mapStatutsData objectForKey:@"target"];
            double latitude = ((NSNumber*)[target objectForKey:@"latitude"]).doubleValue;
            double longitude = ((NSNumber*)[target objectForKey:@"longitude"]).doubleValue;
            BMKMapStatus *mapStatus = [[BMKMapStatus alloc]init];
            [mapStatus setFLevel:zoom];
            [mapStatus setFRotation:rotate];
            [mapStatus setFOverlooking:overlook];
            [mapStatus setTargetGeoPt:CLLocationCoordinate2DMake(latitude, longitude)];
            [self.mapView setMapStatus:mapStatus];
        }
    }
    NSString *channelName = [NSString stringWithFormat:@"%@_%lld", CDBMapViewRegistry, viewId];
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messager];
    __weak FlutterBMapView *weakRef = self;
    [channel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result){
        NSLog(@"onMethodCall method name: %@ with args: %@", call.method, call.arguments);
        FlutterBMapView *innerRef = weakRef;
        if ([CDBMapViewPause isEqualToString:call.method]) {
            [innerRef setMapViewWillDisappear];
            result(nil);
        }else if ([CDBMapViewResume isEqualToString:call.method]) {
            [innerRef setMapViewWillAppear];
            result(nil);
        }else if ([CDBMapViewDestroy isEqualToString:call.method]) {
            result(nil);
        }else if ([CDBMapViewAddMarkers isEqualToString:call.method]) {
            NSArray *markerOptions = (NSArray*)call.arguments;
            for (NSDictionary *markerOption in markerOptions) {
                NSDictionary *position = [markerOption objectForKey:@"position"];
                double latitude = ((NSNumber*)[position objectForKey:@"latitude"]).doubleValue;
                double longitude = ((NSNumber*)[position objectForKey:@"longitude"]).doubleValue;
                NSString *title = [markerOption objectForKey:@"title"];
                NSString *subtitle = [markerOption objectForKey:@"subtitle"];
                BOOL draggable = ((NSNumber*)[markerOption objectForKey:@"draggable"]).boolValue;
                NSString *icon = [markerOption objectForKey:@"icon"];
                NSString *animateType = [markerOption objectForKey:@"animateType"];
                float alpha = ((NSNumber*)[markerOption objectForKey:@"alpha"]).floatValue;
                BOOL perspective = ((NSNumber*)[markerOption objectForKey:@"perspective"]).boolValue;
                BOOL flat = ((NSNumber*)[markerOption objectForKey:@"flat"]).boolValue;
                double rotate = ((NSNumber*)[markerOption objectForKey:@"rotate"]).doubleValue;
                BOOL visible = ((NSNumber*)[markerOption objectForKey:@"visible"]).boolValue;
                int zIndex = ((NSNumber*)[markerOption objectForKey:@"zIndex"]).intValue;
                NSDictionary *extraInfo = [markerOption objectForKey:@"extraInfo"];
                CDPointAnnotation *annotaion =[[CDPointAnnotation alloc]init];
                annotaion.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
                annotaion.title = title;
                annotaion.subtitle = subtitle;
                annotaion.draggable = draggable;
                annotaion.icon = icon;
                annotaion.animateType = animateType;
                annotaion.alpha = alpha;
                annotaion.perspective = perspective;
                annotaion.flat = flat;
                annotaion.rotate = rotate;
                annotaion.visible = visible;
                annotaion.zIndex = zIndex;
                annotaion.extraInfo = extraInfo;
                [innerRef.mapView addAnnotation:annotaion];
            }
        }else if ([CDBMapViewAnimateMapStatusNewLatLng isEqualToString:call.method]) {
            NSDictionary *mapStatusData = (NSDictionary*)call.arguments;
            NSDictionary *center = [mapStatusData objectForKey:@"center"];
            double latitude = ((NSNumber*)[center objectForKey:@"latitude"]).doubleValue;
            double longitude = ((NSNumber*)[center objectForKey:@"longitude"]).doubleValue;
            float zoom = ((NSNumber*)[mapStatusData objectForKey:@"zoom"]).floatValue;
            BMKMapStatus *mapStatus = [[BMKMapStatus alloc]init];
            if (zoom >= 4.0f) {
                [mapStatus setFLevel:zoom];
            }
            [mapStatus setTargetGeoPt:CLLocationCoordinate2DMake(latitude, longitude)];
            [innerRef.mapView setMapStatus:mapStatus];
        }else if ([CDBMapViewAddTexturePolyline isEqualToString:call.method]) {
            NSDictionary *polylineData = (NSDictionary*)call.arguments;
            NSArray *points = [polylineData objectForKey:@"points"];
            float width = ((NSNumber*)[polylineData objectForKey:@"width"]).floatValue;
            NSArray *customTextureList = [polylineData objectForKey:@"customTextureList"];
            NSArray<NSNumber*> *textureIndex = [polylineData objectForKey:@"textureIndex"];
            BOOL dottedLine = ((NSNumber*)[polylineData objectForKey:@"dottedLine"]).boolValue;
            NSDictionary *extraInfo = [polylineData objectForKey:@"extraInfo"];
            CLLocationCoordinate2D coords[1000] = {0};
            for (int i = 0; i < points.count; i++) {
                NSDictionary *point = [points objectAtIndex:i];
                double latitude = ((NSNumber*)[point objectForKey:@"latitude"]).doubleValue;
                double longitude = ((NSNumber*)[point objectForKey:@"longitude"]).doubleValue;
                coords[i] = CLLocationCoordinate2DMake(latitude, longitude);
            }
            CDPolyline *polyline = [[CDPolyline alloc]init];
            [polyline setPolylineWithCoordinates:coords count:points.count textureIndex:textureIndex];
            [polyline setCustomTextureList:customTextureList];
            [polyline setWidth:width];
            [polyline setDottedLine:dottedLine];
            [polyline setExtraInfo:extraInfo];
            [innerRef.mapView addOverlay:polyline];
        }else if ([CDBMapViewClearMap isEqualToString:call.method]) {
            if (innerRef.mapView.overlays.count > 0) {
                [innerRef.mapView removeOverlays:innerRef.mapView.overlays];
            }
            if (innerRef.mapView.annotations.count > 0) {
                [innerRef.mapView removeAnnotations:innerRef.mapView.annotations];
            }
        }else {
            result(FlutterMethodNotImplemented);
        }
    }];
    return self;
}

#pragma mark FlutterPlatformView delegate

- (UIView*)view{
    return _mapView;
}

- (void)setMapViewWillAppear{
    if (self.mapView) {
        [self.mapView viewWillAppear];
    }
}

- (void)setMapViewWillDisappear{
    if (self.mapView) {
        [self.mapView viewWillDisappear];
    }
}

#pragma mark - BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[CDPointAnnotation class]])
    {   CDPointAnnotation *cdPointAnnotation = (CDPointAnnotation*)annotation;
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        BMKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[BMKAnnotationView alloc] initWithAnnotation:cdPointAnnotation
                                                              reuseIdentifier:reuseIndetifier];
            annotationView.draggable = cdPointAnnotation.draggable;
            annotationView.image = [UIImage imageNamed:cdPointAnnotation.icon];
            annotationView.alpha = cdPointAnnotation.alpha;
        }
        return annotationView;
    }
    return nil;
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay{
     if ([overlay isKindOfClass:[CDPolyline class]]) {
         CDPolyline *cdPolyline = (CDPolyline*) overlay;
         BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithPolyline:cdPolyline];
         polylineView.lineWidth = cdPolyline.width;
         NSMutableArray <UIImage *>* textImages = [[NSMutableArray alloc]initWithCapacity:cdPolyline.customTextureList.count];
         for (NSString *imageName in cdPolyline.customTextureList) {
             [textImages addObject: [UIImage imageNamed:imageName]];
         }
         [polylineView loadStrokeTextureImages:textImages];
         //尖角
         //polylineView.lineJoinType = kBMKLineJoinMiter;
         //圆角
         polylineView.lineJoinType = kBMKLineJoinRound;
         return polylineView;
       }
       return nil;
}
@end
