import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bmap_plugin/flutter_bmap_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterBMapViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FlutterBMapViewController();
    _controller.onMarkerClick.listen((Marker marker) async {
      var extraInfo = marker.extraInfo;
      var name = extraInfo['name'];
      var address = extraInfo['address'];
      var infoWindow = InfoWindow(position: marker.position, info: "$name\n$address");
      _controller.showInfoWindow(infoWindow);
      _controller.animateMapStatusUpdateNewLatLng(marker.position);
    });
    _controller.onMapClick.listen((LatLng latLng) async {
      _controller.hideInfoWindow();
    });
    _controller.onMapPoiClick.listen((MapPoi poi) async {});
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
                child: FlutterBMapView(controller: _controller),
              ),
              FlatButton(
                  onPressed: () {
                    var latLngList = _latLngList();
                    int index = 0;
                    List<MarkerOptions> markers = latLngList.map((position) {
                      var option = MarkerOptions(
                          position: position,
                          title: "P$index",
                          icon: "assets/marker.png",
                          extraInfo: {'name': "P$index", 'address': "马塍路文三路口东部软件园创新大厦A-302"});
                      index++;
                      return option;
                    }).toList();
                    _controller.addMarkerOverlays(markers);
                  },
                  child: Text("添加标注点")),
              FlatButton(
                  onPressed: () {
                    var latLngList = _latLngList();
                    int index = 0;
                    List<TextOptions> texts = latLngList.map((position) {
                      var option = TextOptions(position: position, text: "P$index", fontSize: 40);
                      index++;
                      return option;
                    }).toList();
                    _controller.addTextOverlays(texts);
                  },
                  child: Text("添加文本信息")),
              FlatButton(
                  onPressed: () {
                    var latLngList = _latLngList();
                    var customTextureList = [
                      "assets/Icon_road_blue_arrow.png",
                      "assets/Icon_road_green_arrow.png",
                      "assets/Icon_road_red_arrow.png",
                      "assets/Icon_road_yellow_arrow.png"
                    ];
                    var textureIndex = <int>[];
                    var intRandom = Random();
                    for (var index = 0; index < latLngList.length - 1; index++) {
                      textureIndex.add(intRandom.nextInt(customTextureList.length));
                    }
                    var texturePolyline =
                    TexturePolylineOptions(latLngList, customTextureList, textureIndex, width: 10);
                    _controller.addTexturePolyline(texturePolyline);
                  },
                  child: Text("画折线")),
              FlatButton(
                  onPressed: () {
                    _controller.clearMap();
                  },
                  child: Text("清除图层"))
            ],
          ),
        ));
  }

  List<LatLng> _latLngList() {
    return [
      LatLng(30.284949, 120.151828),
      LatLng(30.285059, 120.152659),
      LatLng(30.285053, 120.153653),
      LatLng(30.285153, 120.154753),
      LatLng(30.285253, 120.155733),
    ];
  }
}
