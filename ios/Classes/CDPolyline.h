//
//  CDPolyline.h
//  flutter_bmap_plugin
//
//  Created by Nick on 2020/4/17.
//

#import <BaiduMapAPI_Map/BMKPolyline.h>

NS_ASSUME_NONNULL_BEGIN

@interface CDPolyline : BMKPolyline
@property (nonatomic, copy)NSArray<NSString*> *customTextureList;
@property (nonatomic, copy)NSDictionary *extraInfo;
@property (nonatomic, assign)BOOL dottedLine;
@property (nonatomic, assign)float width;
@end

NS_ASSUME_NONNULL_END
