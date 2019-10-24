//
// Created by Yohom Bao on 2018-12-15.
//

#import <Foundation/Foundation.h>
#import "MethodHandler.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BaiduMapAPI_Map//BMKPinAnnotationView.h>
@interface MapInit : NSObject<MapEventsHandler>
@end

@interface SetMapViewResume : NSObject <MapMethodHandler>
@end

@interface SetMapViewPause : NSObject <MapMethodHandler>
@end

@interface SetMapViewDestroy : NSObject <MapMethodHandler>
@end

#pragma mark - 标注点
@interface AddMarkers : NSObject <MapMethodHandler>
@end

@interface AddTexts : NSObject <MapMethodHandler>
@end

#pragma mark - 轨迹
@interface AddTexturePolyline : NSObject <MapMethodHandler>
@end

@interface HideInfoWindow : NSObject <MapMethodHandler>
@end

@interface ShowInfoWindow : NSObject <MapMethodHandler>
@end

@interface AnimateMapStatusNewLatLng : NSObject <MapMethodHandler, BMKMapViewDelegate>
@end

@interface AnimateMapStatusNewBounds : NSObject <MapMethodHandler>
@end

@interface AnimateMapStatusNewBoundsPadding : NSObject <MapMethodHandler>
@end

@interface AnimateMapStatusNewBoundsZoom : NSObject <MapMethodHandler>
@end

@interface ClearMap : NSObject <MapMethodHandler>
@end

