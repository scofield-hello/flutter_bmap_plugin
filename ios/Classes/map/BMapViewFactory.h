//
//  BMapViewFactory.h
//  flutter_bmap_plugin
//
//  Created by iMac on 2019/10/23.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
NS_ASSUME_NONNULL_BEGIN

@interface BMapViewFactory : NSObject<FlutterPlatformViewFactory>
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messager;
@end

@interface BMapView : NSObject<FlutterPlatformView, BMKMapViewDelegate>
- (instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end
NS_ASSUME_NONNULL_END
