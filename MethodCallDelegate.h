//
//  MethodCallDelegate.h
//  flutter_bmap_plugin
//
//  Created by Nick on 2020/4/1.
//
#import <Flutter/Flutter.h>

@protocol MethodCallDelegate <NSObject>

@required
- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result;

@end
