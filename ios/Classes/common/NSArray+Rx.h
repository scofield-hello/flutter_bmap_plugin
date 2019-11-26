//
// Created by Yohom Bao on 2018-11-29.
//

#import <Foundation/Foundation.h>

@interface NSArray (Rx)

- (NSArray *)map:(id (^)(id obj))block;

@end