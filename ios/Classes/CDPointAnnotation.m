//
//  CDPointAnnotation.m
//  flutter_bmap_plugin
//
//  Created by Nick on 2020/4/17.
//

#import "CDPointAnnotation.h"

@implementation CDPointAnnotation

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle{
    self = [super init];
    if (self) {
        self.coordinate = coordinate;
        self.title = title;
        self.subtitle = subtitle;
    }
    return self;
}
@end
