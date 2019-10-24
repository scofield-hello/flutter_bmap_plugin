//
//  FlutterBMapPlugin.h
//  flutter_bmap_plugin
//
//  Created by iMac on 2019/10/22.
//
#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
NS_ASSUME_NONNULL_BEGIN

@interface FlutterBMapPlugin : NSObject<FlutterPlugin>
+ (NSObject <FlutterPluginRegistrar> *)registrar;
+ (FlutterMethodChannel *)methodChannel;
+ (FlutterEventChannel *)locEventChannel;
+ (FlutterEventSink)eventSink;
+ (id)arguments;
@end

NS_ASSUME_NONNULL_END
