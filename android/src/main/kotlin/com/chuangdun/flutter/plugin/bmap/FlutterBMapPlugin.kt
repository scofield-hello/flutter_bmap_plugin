package com.chuangdun.flutter.plugin.bmap

import com.baidu.mapapi.CoordType
import com.baidu.mapapi.SDKInitializer
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry.Registrar

const val BMAPVIEW_REGISTRY_NAME = "com.chuangdun.flutter/BMapApi.FlutterBMapView"
const val LOCATION_CHANEL_NAME = "com.chuangdun.flutter/BMapApi.LocationClient"
const val LOCATION_EVENT_CHANEL_NAME = "com.chuangdun.flutter/BMapApi.LocationChanged"
const val COORDINATE_CHANEL_NAME = "com.chuangdun.flutter/BMapApi.Utils"

class FlutterBMapPlugin {
    companion object {
        lateinit var registrar: Registrar
        lateinit var methodChannel: MethodChannel
        lateinit var eventChannel: EventChannel
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            FlutterBMapPlugin.registrar = registrar
            SDKInitializer.initialize(registrar.activity().applicationContext)
            SDKInitializer.setCoordType(CoordType.BD09LL)
            methodChannel = MethodChannel(registrar.messenger(), LOCATION_CHANEL_NAME)
            val locationHandler = LocationHandler(registrar.activity())
            methodChannel.setMethodCallHandler(locationHandler)
            eventChannel = EventChannel(registrar.messenger(), LOCATION_EVENT_CHANEL_NAME)
            eventChannel.setStreamHandler(locationHandler)
            val coordinateChannel = MethodChannel(registrar.messenger(), COORDINATE_CHANEL_NAME)
            coordinateChannel.setMethodCallHandler(BMapApiUtilsHandler)
            registrar.platformViewRegistry()
                    .registerViewFactory(BMAPVIEW_REGISTRY_NAME,
                            FlutterBMapViewFactory(registrar.activity(), registrar.messenger()))
        }
    }
}
