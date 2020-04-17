//
//  LocationMethodCallHandler.h
//  flutter_bmap_plugin
//
//  Created by Nick on 2020/4/1.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "MethodCallDelegate.h"
NS_ASSUME_NONNULL_BEGIN
extern NSDateFormatter * const dateFormatter;
@interface LocationMethodHandler:NSObject <MethodCallDelegate, FlutterStreamHandler>
@end

NS_ASSUME_NONNULL_END
