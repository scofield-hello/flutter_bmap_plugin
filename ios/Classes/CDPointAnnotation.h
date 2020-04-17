//
//  CDPointAnnotation.h
//  flutter_bmap_plugin
//
//  Created by Nick on 2020/4/17.
//

#import <BaiduMapAPI_Map/BMKPointAnnotation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CDPointAnnotation : BMKPointAnnotation
@property (nonatomic,copy)NSString *icon;
@property (nonatomic,copy)NSString *animateType;
@property (nonatomic,assign)BOOL draggable;
@property (nonatomic,assign)BOOL perspective;
@property (nonatomic,assign)BOOL flat;
@property (nonatomic,assign)BOOL visible;
@property (nonatomic,assign)float alpha;
@property (nonatomic,assign)float rotate;
@property (nonatomic,assign)int zIndex;
@property (nonatomic,copy)NSDictionary *extraInfo;

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString*)title subtitle:(NSString*)subtitle;
@end

NS_ASSUME_NONNULL_END
