package com.chuangdun.flutter.plugin.bmap

import com.baidu.mapapi.CoordType
import com.baidu.mapapi.SDKInitializer
import com.chuangdun.flutter.plugin.bmap.platform.FlutterBMapViewFactory
import io.flutter.plugin.common.PluginRegistry.Registrar

const val BMAPVIEW_REGISTRY_NAME = "com.chuangdun.flutter/FlutterBMapView"

class FlutterBMapPlugin{
  companion object {
    lateinit var registrar: Registrar
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      FlutterBMapPlugin.registrar = registrar
      SDKInitializer.initialize(registrar.activity().applicationContext)
      SDKInitializer.setCoordType(CoordType.BD09LL)
      registrar.platformViewRegistry()
              .registerViewFactory(BMAPVIEW_REGISTRY_NAME,
                      FlutterBMapViewFactory(registrar.activity(), registrar.messenger()))
    }
  }
}
