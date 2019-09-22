package com.chuangdun.flutter.plugin.bmap

import com.baidu.mapapi.CoordType
import com.baidu.mapapi.SDKInitializer
import com.chuangdun.flutter.plugin.bmap.platform.FlutterBMapViewFactory
import com.chuangdun.flutter.plugin.bmap.platform.LocationHandler
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry.Registrar

const val BMAPVIEW_REGISTRY_NAME = "com.chuangdun.flutter/FlutterBMapView"
const val BDLOCATION_CHANEL_NAME = "com.chuangdun.flutter/BDLocation"

class FlutterBMapPlugin{
  companion object {
    lateinit var registrar: Registrar
    lateinit var methodChannel: MethodChannel
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      FlutterBMapPlugin.registrar = registrar
      SDKInitializer.initialize(registrar.activity().applicationContext)
      SDKInitializer.setCoordType(CoordType.BD09LL)
      methodChannel = MethodChannel(registrar.messenger(), BDLOCATION_CHANEL_NAME)
      methodChannel.setMethodCallHandler(LocationHandler(registrar.activity()))
      registrar.platformViewRegistry()
              .registerViewFactory(BMAPVIEW_REGISTRY_NAME,
                      FlutterBMapViewFactory(registrar.activity(), registrar.messenger()))
    }
  }
}
