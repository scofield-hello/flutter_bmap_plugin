import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bmap_plugin/flutter_bmap_plugin.dart';
import 'dart:io';
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  FlutterBMapViewController _controller;
  BDLocationClient _locationClient;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);    
    _controller = FlutterBMapViewController();
    _locationClient = BDLocationClient();
    _locationClient.onReceiveLocation.listen((location) {
      _controller.animateMapStatusNewLatLng(
          LatLng(latitude: location.latitude, longitude: location.longitude));
    });
    _controller.onMarkerClick.listen((Marker marker) async {
      var extraInfo = marker.extraInfo;
      var name = extraInfo['name'];
      var address = extraInfo['address'];
      print(marker.asJson());
      //var infoWindow = InfoWindow(position: marker.position, info: "$name\n$address");
      //_controller.showInfoWindow(infoWindow);
      _controller.animateMapStatusNewLatLng(marker.position);
    });
    _controller.onMapClick.listen((LatLng latLng) async {
      //_controller.hideInfoWindow();
      print(latLng.asJson());
    });
    _controller.onMapLongClick.listen((LatLng latLng) async {
      print(latLng.asJson());
    });
    _controller.onMapDoubleClick.listen((LatLng latLng) async {
      print(latLng.asJson());
    });
    _controller.onMapPoiClick.listen((MapPoi poi) async {
      print(poi.asJson());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('FlutterBMapView'),
      ),
      body: Column(
          children: <Widget>[
            Container(
              height: 300,
              child:
                  FlutterBMapView(controller: _controller, onBMapViewCreated: _onBMapViewCreated),
            ),
            Row(children: <Widget>[
              FlatButton(onPressed: _addMarkers, child: Text("添加标注点")),
              FlatButton(onPressed: _addTextOptionsList, child: Text("添加文本信息")),
            ]),
            Row(children: <Widget>[
              FlatButton(onPressed: _addPolylineOptions, child: Text("画折线")),
              FlatButton(onPressed: () => _controller.clearMap(), child: Text("清除图层")),
            ]),
            Row(children: <Widget>[
              FlatButton(onPressed: _startLocation, child: Text("开始定位")),
              FlatButton(onPressed: _requestLocation, child: Text("单次定位")),
              FlatButton(onPressed: _stopLocation, child: Text("停止定位")),
            ]),
            Row(children: <Widget>[
              FlatButton(onPressed: _convert, child: Text("转换坐标")),
              FlatButton(onPressed: _convertList, child: Text("转换坐标列表")),
            ]),
            Row(children: <Widget>[
              FlatButton(onPressed: _getDistance, child: Text("计算距离")),
              FlatButton(onPressed: _calculateArea, child: Text("计算面积")),
            ]),
            FlatButton(onPressed: _getNearestPointFromLine, child: Text("返回某点距线上最近的点")),
            FlatButton(onPressed: _isCircleContainsPoint, child: Text("判断圆形是否包含传入的经纬度点")),
            FlatButton(onPressed: _isPolygonContainsPoint, child: Text("返回一个点是否在一个多边形区域内")),
          ],
        ),
    ));
  }

  void _onBMapViewCreated() {
    
    //_controller.setMapViewResume();
  }

  void _startLocation() async {
    try {
      var options =
          LocationClientOption(coorType: CoorType.bd09ll, prodName: "Flutter Plugin Test");
      await _locationClient.startLocation(options);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void _requestLocation() async {
    try {
      
      var options =
          LocationClientOption(coorType: CoorType.bd09ll, prodName: "Flutter Plugin Test");
      await _locationClient.requestLocation(options);    
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void _stopLocation() async {
    try {
      if (await _locationClient.isStart()) {
        await _locationClient.stopLocation();
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void _convert() async {
    try {
      var latLng = await BMapApiUtils.convert(CoordType.gps, _latLngList()[0]);
      print(latLng.asJson());
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void _convertList() async {
    try {
      var latLngList = await BMapApiUtils.convertList(CoordType.gps, _latLngList());
      print(latLngList);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void _getDistance() async {
    try {
      var latLngList = _latLngList();
      var distance = await BMapApiUtils.getDistance(latLngList[0], latLngList[1]);
      print(distance);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void _calculateArea() async {
    try {
      var latLngList = _latLngList();
      var area = await BMapApiUtils.calculateArea(latLngList[0], latLngList[1]);
      print(area);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void _getNearestPointFromLine() async {
    try {
      var latLngList = _latLngList();
      var point = await BMapApiUtils.getNearestPointFromLine(
          latLngList, LatLng(latitude: 30.286253, longitude: 120.156733));
      print(point.asJson());
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void _isCircleContainsPoint() async {
    try {
      var latLngList = _latLngList();
      var contains = await BMapApiUtils.isCircleContainsPoint(latLngList[0], 1000, latLngList[1]);
      print(contains);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void _isPolygonContainsPoint() async {
    try {
      var latLngList = _latLngList();
      var contains = await BMapApiUtils.isPolygonContainsPoint(
          latLngList, LatLng(latitude: 30.286253, longitude: 120.156733));
      print(contains);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void _addMarkers() {
    
    var latLngList = _latLngList();
    List<MarkerOptions> markers = [];
    for (var index = 0; index < latLngList.length; index++) {
      var option = MarkerOptions(
          zIndex: 100,
          position: latLngList[index],
          title: "P$index",
          subtitle: "马塍路文三路口东部软件园创新大厦A-302",
          icon: Platform.isAndroid? "assets/marker.png":"marker.png",
          extraInfo: {'name': "P$index", 'address': "马塍路文三路口东部软件园创新大厦A-302"});
      markers.add(option);
    }
    markers.first.icon = Platform.isAndroid ? "assets/Icon_start.png":"Icon_start.png";
    markers.last.icon = Platform.isAndroid ? "assets/Icon_end.png": "Icon_end.png";
    _controller.addMarkerOverlays(markers);
  }

  void _addTextOptionsList() {
    var latLngList = _latLngList();
    List<TextOptions> texts = [];
    for (var index = 0; index < latLngList.length; index++) {
      var option = TextOptions(position: latLngList[index], text: "P$index", fontSize: 40);
      texts.add(option);
    }
    _controller.addTextOverlays(texts);
  }

  void _addPolylineOptions() {
    var latLngList = _latLngList();
    var customTextureList = [
      Platform.isAndroid ? "assets/Icon_road_blue_arrow.png" : "Icon_road_blue_arrow.png",
      Platform.isAndroid ? "assets/Icon_road_green_arrow.png" : "Icon_road_green_arrow.png",
      Platform.isAndroid ? "assets/Icon_road_red_arrow.png" : "Icon_road_red_arrow.png",
      Platform.isAndroid ? "assets/Icon_road_yellow_arrow.png" : "Icon_road_yellow_arrow.png"
    ];
    var intRandom = Random();
    var textureIndex = <int>[];
    for (var index = 0; index < latLngList.length - 1; index++) {
      textureIndex.add(intRandom.nextInt(customTextureList.length));
    }
    var extraInfo = const <String, dynamic>{'name': "Polyline", 'anything': "..."};
    var texturePolyline =
        TexturePolylineOptions(latLngList, customTextureList, textureIndex, extraInfo: extraInfo);
    _controller.addTexturePolyline(texturePolyline);
  }

  List<LatLng> _latLngList() {
    return const [
      LatLng(latitude: 30.284949, longitude: 120.151828),
      LatLng(latitude: 30.285059, longitude: 120.152659),
      LatLng(latitude: 30.285053, longitude: 120.153653),
      LatLng(latitude: 30.285153, longitude: 120.154753),
      LatLng(latitude: 30.285253, longitude: 120.155733),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _locationClient.dispose();
    _stopLocation();
    _locationClient.dispose();
    _controller.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("didChangeAppLifecycleState:resume");
        _controller.setMapViewResume();
        break;
      case AppLifecycleState.inactive:
        //print("didChangeAppLifecycleState:inactive");
        break;
      case AppLifecycleState.paused:
        print("didChangeAppLifecycleState:pause");
        _controller.setMapViewPause();
        break;
      default:
        break;
    }
  }
}
