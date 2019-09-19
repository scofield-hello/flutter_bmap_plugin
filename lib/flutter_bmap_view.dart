import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BMapType {
  const BMapType._(this.id);

  final int id;
  static const normal = const BMapType._(1);
  static const satellite = const BMapType._(2);
  static const none = const BMapType._(3);
}

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

class LatLng {
  const LatLng(this.latitude, this.longitude);

  final double latitude;
  final double longitude;

  Map<String, double> asJson() {
    return <String, double>{'latitude': latitude, 'longitude': longitude};
  }
}

class BMapStatus {
  const BMapStatus(
      {this.overlook = 0.0,
      this.rotate = 0.0,
      this.target = const LatLng(39.914935, 116.403119),
      this.zoom = 12.0});

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

class MarkerAnimateType {
  const MarkerAnimateType._(this.name);

  final String name;

  static const none = const MarkerAnimateType._("none");
  static const drop = const MarkerAnimateType._("drop");
  static const grow = const MarkerAnimateType._("grow");
  static const jump = const MarkerAnimateType._("jump");
}

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
      this.extraInfo = const <String, dynamic>{},
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
  final Map<String, dynamic> extraInfo;
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
      this.extraInfo = const <String, dynamic>{},
      this.rotate = 0.0,
      this.zIndex = 0});

  final TextOptionsAlign alignX;
  final TextOptionsAlign alignY;
  final int bgColor;
  final Map<String, dynamic> extraInfo;
  final int fontColor;
  final int fontSize;
  final bool visible;
  final String text;
  final double rotate;
  final LatLng position;
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

class FlutterBMapView extends StatefulWidget {
  FlutterBMapView({Key key, this.controller, this.bMapViewOptions = const BMapViewOptions()})
      : super(key: key);

  final FlutterBMapViewController controller;
  final BMapViewOptions bMapViewOptions;

  @override
  _FlutterBMapViewState createState() => _FlutterBMapViewState();
}

class _FlutterBMapViewState extends State<FlutterBMapView> {
  final _viewType = "com.chuangdun.flutter/FlutterBMapView";

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
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class FlutterBMapViewController {
  MethodChannel _channel;

  onCreate(String chanelPrefix, int id) {
    _channel = MethodChannel("${chanelPrefix}_$id");
  }

  Future<void> onMapViewResume() {
    return _channel.invokeMethod("onMapViewResume");
  }

  Future<void> onMapViewPause() {
    return _channel.invokeMethod("onMapViewPause");
  }

  Future<void> onMapViewDestroy() {
    return _channel.invokeMethod("onMapViewDestroy");
  }

  Future<void> addMarkerOverlays(List<MarkerOptions> markers) {
    assert(markers.length > 0);
    List<Map<String, dynamic>> params = [];
    for (var options in markers) {
      params.add(options.asJson());
    }
    return _channel.invokeMethod("addMarkers", params);
  }

  Future<void> addTextOverlays(List<TextOptions> texts) {
    assert(texts.length > 0);
    List<Map<String, dynamic>> params = [];
    for (var options in texts) {
      params.add(options.asJson());
    }
    return _channel.invokeMethod("addTexts", params);
  }
}
