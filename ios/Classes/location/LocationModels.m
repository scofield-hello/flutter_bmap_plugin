//
// Created by Yohom Bao on 2018-12-15.
//

#import "LocationModels.h"
#import "BMKLocationComponent.h"

@implementation BDLocation {

}

- (instancetype)initWithLocation:(BMKLocation *)location withError:(NSError *)error {
    self = [super init];
    if (self) {
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSString *strDate = [dateFormatter stringFromDate:location.location.timestamp];
//        _time = strDate;
//        _country = location.rgcData.country;
//        _countryCode = location.rgcData.countryCode;
//        _province = location.rgcData.province;
//        _radius = 0.0;
//        _city = location.rgcData.city;
//        _cityCode = location.rgcData.cityCode;
//        _adCode = location.rgcData.adCode;
//        Address *adress = [[Address alloc] init];
//        adress.adcode = location.rgcData.adCode;
//        adress.countryCode = location.rgcData.countryCode;
//        adress.country = location.rgcData.country;
//        adress.province = location.rgcData.province;
//        adress.cityCode = location.rgcData.cityCode;
//        adress.city = location.rgcData.city;
//        adress.district = location.rgcData.district;
//        _address.streetNumber = location.rgcData.streetNumber;
//        _address.address = location.rgcData.locationDescribe;
//        _address.street = location.rgcData.street;
//        _locationID = location.locationID;
//        _altitude = location.location.altitude;
//        _floor = location.floorString;
        _locType = 61;
        _latitude = [[NSString stringWithFormat:@"%.6lf", location.location.coordinate.latitude] doubleValue];
        _longitude = [[NSString stringWithFormat:@"%.6lf", location.location.coordinate.longitude] doubleValue];
//        _buildingID = location.buildingID;
//        _buildingName = location.buildingName;
        _addrStr = [NSString stringWithFormat:@"%@%@%@%@%@%@", location.rgcData.country, location.rgcData.province, location.rgcData.city,location.rgcData.district, location.rgcData.street, location.rgcData.streetNumber];
//        _poiList = location.rgcData.poiList;
        
        
    }

    return self;
}

@end


@implementation UnifiedLocationClientOptions {

}
- (void)applyTo:(BMKLocationManager *)locationManager {
//    locationManager.delegate = self;
//    locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
//    locationManager.distanceFilter = kCLDistanceFilterNone;
//                   locationManager.activityType = CLActivityTypeAutomotiveNavigation;
//                   locationManager.pausesLocationUpdatesAutomatically = NO;
//                   locationManager.locationTimeout = 10;
//                   locationManager.reGeocodeTimeout = 10;
    locationManager.distanceFilter = _distanceFilter;
    if (_locationMode == 0) {
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    } else if (_locationMode == 1) {
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    } else if (_locationMode == 2) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    } else {
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    }
    locationManager.pausesLocationUpdatesAutomatically = _pausesLocationUpdatesAutomatically;
    locationManager.allowsBackgroundLocationUpdates = _allowsBackgroundLocationUpdates;
    locationManager.locationTimeout = _locationTimeout;
    locationManager.reGeocodeTimeout = _reGeocodeTimeout;
    locationManager.locatingWithReGeocode = _locatingWithReGeocode;
//    locationManager.reGeocodeLanguage = _geoLanguage;
//    locationManager.detectRiskOfFakeLocation = _detectRiskOfFakeLocation;
}

@end
