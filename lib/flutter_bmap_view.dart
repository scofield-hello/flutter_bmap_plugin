import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const LatLng POSITION_BEI_JING = LatLng(latitude: 39.914935, longitude: 116.403119);

///地图类型.
class BMapType {
  const BMapType._(this.id);

  final int id;
  static const normal = const BMapType._(1);
  static const satellite = const BMapType._(2);
  static const none = const BMapType._(3);
}

///百度地图Logo显示位置.
class LogoPosition {
  const LogoPosition._(this.name);

  final String name;
  static const logoPostionleftBottom = const LogoPosition._("logoPostionleftBottom");
  static const logoPostionleftTop = const LogoPosition._("logoPostionleftTop");
  static const logoPostionCenterBottom = const LogoPosition._("logoPostionCenterBottom");
  static const logoPostionCenterTop = const LogoPosition._("logoPostionCenterTop");
  static const logoPostionRightBottom = const LogoPosition._("logoPostionRightBottom");
  static const logoPostionRightTop = const LogoPosition._("logoPostionRightTop");
}

///经纬度信息.
class LatLng {
  const LatLng({this.latitude, this.longitude});

  ///纬度.
  final double latitude;

  ///经度.
  final double longitude;

  static fromJson(Map<dynamic, dynamic> json) {
    return LatLng(latitude: json['latitude'], longitude: json['longitude']);
  }

  Map<String, double> asJson() {
    return <String, double>{'latitude': latitude, 'longitude': longitude};
  }
}

class BMapStatus {
  const BMapStatus(
      {this.overlook = 0.0, this.target = POSITION_BEI_JING, this.rotate = 0.0, this.zoom = 12.0});

  final double overlook;
  final double rotate;
  final LatLng target;
  final double zoom;

  Map<String, dynamic> asJson() {
    return <String, dynamic>{
      'overlook': overlook,
      'rotate': rotate,
      'target': target.asJson(),
      'zoom': zoom
    };
  }
}

class BMapViewOptions {
  const BMapViewOptions(
      {this.compassEnabled = true,
      this.logoPosition = LogoPosition.logoPostionleftBottom,
      this.mapStatus = const BMapStatus(),
      this.mapType = BMapType.normal,
      this.overlookingGesturesEnabled = true,
      this.rotateGesturesEnabled = true,
      this.scaleControlEnabled = true,
      this.scrollGesturesEnabled = true,
      this.zoomControlsEnabled = true,
      this.zoomGesturesEnabled = true});

  final bool compassEnabled;
  final LogoPosition logoPosition;
  final BMapStatus mapStatus;
  final BMapType mapType;
  final bool overlookingGesturesEnabled;
  final bool rotateGesturesEnabled;
  final bool scaleControlEnabled;
  final bool scrollGesturesEnabled;
  final bool zoomControlsEnabled;
  final bool zoomGesturesEnabled;

  Map<String, dynamic> asJson() {
    return <String, dynamic>{
      'compassEnabled': compassEnabled,
      'logoPosition': logoPosition.name,
      'mapStatus': mapStatus.asJson(),
      'mapType': mapType.id,
      'overlookingGesturesEnabled': overlookingGesturesEnabled,
      'rotateGesturesEnabled': rotateGesturesEnabled,
      'scaleControlEnabled': scaleControlEnabled,
      'scrollGesturesEnabled': scrollGesturesEnabled,
      'zoomControlsEnabled': zoomControlsEnabled,
      'zoomGesturesEnabled': zoomGesturesEnabled
    };
  }
}

///信息窗对象.
class InfoWindow {
  InfoWindow(
      {this.position,
      this.info,
      this.tag,
      this.yOffset = -70,
      this.textColor = 0xFF000000,
      this.textSize = 14.0});

  final LatLng position;
  final String info;
  final String tag;
  final int yOffset;
  final int textColor;
  final double textSize;

  Map<String, dynamic> asJson() {
    return <String, dynamic>{
      'position': position.asJson(),
      'info': info,
      'tag': tag,
      'yOffset': yOffset,
      'textColor': textColor.toString(),
      'textSize': textSize
    };
  }
}

///标注点动画类型.
class MarkerAnimateType {
  const MarkerAnimateType._(this.name);

  final String name;

  static const none = const MarkerAnimateType._("none");
  static const drop = const MarkerAnimateType._("drop");
  static const grow = const MarkerAnimateType._("grow");
  static const jump = const MarkerAnimateType._("jump");
}

///标注点对象.
class MarkerOptions {
  const MarkerOptions(
      {this.position,
      this.title,
      this.icon,
      this.visible = true,
      this.animateType = MarkerAnimateType.none,
      this.alpha = 1.0,
      this.perspective = true,
      this.draggable = false,
      this.flat = false,
      this.rotate = 0.0,
      this.extraInfo = const <dynamic, dynamic>{},
      this.zIndex = 0});

  final String icon;
  final MarkerAnimateType animateType;
  final double alpha;
  final LatLng position;
  final bool perspective;
  final bool draggable;
  final bool flat;
  final double rotate;
  final String title;
  final bool visible;
  final Map<dynamic, dynamic> extraInfo;

  ///需要监听Marker点击事件时，需要设置一个比其他图层的zIndex大的值,
  ///否则可能被其他图层覆盖导致无法触发回调函数.
  final int zIndex;

  Map<String, dynamic> asJson() {
    return <String, dynamic>{
      'icon': icon,
      'animateType': animateType.name,
      'alpha': alpha,
      'position': position.asJson(),
      'perspective': perspective,
      'draggable': draggable,
      'flat': flat,
      'rotate': rotate,
      'title': title,
      'visible': visible,
      'extraInfo': extraInfo,
      'zIndex': zIndex
    };
  }
}

///文本对齐方向.
class TextOptionsAlign {
  const TextOptionsAlign._(this.id);

  final int id;

  static const alignBottom = const TextOptionsAlign._(16);
  static const alignCenterHorizontal = const TextOptionsAlign._(4);
  static const alignCenterVertical = const TextOptionsAlign._(32);
  static const alignLeft = const TextOptionsAlign._(1);
  static const alignRight = const TextOptionsAlign._(2);
  static const alignTop = const TextOptionsAlign._(8);
}

///文本信息对象.
class TextOptions {
  const TextOptions(
      {this.position,
      this.text,
      this.alignX = TextOptionsAlign.alignCenterHorizontal,
      this.alignY = TextOptionsAlign.alignTop,
      this.bgColor = 0x00000000,
      this.visible = true,
      this.fontColor = 0xFFFF00FF,
      this.fontSize = 24,
      this.extraInfo = const <dynamic, dynamic>{},
      this.rotate = 0.0,
      this.zIndex = 0});

  final LatLng position;
  final String text;
  final TextOptionsAlign alignX;
  final TextOptionsAlign alignY;
  final int bgColor;
  final bool visible;
  final int fontColor;
  final int fontSize;
  final Map<dynamic, dynamic> extraInfo;
  final double rotate;
  final int zIndex;

  Map<String, dynamic> asJson() {
    return <String, dynamic>{
      'alignX': alignX.id,
      'alignY': alignY.id,
      'position': position.asJson(),
      'text': text,
      'visible': visible,
      'bgColor': bgColor.toString(),
      'fontColor': fontColor.toString(),
      'fontSize': fontSize,
      'rotate': rotate,
      'extraInfo': extraInfo,
      'zIndex': zIndex
    };
  }
}

///自定义折线PolylineOptions.
class TexturePolylineOptions {
  TexturePolylineOptions(this.points, this.customTextureList, this.textureIndex,
      {this.width = 10, this.dottedLine = true, this.extraInfo = const <dynamic, dynamic>{}})
      : assert(points.length > 1),
        assert(customTextureList.isNotEmpty),
        assert(textureIndex.length == points.length - 1);

  ///绘制折线的经纬度列表.
  final List<LatLng> points;

  ///折线宽度.
  final int width;

  ///是否虚线.
  final bool dottedLine;

  ///自定义折线资源名列表.
  final List<String> customTextureList;

  ///折线绘制资源索引.
  final List<int> textureIndex;

  ///额外信息.
  final Map<dynamic, dynamic> extraInfo;

  Map<String, dynamic> asJson() {
    List<Map<String, double>> latLngList = [];
    for (var latLng in points) {
      latLngList.add(latLng.asJson());
    }
    return <String, dynamic>{
      'points': latLngList,
      'customTextureList': customTextureList,
      'textureIndex': textureIndex,
      'width': width,
      'dottedLine': dottedLine,
      'extraInfo': extraInfo
    };
  }
}

///MapPoi信息.
class MapPoi {
  MapPoi({this.uid, this.name, this.position});

  final String uid;
  final String name;
  final LatLng position;

  static fromJson(Map<dynamic, dynamic> json) {
    return MapPoi(
        uid: json['uid'], name: json['name'], position: LatLng.fromJson(json['position']));
  }

  Map<String, dynamic> asJson() {
    return <String, dynamic>{'uid': uid, 'name': name, 'position': position.asJson()};
  }
}

///标注点被点击时返回的标注信息.
class Marker {
  Marker({this.title, this.position, this.extraInfo});

  final String title;
  final LatLng position;
  final Map<dynamic, dynamic> extraInfo;

  static fromJson(Map<dynamic, dynamic> json) {
    return Marker(
        title: json['title'],
        extraInfo: json['extraInfo'],
        position: LatLng.fromJson(json['position']));
  }

  Map<String, dynamic> asJson() {
    return <String, dynamic>{'title': title, 'extraInfo': extraInfo, 'position': position.asJson()};
  }
}

///百度地图组件.
/**
    class FlutterBMapView extends StatefulWidget {
    FlutterBMapView({Key key,
    this.controller,
    this.onBMapViewCreated,
    this.bMapViewOptions = const BMapViewOptions()})
    : super(key: key);

    final FlutterBMapViewController controller;
    final BMapViewOptions bMapViewOptions;
    final VoidCallback onBMapViewCreated;

    @override
    _FlutterBMapViewState createState() => _FlutterBMapViewState();
    }

    class _FlutterBMapViewState extends State<FlutterBMapView>{
    final _viewType = "com.chuangdun.flutter/FlutterBMapView";

    @override
    void initState() {
    super.initState();
    }

    @override
    Widget build(BuildContext context) {
    return AndroidView(
    viewType: _viewType,
    creationParams: widget.bMapViewOptions.asJson(),
    creationParamsCodec: const StandardMessageCodec(),
    onPlatformViewCreated: _onPlatformViewCreated);
    }

    void _onPlatformViewCreated(int id) {
    if (widget.controller != null) {
    widget.controller.onCreate(_viewType, id);
    }
    if(widget.onBMapViewCreated != null){
    widget.onBMapViewCreated();
    }
    }

    @override
    void dispose() {
    super.dispose();
    }
    }
 */

class FlutterBMapView extends StatelessWidget {
  const FlutterBMapView({Key key,
    this.controller,
    this.onBMapViewCreated,
    this.bMapViewOptions = const BMapViewOptions()})
      : super(key: key);

  final FlutterBMapViewController controller;
  final BMapViewOptions bMapViewOptions;
  final VoidCallback onBMapViewCreated;

  final _viewType = "com.chuangdun.flutter/FlutterBMapView";

  @override
  Widget build(BuildContext context) {
    return AndroidView(
        viewType: _viewType,
        creationParams: bMapViewOptions.asJson(),
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated);
  }

  void _onPlatformViewCreated(int id) {
    if (controller != null) {
      controller.onCreate(_viewType, id);
    }
    if (onBMapViewCreated != null) {
      onBMapViewCreated();
    }
  }
}

class FlutterBMapViewController {
  MethodChannel _channel;

  ///地图点击事件.
  final _onMapClick = StreamController<LatLng>.broadcast();

  Stream<LatLng> get onMapClick => _onMapClick.stream;

  ///地图长点击事件.
  final _onMapLongClick = StreamController<LatLng>.broadcast();

  Stream<LatLng> get onMapLongClick => _onMapLongClick.stream;

  ///地图双击事件.
  final _onMapDoubleClick = StreamController<LatLng>.broadcast();

  Stream<LatLng> get onMapDoubleClick => _onMapDoubleClick.stream;

  ///地图MapPoi点击事件.
  final _onMapPoiClick = StreamController<MapPoi>.broadcast();

  Stream<MapPoi> get onMapPoiClick => _onMapPoiClick.stream;

  ///地图标注点点击事件.
  final _onMarkerClick = StreamController<Marker>.broadcast();

  Stream<Marker> get onMarkerClick => _onMarkerClick.stream;

  Future<Null> _handleMessage(MethodCall call) async {
    switch (call.method) {
      case 'onMapClick':
        var latLng = LatLng.fromJson(call.arguments);
        _onMapClick.add(latLng);
        break;
      case 'onMapPoiClick':
        var mapPoi = MapPoi.fromJson(call.arguments);
        _onMapPoiClick.add(mapPoi);
        break;
      case 'onMarkerClick':
        var marker = Marker.fromJson(call.arguments);
        _onMarkerClick.add(marker);
        break;
      case 'onMapLongClick':
        var latLng = LatLng.fromJson(call.arguments);
        _onMapLongClick.add(latLng);
        break;
      case 'onMapDoubleClick':
        var latLng = LatLng.fromJson(call.arguments);
        _onMapDoubleClick.add(latLng);
        break;
      default:
        break;
    }
  }

  onCreate(String chanelPrefix, int id) {
    _channel = MethodChannel("${chanelPrefix}_$id");
    _channel.setMethodCallHandler(_handleMessage);
  }

  Future<void> setMapViewResume() {
    return _channel.invokeMethod("onMapViewResume");
  }

  Future<void> setMapViewPause() {
    return _channel.invokeMethod("onMapViewPause");
  }

  Future<void> setMapViewDestroy() {
    return _channel.invokeMethod("onMapViewDestroy");
  }

  ///绘制标注点.
  ///[markers] 标注点列表.
  Future<void> addMarkerOverlays(List<MarkerOptions> markers) {
    assert(markers.length > 0);
    List<Map<String, dynamic>> params = [];
    for (var options in markers) {
      params.add(options.asJson());
    }
    return _channel.invokeMethod("addMarkers", params);
  }

  ///绘制文本信息.
  ///[texts] 文本信息列表.
  Future<void> addTextOverlays(List<TextOptions> texts) {
    assert(texts.length > 0);
    List<Map<String, dynamic>> params = [];
    for (var options in texts) {
      params.add(options.asJson());
    }
    return _channel.invokeMethod("addTexts", params);
  }

  ///绘制自定义折线.
  ///[texturePolyline] 折线信息.
  Future<void> addTexturePolyline(TexturePolylineOptions texturePolyline) {
    return _channel.invokeMethod("addTexturePolyline", texturePolyline.asJson());
  }

  ///隐藏InfoWindow.
  Future<void> hideInfoWindow() {
    return _channel.invokeMethod("hideInfoWindow");
  }

  ///显示InfoWindow.
  ///[infoWindow] 信息窗对象.
  Future<void> showInfoWindow(InfoWindow infoWindow) {
    return _channel.invokeMethod("showInfoWindow", infoWindow.asJson());
  }

  ///移动地图中心至指定经纬度.
  ///[latLng] 经纬度对象.
  ///[zoom] 地图缩放级别.
  Future<void> animateMapStatusUpdateNewLatLng(LatLng latLng, {double zoom}) {
    return _channel
        .invokeMethod("animateMapStatusNewLatLng", {'center': latLng.asJson(), 'zoom': zoom});
  }

  ///移动地图中心至指定经纬度范围.
  ///[bounds] 经纬度范围.
  Future<void> animateMapStatusUpdateNewBounds(List<LatLng> bounds) {
    List<Map<String, dynamic>> latLngList = [];
    for (var options in bounds) {
      latLngList.add(options.asJson());
    }
    return _channel.invokeMethod("animateMapStatusNewBounds", {'bounds': latLngList});
  }

  ///清除地图图层.
  Future<void> clearMap() {
    return _channel.invokeMethod("clearMap");
  }

  void dispose() {
    _onMapClick.close();
    _onMapLongClick.close();
    _onMapDoubleClick.close();
    _onMapPoiClick.close();
    _onMarkerClick.close();
  }
}
