package com.chuangdun.flutter.plugin.bmap.platform.view

import android.app.Activity
import android.view.View
import com.baidu.mapapi.map.*
import com.baidu.mapapi.model.LatLngBounds
import com.chuangdun.flutter.plugin.bmap.BMAPVIEW_REGISTRY_NAME
import com.chuangdun.flutter.plugin.bmap.platform.initBMapViewOptions
import com.chuangdun.flutter.plugin.bmap.platform.parseMarkerOptionsList
import com.chuangdun.flutter.plugin.bmap.platform.parseTextOptionsList
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import java.lang.IllegalArgumentException
import java.lang.ref.WeakReference

const val METHOD_MAPVIEW_RESUME = "onMapViewResume"
const val METHOD_MAPVIEW_PAUSE = "onMapViewPause"
const val METHOD_MAPVIEW_DESTROY = "onMapViewDestroy"
const val METHOD_ADD_MARKERS = "addMarkers"
const val METHOD_ADD_TEXTS = "addTexts"

const val DEFAULT_MAPSTATUS_OVERLOOK = 0.0F
const val DEFAULT_MAPSTATUS_ROTATE = 0.0F
const val DEFAULT_MAPSTATUS_ZOOM = 12.0F
const val DEFAULT_MAPSTATUS_LATITUDE = 39.914935
const val DEFAULT_MAPSTATUS_LONGITUDE = 116.403119

class FlutterBMapView(activity: Activity, messenger: BinaryMessenger, id:Int,
                      createParams: Map<String,*>?): PlatformView,MethodChannel.MethodCallHandler{
    private val tag = this.javaClass.simpleName
    private val activityRef: WeakReference<Activity> = WeakReference(activity)

    private val mapView: MapView
    private val baiduMap: BaiduMap
    private var methodChannel: MethodChannel

    init {
        mapView = if (createParams == null)
            MapView(activityRef.get())
        else
            MapView(activityRef.get(), initBMapViewOptions(createParams))
        baiduMap = mapView.map
        methodChannel = MethodChannel(messenger, "${BMAPVIEW_REGISTRY_NAME}_$id")
        methodChannel.setMethodCallHandler(this)
    }



    override fun getView(): View {
        return mapView
    }

    override fun dispose() {
        mapView.onDestroy()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when(call.method){
            METHOD_MAPVIEW_RESUME -> mapView.onResume()
            METHOD_MAPVIEW_PAUSE -> mapView.onPause()
            METHOD_MAPVIEW_DESTROY -> mapView.onDestroy()
            METHOD_ADD_MARKERS -> {
                val markerOptions = call.arguments<List<Map<String, Any>>>()
                val markerOptionList = parseMarkerOptionsList(markerOptions)
                baiduMap.addOverlays(markerOptionList)
                animateMapStatus(markerOptionList)
            }
            METHOD_ADD_TEXTS -> {
                val textOptionsParams = call.arguments<List<Map<String, Any>>>()
                val textOptionList = parseTextOptionsList(textOptionsParams)
                baiduMap.addOverlays(textOptionList)
                animateMapStatus(textOptionList)
            }
            else -> throw NotImplementedError("暂未实现该方法.${call.method}")
        }
    }

    private fun animateMapStatus(optionsList:List<OverlayOptions>){
        val latLngBounds = LatLngBounds.Builder().apply {
            optionsList.forEach{
                when(it){
                    is TextOptions -> include(it.position)
                    is MarkerOptions -> include(it.position)
                    else -> throw NotImplementedError("暂未实现该类型Overlay展示.${it.javaClass.simpleName}")
                }
            }
        }.build()
        val status = MapStatusUpdateFactory.newLatLngBounds(latLngBounds)
        baiduMap.animateMapStatus(status)
    }
}