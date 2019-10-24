//
//  FunctionRegistry.m
//  flutter_bmap_plugin
//
//  Created by iMac on 2019/10/18.
//

#import "FunctionRegistry.h"
#import "MethodHandler.h"
#import "LocationHandlers.h"
#import "MapHandlers.h"

static NSDictionary<NSString *, NSObject <MapMethodHandler> *> *_mapDictionary;
static NSDictionary<NSString *, NSObject <MapEventsHandler> *> *_mapEventDictionary;
@implementation MapFunctionRegistry {
}

+ (NSDictionary<NSString *, NSObject <MapMethodHandler> *> *)mapMethodHandler {
    if (!_mapDictionary) {
        _mapDictionary = @{
                @"setMapViewResume": [SetMapViewResume alloc],
                @"setMapViewPause": [SetMapViewPause alloc],
                @"setMapViewDestroy": [SetMapViewDestroy alloc],
                @"addMarkers": [AddMarkers alloc],
                @"addTexts": [AddTexts alloc],
                @"addTexturePolyline": [AddTexturePolyline alloc],
                @"hideInfoWindow": [HideInfoWindow alloc],
                @"showInfoWindow": [ShowInfoWindow alloc],
                @"animateMapStatusNewLatLng": [AnimateMapStatusNewLatLng alloc],
                @"animateMapStatusNewBounds": [AnimateMapStatusNewBounds alloc],
                @"animateMapStatusNewBoundsPadding": [AnimateMapStatusNewBoundsPadding alloc],
                @"animateMapStatusNewBoundsZoom": [AnimateMapStatusNewBoundsZoom alloc],
                @"clearMap": [ClearMap alloc],
               
        };
    }
    return _mapDictionary;
}
+ (NSDictionary<NSString *, NSObject <MapEventsHandler> *> *)mapEventsHandler {
    if (!_mapEventDictionary) {
        _mapEventDictionary = @{
                @"mapInit": [MapInit alloc],
        };
    }
    return _mapEventDictionary;
}
@end

static NSDictionary<NSString *, NSObject <LocationMethodHandler> *> *_locationDictionary;
static NSDictionary<NSString *, NSObject <LocationEventsHandler> *> *_locationEventDictionary;
@implementation LocationFunctionRegistry {

}
+ (NSDictionary<NSString *, NSObject <LocationMethodHandler> *> *)locationMethodHandler {
    if (!_locationDictionary) {
        _locationDictionary = @{
                @"isStart": [IsStart alloc],
                @"startLocation": [StartLocation alloc],
                @"requestLocation": [RequestLocation alloc],
                @"stopLocation": [StopLocation alloc]
        };
    }
    return _locationDictionary;
}
+ (NSDictionary<NSString *, NSObject <LocationEventsHandler> *> *)locationEventsHandler {
    if (!_locationEventDictionary) {
        _locationEventDictionary = @{
                @"init": [Init alloc],
        };
    }
    return _locationEventDictionary;
}
@end
