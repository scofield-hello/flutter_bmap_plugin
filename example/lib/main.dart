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
                List<MarkerOptions> markers = latLngList.map((it) {
                  var option =
                      MarkerOptions(position: it, title: "P$index", icon: "assets/marker.png");
                  index++;
                  return option;
                }).toList();
                _controller.addMarkerOverlays(markers);
              },
              child: Text("添加MarkerOverlays")),
          FlatButton(
              onPressed: () {
                var latLngList = _latLngList();
                int index = 0;
                List<TextOptions> texts = latLngList.map((it) {
                  var option = TextOptions(
                      position: it,
                      text: "P$index",
                      fontSize: 40,
                      alignY: TextOptionsAlign.alignTop);
                  index++;
                  return option;
                }).toList();
                _controller.addTextOverlays(texts);
              },
              child: Text("添加TextOverlays"))
        ],
      ),
    ));
  }

  List<LatLng> _latLngList() {
    return [
      LatLng(30.284949, 120.152828),
      LatLng(30.285059, 120.152659),
      LatLng(30.285053, 120.152653),
      LatLng(30.285153, 120.152753),
      LatLng(30.285253, 120.152733),
    ];
  }
}
