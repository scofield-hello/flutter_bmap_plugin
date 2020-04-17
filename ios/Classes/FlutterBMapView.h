//
//  FlutterBMapView.h
//  flutter_bmap_plugin
//
//  Created by Nick on 2020/4/12.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlutterBMapView : NSObject<FlutterPlatformView>

- (instancetype)initWithFrame:(CGRect)frame
viewIdentifier:(int64_t)viewId
     arguments:(id _Nullable)args
                     messager:(NSObject<FlutterBinaryMessenger>*)messager;
@end

NS_ASSUME_NONNULL_END
