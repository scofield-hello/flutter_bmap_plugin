//
//  MethodCallDelegate.h
//  Pods
//
//  Created by Nick on 2020/4/17.
//
#import <Flutter/Flutter.h>
#import <Foundation/Foundation.h>

@protocol MethodCallDelegate <NSObject>

@required
- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result;

@end

