//
// Created by Yohom Bao on 2018-12-10.
//

#import "NSString+Color.h"


@implementation NSString (Color)

- (UIColor *)hexStringToColor {
    NSString *cString = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }

    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;

    //A, R,G, B
    NSString *aString = [cString substringWithRange:range];

    range.location = 2;
    NSString *rString = [cString substringWithRange:range];

    range.location = 4;
    NSString *gString = [cString substringWithRange:range];

    range.location = 6;
    NSString *bString = [cString substringWithRange:range];

    // Scan values
    unsigned int a, r, g, b;
    [[NSScanner scannerWithString:aString] scanHexInt:&a];
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:((float) a / 255.0f)];
}

@end