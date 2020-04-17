//
//  BMapViewViewFactory.h
//  flutter_bmap_plugin
//
//  Created by Nick on 2020/4/12.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
NS_ASSUME_NONNULL_BEGIN

@interface BMapViewViewFactory : NSObject<FlutterPlatformViewFactory>

- (instancetype)initWithMessager:(NSObject<FlutterBinaryMessenger> *)messager;

@end

NS_ASSUME_NONNULL_END
