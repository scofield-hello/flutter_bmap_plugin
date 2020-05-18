# flutter_bmap_plugin
百度地图/定位插件

![](https://github.com/scofield-hello/flutter_bmap_plugin/blob/master/screenshot.png)

## 在项目中添加插件依赖项
1. 在pubspec.yaml中添加插件依赖项

```yaml
  dependencies:
    flutter_bmap_plugin:
      git: git://github.com/scofield-hello/flutter_bmap_plugin.git
```

## 集成百度地图Android版本

1. 先申请一个apikey
http://lbsyun.baidu.com/apiconsole/key

2. 修改 `你的项目目录/app/build.gradle`
在`android/defaultConfig`节点修改`manifestPlaceholders`,新增百度地图AK配置

```
android {
    ....
    defaultConfig {
        .....
         manifestPlaceholders = [
                BAIDU_MAP_KEY : "百度地图AK",
        ]
    }
```

## 集成百度地图iOS版本

1. 在Info.plist中添加下面的配置

```
<key>BaiduMap</key>
	<dict>
		<key>sdk_key</key>
		<string>your location_sdk_key</string>
	</dict>

<key>UIBackgroundModes</key>
	<array>
		<string>location</string>
	</array>
```

2. 添加第三方openssl静态库

[操作步骤](http://lbsyun.baidu.com/apiconsole/key)

3. 添加图片资源

将example/assets中的图片资源添加至ios/Runner的资源中

## 地图相关使用方法

1. 显示百度地图(FlutterBMapView)

```dart
class XxxState extends State<XxxWidget> with WidgetsBindingObserver{

  FlutterBMapViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FlutterBMapViewController();
    ///监听生命周期事件.
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('FlutterBMapView'),
      ),
      body: FlutterBMapView(controller: _controller, onBMapViewCreated: _onBMapViewCreated)
    ));
  }

  ///地图创建后回调.
  void _onBMapViewCreated() {
    ///调用MapView.onResume()
    _controller.setMapViewResume();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("didChangeAppLifecycleState:resume");
        _controller.setMapViewResume();
        break;
      case AppLifecycleState.inactive:
        print("didChangeAppLifecycleState:inactive");
        break;
      case AppLifecycleState.paused:
        print("didChangeAppLifecycleState:pause");
        _controller.setMapViewPause();
        break;
      case AppLifecycleState.suspending:
        print("didChangeAppLifecycleState:suspending");
        break;
    }
  }
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
  } 
}  
```

2. 处理地图点击事件

```dart
  _controller.onMapClick.listen((LatLng latLng) async {
    println(latLng.asJson());
    //隐藏InfoWindow等...
  });
```

3. 处理地图双击事件

```dart
  _controller.onMapDoubleClick.listen((LatLng latLng) async {
    print(latLng.asJson());
  });
```

4. 处理地图长点击事件

```dart
  _controller.onMapLongClick.listen((LatLng latLng) async {
    print(latLng.asJson());
  });
```

5. 处理标注点击事件

```dart
  _controller.onMarkerClick.listen((Marker marker) async {
    var extraInfo = marker.extraInfo;
    //构造InfoWindow等...
  });
```

6. 处理Poi点击事件

```dart
  _controller.onMapPoiClick.listen((MapPoi poi) async {
    print(poi.asJson());
  });
```

7. 新增标注点

```dart
  ///测试点列表.
  List<LatLng> _latLngList() {
    return const [
      LatLng(latitude: 30.284949, longitude: 120.151828),
      LatLng(latitude: 30.285059, longitude: 120.152659),
      LatLng(latitude: 30.285053, longitude: 120.153653),
      LatLng(latitude: 30.285153, longitude: 120.154753),
      LatLng(latitude: 30.285253, longitude: 120.155733),
    ];
  }
  ///添加标注.
  void _addMarkers() {
    var latLngList = _latLngList();
    List<MarkerOptions> markers = [];
    //构建标注物MarkerOptions
    for (var index = 0; index < latLngList.length; index++) {
      var option = MarkerOptions(
          zIndex: 100,
          position: latLngList[index],
          title: "P$index",
          icon: Platform.isAndroid? "assets/marker.png":"marker.png",
          extraInfo: {'name': "P$index", 'address': "马塍路文三路口东部软件园创新大厦A-302"});
      markers.add(option);
    }
    markers.first.icon = Platform.isAndroid ? "assets/Icon_start.png":"Icon_start.png";
    markers.last.icon = Platform.isAndroid ? "assets/Icon_end.png": "Icon_end.png";
    //显示标注
    _controller.addMarkerOverlays(markers);
  }
```

8. 显示文本信息(iOS未实现)

```dart
  void _addTextOptionsList() {
    var latLngList = _latLngList();
    List<TextOptions> texts = [];
    //构建文本信息TextOptions
    for (var index = 0; index < latLngList.length; index++) {
      var option = TextOptions(position: latLngList[index], text: "P$index", fontSize: 40);
      texts.add(option);
    }
    //显示文本.
    _controller.addTextOverlays(texts);
  }
```

9. 画折线(Texture)

```dart
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

```

10. 显示信息窗InfoWindow(iOS未实现).

```dart
  _controller.onMarkerClick.listen((Marker marker) async {
      var extraInfo = marker.extraInfo;
      var name = extraInfo['name'];
      var address = extraInfo['address'];
      //构建InfoWindow
      var infoWindow = InfoWindow(position: marker.position, info: "$name\n$address");
      //显示信息窗
      _controller.showInfoWindow(infoWindow);
    });
   _controller.onMapClick.listen((LatLng latLng) async {
     //隐藏信息窗
     _controller.hideInfoWindow();
   });
```

11. 设置地图显示范围

```dart
  ///设置地图中心点以及缩放级别.
  ///[latLng] 经纬度对象.
  ///[zoom] 地图缩放级别.
  _controller.animateMapStatusNewLatLng(LatLng latLng, {double zoom});

  ///设置显示在规定宽高中的地图地理范围(iOS未实现).
  ///[bounds] 经纬度范围.
  ///[width] 地图宽度,[height] 地图高度.
  _controller.animateMapStatusUpdateNewBounds(List<LatLng> bounds, {int width, int height});

  ///设置显示在指定相对与MapView的padding中的地图地理范围(iOS未实现).
  ///[bounds] 经纬度范围.
  ///[paddingTop]...padding设置
  _controller.animateMapStatusBoundsPadding(List<LatLng> bounds,
      {int paddingLeft = 0, int paddingTop = 0, int paddingRight = 0, int paddingBottom = 0});
  }

  ///根据Padding设置地理范围的合适缩放级别(iOS未实现).
  ///[bounds] 经纬度范围.[paddingTop]... padding设置
  _controller.animateMapStatusBoundsZoom(List<LatLng> bounds,
        {int paddingLeft = 0, int paddingTop = 0, int paddingRight = 0, int paddingBottom = 0});
```

12. 清除地图图层
```dart
  _controller.clearMap();
```

## 定位相关使用方法

1. 初始化

```dart
  final _locationClient = BDLocationClient();
  //监听位置回调.
  _locationClient.onReceiveLocation.listen((location) {
    _controller.animateMapStatusNewLatLng(
        LatLng(latitude: location.latitude, longitude: location.longitude));
  });

  @override
  void dispose(){
    _stopLocation();
    _locationClient.dispose();
  }
```

2. 开启定位

```dart
  void _startLocation() async{
    try {
      var options =
          LocationClientOption(coorType: CoorType.bd09ll, prodName: "Flutter Plugin Test");
      await _locationClient.startLocation(options);
    } on PlatformException catch (e) {
      print(e);
    }
  }
```

3. 单次请求定位.

```dart
  void _requestLocation() async {
    try {
      await _locationClient.requestLocation();
    } on PlatformException catch (e) {
      print(e);
    }
  }
```

4. 停止定位

```dart

  void _stopLocation() async{
    try {
      if (await _locationClient.isStart()) {
        await _locationClient.stopLocation();
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }
```

5. 判断是否启动定位
```dart
 void _isStart() async{
    try {
      bool start = await _locationClient.isStart();
      print(start);
    } on PlatformException catch (e) {
      print(e);
    }
  }
```

## 百度地图工具方法

1. 坐标转换

```dart
  ///单个坐标转换.
  void _convert() async {
    try {
      var latLng = await BMapApiUtils.convert(CoordType.gps, _latLngList()[0]);
      print(latLng.asJson());
    } on PlatformException catch (e) {
      print(e);
    }
  }

  ///多个坐标转换.
  void _convertList() async {
    try {
      var latLngList = await BMapApiUtils.convertList(CoordType.gps, _latLngList());
      print(latLngList);
    } on PlatformException catch (e) {
      print(e);
    }
  }
```

2. 计算两点间距离

```dart
  void _getDistance() async {
    try {
      var latLngList = _latLngList();
      var distance = await BMapApiUtils.getDistance(latLngList[0], latLngList[1]);
      print(distance);
    } on PlatformException catch (e) {
      print(e);
    }
  }
```

3. 计算面积(iOS未实现)

```dart
  void _calculateArea() async {
    try {
      var latLngList = _latLngList();
      var area = await BMapApiUtils.calculateArea(latLngList[0], latLngList[1]);
      print(area);
    } on PlatformException catch (e) {
      print(e);
    }
  }
```

4. 返回某点距线上最近的点

```dart
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
```

5. 判断圆形是否包含传入的经纬度点

```dart
  void _isCircleContainsPoint() async {
    try {
      var latLngList = _latLngList();
      var contains = await BMapApiUtils.isCircleContainsPoint(latLngList[0], 1000, latLngList[1]);
      print(contains);
    } on PlatformException catch (e) {
      print(e);
    }
  }
```

6. 判断一个点是否在一个多边形区域内

```dart
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
```

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
