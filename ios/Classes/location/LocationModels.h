//
// Created by Yohom Bao on 2018-12-15.
//

#import <Foundation/Foundation.h>
#import "BMKLocationComponent.h"


@class Address;
//@class BM
@interface BDLocation : NSObject
- (instancetype)initWithLocation:(BMKLocation *)location withError:(NSError *)error;
//@property(nonatomic) NSString *time;
//@property(nonatomic) NSString *country;
//@property(nonatomic) NSString *countryCode;
//@property(nonatomic) NSString *province;
//@property(nonatomic) double radius;
//@property(nonatomic) NSString *city;
//@property(nonatomic) NSString *cityCode;
//@property(nonatomic) NSString *adCode;
@property(nonatomic) NSString *addrStr;
//@property(nonatomic) Address *address;
//@property(nonatomic) double altitude;
@property(nonatomic) double latitude;
@property(nonatomic) double longitude;
//@property(nonatomic) double direction;
//@property(nonatomic) NSString *district;
//@property(nonatomic) int delayTime;
//@property(nonatomic) NSString *floor;
//@property(nonatomic) int gpsAccuracyStatus;
//@property(nonatomic) int gpsCheckStatus;
//@property(nonatomic) int indoorLocationSource;
//@property(nonatomic) int indoorLocationSurpport;
//@property(nonatomic) NSString *indoorLocationSurpportBuidlingID;
//@property(nonatomic) NSString *indoorLocationSurpportBuidlingName;
//@property(nonatomic) int indoorNetworkState;
//@property(nonatomic) NSString *buildingID;
//@property(nonatomic) NSString *buildingName;
//@property(nonatomic) NSString *indoorSurpportPolygon;
//@property(nonatomic) BOOL isCellChangeFlag;

@property(nonatomic) int locType;
//@property(nonatomic) NSString *locTypeDescription;
//@property(nonatomic) BOOL isInIndoorPark;
//@property(nonatomic) BOOL isIndoorLocMode;
//@property(nonatomic) BOOL isNrlAvailable;
//@property(nonatomic) int isParkAvailable;
//@property(nonatomic) NSString *locationDescribe;
//@property(nonatomic) NSString *locationID;
//@property(nonatomic) int locationWhere;
//@property(nonatomic) NSString *networkLocationType;
//@property(nonatomic) double nrlLat;
//@property(nonatomic) double nrlLon;
//@property(nonatomic) NSString *nrlResult;
//@property(nonatomic) NSString *roadLocString;
//@property(nonatomic) int satelliteNumber;
//@property(nonatomic) double speed;
//@property(nonatomic) NSString *street;
//@property(nonatomic) NSString *streetNumber;
//@property(nonatomic) int userIndoorState;
//@property(nonatomic) NSString *vdrJsonString;
//@property(nonatomic) int describeContents;
//@property(nonatomic) NSArray *poiList;

@end

@interface Address : NSObject

@property(nonatomic) NSString *adcode;
@property(nonatomic) NSString *countryCode;
@property(nonatomic) NSString *country;
@property(nonatomic) NSString *province;
@property(nonatomic) NSString *cityCode;
@property(nonatomic) NSString *city;
@property(nonatomic) NSString *district;
@property(nonatomic) NSString *streetNumber;
@property(nonatomic) NSString *street;
@property(nonatomic) NSString *address;

@end
@class BMKLocationManager;

@interface UnifiedLocationClientOptions : NSObject
/// 是否单次单次定位
/// 默认值：false
@property(nonatomic) bool isOnceLocation;

/// 定位模式 默认值：Hight_Accuracy 高精度模式
@property(nonatomic) NSInteger locationMode;

/// 逆地理信息的语言,目前之中中文和英文
//@property(nonatomic) AMapLocationReGeocodeLanguage geoLanguage;

///设定定位的最小更新距离。单位米，默认为 kCLDistanceFilterNone，表示只要检测到设备位置发生变化就会更新位置信息。
@property(nonatomic, assign) CLLocationDistance distanceFilter;

///指定定位是否会被系统自动暂停。默认为NO。
@property(nonatomic, assign) BOOL pausesLocationUpdatesAutomatically;

///是否允许后台定位。默认为NO。只在iOS 9.0及之后起作用。设置为YES的时候必须保证 Background Modes 中的 Location updates 处于选中状态，否则会抛出异常。由于iOS系统限制，需要在定位未开始之前或定位停止之后，修改该属性的值才会有效果。
@property(nonatomic, assign) BOOL allowsBackgroundLocationUpdates;

///指定单次定位超时时间,默认为10s。最小值是2s。注意单次定位请求前设置。注意: 单次定位超时时间从确定了定位权限(非kCLAuthorizationStatusNotDetermined状态)后开始计算。
@property(nonatomic, assign) NSInteger locationTimeout;

///指定单次定位逆地理超时时间,默认为5s。最小值是2s。注意单次定位请求前设置。
@property(nonatomic, assign) NSInteger reGeocodeTimeout;

///连续定位是否返回逆地理信息，默认NO。
@property(nonatomic, assign) BOOL locatingWithReGeocode;

///获取被监控的region集合。
@property(nonatomic, readonly, copy) NSSet *monitoredRegions;

///检测是否存在虚拟定位风险，默认为NO，不检测。 \n注意:设置为YES时，单次定位通过 AMapLocatingCompletionBlock 的error给出虚拟定位风险提示；连续定位通过 amapLocationManager:didFailWithError: 方法的error给出虚拟定位风险提示。error格式为 error.domain==AMapLocationErrorDomain; error.code==AMapLocationErrorRiskOfFakeLocation; \n附带的error的详细信息参考 error.localizedDescription 中的描述以及 error.userInfo 中的信息(error.userInfo.AMapLocationRiskyLocateResult 表示有虚拟风险的定位结果; error.userInfo.AMapLocationAccessoryInfo 表示外接辅助设备信息)。
@property(nonatomic, assign) BOOL detectRiskOfFakeLocation;

-(void) applyTo:(BMKLocationManager*) locationManager;

@end
