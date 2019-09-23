import 'package:flutter/services.dart';
import 'package:flutter_bmap_plugin/flutter_bmap_plugin.dart';

class CoordType {
  const CoordType._(this.name);

  final String name;

  ///百度经纬度坐标.
  static const bd09ll = const CoordType._("BD09LL");

  ///百度墨卡托坐标.
  static const bd09mc = const CoordType._("BD09MC");

  ///google地图、soso地图、aliyun地图、mapabc地图和amap地图所用坐标.
  static const common = const CoordType._("COMMON");

  ///GPS设备采集的原始GPS坐标.
  static const gps = const CoordType._("GPS");
}

class BMapApiUtils {
  static final _channelName = "com.chuangdun.flutter/BMapApi.Utils";
  static final _channel = new MethodChannel(_channelName);

  ///将指定类型坐标转换成百度坐标.
  ///[coordType] 源坐标类型.
  ///[srcCoord] 源坐标点.
  static Future<LatLng> convert(CoordType coordType, LatLng srcCoord) async {
    var latLng = await _channel
        .invokeMethod("convert", {'coordType': coordType.name, 'srcCoord': srcCoord.asJson()});
    return LatLng.fromJson(latLng);
  }

  ///将指定类型坐标列表转换成百度坐标.
  ///[coordType] 源坐标类型.
  ///[srcCoordList] 源坐标点列表.
  static Future<List<LatLng>> convertList(CoordType coordType, List<LatLng> srcCoordList) async {
    var arguments = srcCoordList.map((srcCoord) => srcCoord.asJson()).toList();
    var latLngList = await _channel
        .invokeMethod("convertList", {'coordType': coordType.name, 'srcCoordList': arguments});
    var resultList = <LatLng>[];
    for (var serialized in latLngList) {
      resultList.add(LatLng.fromJson(serialized));
    }
    return resultList;
  }

  ///计算两点之间的距离,单位米.
  ///[from] 起点坐标.
  ///[to] 终点坐标.
  static Future<double> getDistance(LatLng from, LatLng to) async {
    var distance =
        await _channel.invokeMethod("getDistance", {'from': from.asJson(), 'to': to.asJson()});
    return distance;
  }

  ///计算地图上矩形区域的面积，单位平方米.
  ///[northeast] 矩形区域东北角点坐标.
  ///[southwest] 矩形区域西南角点坐标.
  static Future<double> calculateArea(LatLng northeast, LatLng southwest) async {
    var area = await _channel.invokeMethod(
        "calculateArea", {'northeast': northeast.asJson(), 'southwest': southwest.asJson()});
    return area;
  }

  ///返回某点距线上最近的点.
  ///[points] 折线折点.
  ///[point] 待判断点.
  static Future<LatLng> getNearestPointFromLine(List<LatLng> points, LatLng point) async {
    var pointsList = points.map((srcCoord) => srcCoord.asJson()).toList();
    var latLng = await _channel
        .invokeMethod("getNearestPointFromLine", {'points': pointsList, 'point': point.asJson()});
    return LatLng.fromJson(latLng);
  }

  ///返回一个点是否在一个多边形区域内.
  ///[points] 多边形坐标点列表.
  ///[point] 待判断点.
  static Future<bool> isPolygonContainsPoint(List<LatLng> points, LatLng point) async {
    var pointsList = points.map((srcCoord) => srcCoord.asJson()).toList();
    var contains = await _channel
        .invokeMethod("isPolygonContainsPoint", {'points': pointsList, 'point': point.asJson()});
    return contains;
  }

  ///判断圆形是否包含传入的经纬度点.
  ///[center] 构成圆的中心点.
  ///[radius] 圆的半径.
  ///[point] 待判断点.
  static Future<bool> isCircleContainsPoint(LatLng center, int radius, LatLng point) async {
    var contains = await _channel.invokeMethod("isCircleContainsPoint",
        {'center': center.asJson(), 'radius': radius, 'point': point.asJson()});
    return contains;
  }
}
