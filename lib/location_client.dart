import 'dart:async';

import 'package:flutter/services.dart';

class CoorType {
  const CoorType._(this.name);

  final String name;

  static const GCJ02 = const CoorType._("gcJ02");
  static const BD09ll = const CoorType._("bd09ll");
  static const BD09 = const CoorType._("bd09");
  static const WGS84 = const CoorType._("wgs84");
}

class LocationMode {
  const LocationMode._(this.name);

  final String name;

  static const Hight_Accuracy = const LocationMode._("Hight_Accuracy");
  static const Battery_Saving = const LocationMode._("Battery_Saving");
  static const Device_Sensors = const LocationMode._("Device_Sensors");
}

class NotifyLocSensitivity {
  const NotifyLocSensitivity._(this.id);

  final int id;

  static const LOC_SENSITIVITY_HIGHT = const NotifyLocSensitivity._(1);
  static const LOC_SENSITIVITY_MIDDLE = const NotifyLocSensitivity._(2);
  static const LOC_SENSITIVITY_LOW = const NotifyLocSensitivity._(3);
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
  final bool mIsNeedDeviceDirect;
  final bool isNeedAltitude;
  final bool isLocationNotify;
  final bool isOpenAutoNotifyMode;
  final NotifyLocSensitivity autoNotifyLocSensitivity;
  final int autoNotifyMinTimeInterval;
  final int autoNotifyMinDistance;
  final bool isNeedNewVersionRgc;

  const LocationClientOption(
      {this.coorType = CoorType.GCJ02,
      this.locationMode = LocationMode.Battery_Saving,
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
      this.mIsNeedDeviceDirect = false,
      this.isNeedAltitude = false,
      this.isLocationNotify = false,
      this.isOpenAutoNotifyMode = false,
      this.autoNotifyLocSensitivity = NotifyLocSensitivity.LOC_SENSITIVITY_LOW,
      this.autoNotifyMinTimeInterval = 0,
      this.autoNotifyMinDistance = 0,
      this.isNeedNewVersionRgc = false})
      : assert(scanSpan >= 0),
        assert(prodName != null && prodName.length > 1);

  Map<String, dynamic> toJson() {
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
      "mIsNeedDeviceDirect": mIsNeedDeviceDirect,
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

class BDLocationClient {
  static BDLocationClient _instance;

  final _channel = const MethodChannel("com.chuangdun.flutter/BDLocation");
  final _onReceiveLocation = StreamController<dynamic>.broadcast();

  factory BDLocationClient() => _instance ??= BDLocationClient._();

  BDLocationClient._() {
    _channel.setMethodCallHandler(_handleMessage);
  }

  Stream<dynamic> get onReceiveLocation => _onReceiveLocation.stream;

  Future<Null> _handleMessage(MethodCall call) async {
    switch (call.method) {
      case 'onReceiveLocation':
        _onReceiveLocation.add(call.arguments);
        break;
      default:
        break;
    }
  }

  Future<void> startLocation(LocationClientOption options) async {
    await _channel.invokeMethod("startLocation", options.toJson());
  }

  Future<void> requestLocation() async {
    await _channel.invokeMethod("requestLocation");
  }

  Future<void> stopLocation() async {
    await _channel.invokeMethod("stopLocation");
  }

  void dispose() {
    _onReceiveLocation.close();
  }
}
