import 'dart:async';

import 'package:flutter/services.dart';

class CoorType {
  const CoorType._(this.name);

  final String name;

  static const gcj02 = const CoorType._("gcJ02");
  static const bd09ll = const CoorType._("bd09ll");
  static const bd09 = const CoorType._("bd09");
  static const wgs84 = const CoorType._("wgs84");
}

class LocationMode {
  const LocationMode._(this.name);

  final String name;

  static const hight_Accuracy = const LocationMode._("Hight_Accuracy");
  static const battery_Saving = const LocationMode._("Battery_Saving");
  static const device_Sensors = const LocationMode._("Device_Sensors");
}

class NotifyLocSensitivity {
  const NotifyLocSensitivity._(this.id);

  final int id;

  static const hight = const NotifyLocSensitivity._(1);
  static const middle = const NotifyLocSensitivity._(2);
  static const low = const NotifyLocSensitivity._(3);
}

class LocationClientOption {
  final CoorType coorType;
  final LocationMode locationMode;
  final bool isNeedAddress;
  final bool openGps;
  final int scanSpan;
  final int timeOut;
  final String prodName;
  final bool isIgnoreCacheException;
  final bool isIgnoreKillProcess;
  final bool enableSimulateGps;
  final bool isNeedLocationDescribe;
  final bool isNeedLocationPoiList;
  final bool isNeedDeviceDirect;
  final bool isNeedAltitude;
  final bool isLocationNotify;
  final bool isOpenAutoNotifyMode;
  final NotifyLocSensitivity autoNotifyLocSensitivity;
  final int autoNotifyMinTimeInterval;
  final int autoNotifyMinDistance;
  final bool isNeedNewVersionRgc;

  const LocationClientOption(
      {this.coorType = CoorType.gcj02,
      this.locationMode = LocationMode.battery_Saving,
      this.isNeedAddress = true,
      this.openGps = true,
      this.scanSpan = 0,
      this.timeOut = 15000,
      this.prodName,
      this.isIgnoreCacheException = true,
      this.isIgnoreKillProcess = true,
      this.enableSimulateGps = false,
      this.isNeedLocationDescribe = false,
      this.isNeedLocationPoiList = false,
      this.isNeedDeviceDirect = false,
      this.isNeedAltitude = false,
      this.isLocationNotify = false,
      this.isOpenAutoNotifyMode = false,
      this.autoNotifyLocSensitivity = NotifyLocSensitivity.low,
      this.autoNotifyMinTimeInterval = 10000,
      this.autoNotifyMinDistance = 0,
      this.isNeedNewVersionRgc = false})
      : assert(scanSpan >= 0),
        assert(prodName != null && prodName.length > 1);

  Map<String, dynamic> asJson() {
    return <String, dynamic>{
      "coorType": coorType.name,
      "locationMode": locationMode.name,
      "isNeedAddress": isNeedAddress,
      "openGps": openGps,
      "scanSpan": scanSpan,
      "timeOut": timeOut,
      "prodName": prodName,
      "isLocationNotify": isLocationNotify,
      "isOpenAutoNotifyMode": isOpenAutoNotifyMode,
      "isIgnoreCacheException": isIgnoreCacheException,
      "isIgnoreKillProcess": isIgnoreKillProcess,
      "enableSimulateGps": enableSimulateGps,
      "isNeedDeviceDirect": isNeedDeviceDirect,
      "isNeedLocationDescribe": isNeedLocationDescribe,
      "isNeedLocationPoiList": isNeedLocationPoiList,
      "isNeedAltitude": isNeedAltitude,
      "autoNotifyLocSensitivity": autoNotifyLocSensitivity.id,
      "autoNotifyMinTimeInterval": autoNotifyMinTimeInterval,
      "autoNotifyMinDistance": autoNotifyMinDistance,
      "isNeedNewVersionRgc": isNeedNewVersionRgc
    };
  }
}

///定位结果常量值.
class LocType {
  static final int typeCacheLocation = 65;
  static final int typeCriteriaException = 62;
  static final int typeGpsLocation = 61;
  static final int typeNetWorkException = 63;
  static final int typeNetWorkLocation = 161;
  static final int typeNone = 0;
  static final int typeOffLineLocation = 66;
  static final int typeOffLineLocationFail = 67;
  static final int typeOffLineLocationNetworkFail = 68;
  static final int typeServerCheckKeyError = 505;
  static final int typeServerDecryptError = 162;
  static final int typeServerError = 167;
}

class Address {
  final String adcode;
  final String countryCode;
  final String country;
  final String province;
  final String cityCode;
  final String city;
  final String district;
  final String streetNumber;
  final String street;
  final String address;

  const Address(
      {this.adcode,
      this.countryCode,
      this.country,
      this.province,
      this.cityCode,
      this.city,
      this.district,
      this.streetNumber,
      this.street,
      this.address});

  static fromJson(Map<dynamic, dynamic> address) {
    return Address(
        adcode: address["adcode"],
        countryCode: address["countryCode"],
        country: address["country"],
        province: address["province"],
        cityCode: address["cityCode"],
        city: address["city"],
        district: address["district"],
        streetNumber: address["streetNumber"],
        street: address["street"],
        address: address["address"]);
  }
}

class BDLocation {
  final String time;
  final String country;
  final String countryCode;
  final String province;
  final double radius;
  final String city;
  final String cityCode;
  final String adCode;
  final String addrStr;
  //final Address address;
  final double altitude;
  final double latitude;
  final double longitude;
  final String coorType;
  //final int delayTime;
  final double direction;
  final String district;
  final String floor;
  //final int gpsAccuracyStatus;
  //final int gpsCheckStatus;
  //final int indoorLocationSource;
  //final int indoorLocationSurpport;
  //final String indoorLocationSurpportBuidlingID;
  //final String indoorLocationSurpportBuidlingName;
  //final int indoorNetworkState;
  final String buildingID;
  final String buildingName;
  //final String indoorSurpportPolygon;
  //final bool isCellChangeFlag;

  ///查看[LocType].
  final int locType;
  //final String locTypeDescription;
  //final bool isInIndoorPark;
  //final bool isIndoorLocMode;
  //final bool isNrlAvailable;
  //final int isParkAvailable;
  //final String locationDescribe;
  final String locationID;
  //final int locationWhere;
  final String networkLocationType;
  //final double nrlLat;
  //final double nrlLon;
  //final String nrlResult;
  //final String roadLocString;
  //final int satelliteNumber;
  final double speed;
  final String street;
  final String streetNumber;
  //final int userIndoorState;
  //final String vdrJsonString;
  //final int describeContents;
  final List<dynamic> poiList;

  const BDLocation(
      {this.time,
      this.country,
      this.countryCode,
      this.province,
      this.radius,
      this.city,
      this.cityCode,
      this.adCode,
      this.addrStr,
      //this.address,
      this.altitude,
      this.latitude,
      this.longitude,
      this.coorType,
      //this.delayTime,
      this.direction,
      this.district,
      this.floor,
      // this.gpsAccuracyStatus,
      // this.gpsCheckStatus,
      // this.indoorLocationSource,
      // this.indoorLocationSurpport,
      // this.indoorLocationSurpportBuidlingID,
      // this.indoorLocationSurpportBuidlingName,
      // this.indoorNetworkState,
      this.buildingID,
      this.buildingName,
      // this.indoorSurpportPolygon,
      // this.isCellChangeFlag,
      this.locType,
      // this.locTypeDescription,
      // this.isInIndoorPark,
      // this.isIndoorLocMode,
      // this.isNrlAvailable,
      // this.isParkAvailable,
      // this.locationDescribe,
      this.locationID,
      // this.locationWhere,
      this.networkLocationType,
      // this.nrlLat,
      // this.nrlLon,
      // this.nrlResult,
      // this.roadLocString,
      // this.satelliteNumber,
      this.speed,
      this.street,
      this.streetNumber,
      // this.userIndoorState,
      // this.vdrJsonString,
      // this.describeContents,
      this.poiList});

  static fromJson(Map<dynamic, dynamic> json) {
    return BDLocation(
        time: json["time"],
        country: json["country"],
        countryCode: json["countryCode"],
        province: json["province"],
        radius: json["radius"],
        city: json["city"],
        cityCode: json["cityCode"],
        adCode: json["adCode"],
        addrStr: json["addrStr"],
        //address: Address.fromJson(json["address"]),
        altitude: json["altitude"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        coorType: json["coorType"],
        //delayTime: json["delayTime"],
        direction: json["direction"],
        district: json["district"],
        floor: json["floor"],
        // gpsAccuracyStatus: json["gpsAccuracyStatus"],
        // gpsCheckStatus: json["gpsCheckStatus"],
        // indoorLocationSource: json["indoorLocationSource"],
        // indoorLocationSurpport: json["indoorLocationSurpport"],
        // indoorLocationSurpportBuidlingID: json["indoorLocationSurpportBuidlingID"],
        // indoorLocationSurpportBuidlingName: json["indoorLocationSurpportBuidlingName"],
        // indoorNetworkState: json["indoorNetworkState"],
        buildingID: json["buildingID"],
        buildingName: json["buildingName"],
        //indoorSurpportPolygon: json["indoorSurpportPolygon"],
        //isCellChangeFlag: json["isCellChangeFlag"],
        locType: json["locType"],
        // locTypeDescription: json["locTypeDescription"],
        // isInIndoorPark: json["isInIndoorPark"],
        // isIndoorLocMode: json["isIndoorLocMode"],
        // isNrlAvailable: json["isNrlAvailable"],
        // isParkAvailable: json["isParkAvailable"],
        // locationDescribe: json["locationDescribe"],
        locationID: json["locationID"],
        //locationWhere: json["locationWhere"],
        networkLocationType: json["networkLocationType"],
        // nrlLat: json["nrlLat"],
        // nrlLon: json["nrlLon"],
        // nrlResult: json["nrlResult"],
        // roadLocString: json["roadLocString"],
        // satelliteNumber: json["satelliteNumber"],
        speed: json["speed"],
        street: json["street"],
        streetNumber: json["streetNumber"],
        // userIndoorState: json["userIndoorState"],
        // vdrJsonString: json["vdrJsonString"],
        // describeContents: json["descriptionContent"],
        poiList: json["poiList"]);
  }
}

class LocEventType {
  static const EVENT_ON_RECEIVE_LOCATION = 0;
}

class BDLocationClient {
  static BDLocationClient _instance;

  static const _methodChannel = const MethodChannel("com.chuangdun.flutter/BMapApi.LocationClient");
  static const _eventChannel = const EventChannel("com.chuangdun.flutter/BMapApi.LocationChanged");

  factory BDLocationClient() => _instance ??= BDLocationClient._();

  void _onEvent(dynamic event) {
    switch (event['event']) {
      case LocEventType.EVENT_ON_RECEIVE_LOCATION:
        var bdLocation = BDLocation.fromJson(event['data']);
        _onReceiveLocation.add(bdLocation);
        break;
      default:
        break;
    }
  }

  BDLocationClient._() {
    _eventChannel.receiveBroadcastStream().listen(_onEvent);
  }

  final _onReceiveLocation = StreamController<BDLocation>.broadcast();

  Stream<BDLocation> get onReceiveLocation => _onReceiveLocation.stream;

  Future<bool> isStart() async {
    return _methodChannel.invokeMethod("isStart");
  }

  Future<void> startLocation(LocationClientOption options) async {
    await _methodChannel.invokeMethod("startLocation", options.asJson());
  }

  Future<void> requestLocation(LocationClientOption options) async {
    await _methodChannel.invokeMethod("requestLocation", options.asJson());
  }

  Future<void> stopLocation() async {
    await _methodChannel.invokeMethod("stopLocation");
  }

  void dispose() {
    _onReceiveLocation.close();
    _instance = null;
  }
}
