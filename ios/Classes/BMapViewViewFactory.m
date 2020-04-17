//
//  BMapViewViewFactory.m
//  flutter_bmap_plugin
//
//  Created by Nick on 2020/4/12.
//

#import "BMapViewViewFactory.h"
#import "FlutterBMapView.h"

@implementation BMapViewViewFactory{
    NSObject<FlutterBinaryMessenger>* _messager;
}
- (instancetype)initWithMessager:(NSObject<FlutterBinaryMessenger>*)messager{
    self = [super init];
    if (self) {
        _messager = messager;
    }
    return self;
}

#pragma mark FlutterPlatformViewFactory delegate

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args{
    FlutterBMapView *flutterBMapView = [[FlutterBMapView alloc]
                                        initWithFrame:frame
                                       viewIdentifier:viewId
                                            arguments:args
                                             messager:_messager];
    return flutterBMapView;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec{
    return [FlutterStandardMessageCodec sharedInstance];
}

@end
