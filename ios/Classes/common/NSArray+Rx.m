//
// Created by Yohom Bao on 2018-11-29.
//

#import "NSArray+Rx.h"


@implementation NSArray (Rx)

- (NSArray *)map:(id (^)(id obj))block {

    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [result addObject:block(obj)];
    }];

    return result;
}

@end