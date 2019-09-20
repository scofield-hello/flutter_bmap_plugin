package com.chuangdun.flutter.plugin.bmap.platform.view

import android.app.Activity
import android.view.View
import com.baidu.mapapi.map.*
import com.baidu.mapapi.map.BaiduMap.OnMapClickListener
import com.baidu.mapapi.model.LatLng
import com.baidu.mapapi.model.LatLngBounds
import com.chuangdun.flutter.plugin.bmap.BMAPVIEW_REGISTRY_NAME
import com.chuangdun.flutter.plugin.bmap.platform.*
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import java.lang.ref.WeakReference

const val METHOD_MAPVIEW_RESUME = "onMapViewResume"
const val METHOD_MAPVIEW_PAUSE = "onMapViewPause"
const val METHOD_MAPVIEW_DESTROY = "onMapViewDestroy"
const val METHOD_ADD_MARKERS = "addMarkers"
const val METHOD_ADD_TEXTS = "addTexts"
const val METHOD_ADD_TEXTURE_POLYLINE = "addTexturePolyline"
const val METHOD_SHOW_INFO_WINDOW = "showInfoWindow"
const val METHOD_HIDE_INFO_WINDOW = "hideInfoWindow"
const val METHOD_ANIMATE_MAP_STATUS_LATLNG = "animateMapStatusNewLatLng"
const val METHOD_ANIMATE_MAP_STATUS_BOUNDS = "animateMapStatusNewBounds"
const val METHOD_CLEAR_MAP = "clearMap"
const val METHOD_ON_MAP_CLICK = "onMapClick"
const val METHOD_ON_MARKER_CLICK = "onMarkerClick"
const val METHOD_ON_MAP_POI_CLICK = "onMapPoiClick"
const val METHOD_ON_MAP_DOUBLE_CLICK = "onMapDoubleClick"
const val METHOD_ON_MAP_LONG_CLICK = "onMapLongClick"
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
        setUpBaiduMap()
    }

    private fun setUpBaiduMap() {
        baiduMap.setOnMapDoubleClickListener { latLng ->
            methodChannel.invokeMethod(METHOD_ON_MAP_DOUBLE_CLICK, serializeLatLng(latLng))
        }
        baiduMap.setOnMapLongClickListener { latLng ->
            methodChannel.invokeMethod(METHOD_ON_MAP_LONG_CLICK, serializeLatLng(latLng))
        }
        baiduMap.setOnMarkerClickListener { marker ->
            methodChannel.invokeMethod(METHOD_ON_MARKER_CLICK, serializeMarker(marker))
            true
        }
        baiduMap.setOnMapClickListener(object : OnMapClickListener {
            override fun onMapClick(position: LatLng?) {
                position?.let {
                    methodChannel.invokeMethod(METHOD_ON_MAP_CLICK, serializeLatLng(it))
                }
            }

            override fun onMapPoiClick(poi: MapPoi?): Boolean {
                poi?.let {
                    methodChannel.invokeMethod(METHOD_ON_MAP_POI_CLICK, serializeMapPoi(it))
                }
                return true
            }
        })
    }



    override fun getView(): View {
        return mapView
    }

    override fun dispose() {
        mapView.onDestroy()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) = when (call.method) {
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
            val textOptionsParams = call.arguments<List<Map<String, Any?>>>()
            val textOptionList = parseTextOptionsList(textOptionsParams)
            baiduMap.addOverlays(textOptionList)
            animateMapStatus(textOptionList)
        }
        METHOD_ADD_TEXTURE_POLYLINE -> {
            val texturePolylineOptions = call.arguments<Map<String, Any?>>()
            val texturePolyline = parseTexturePolyline(texturePolylineOptions)
            baiduMap.addOverlay(texturePolyline)
            animateMapStatus(listOf(texturePolyline))
        }
        METHOD_SHOW_INFO_WINDOW -> {
            val infoWindowParams = call.arguments<Map<String, Any?>>()
            val infoWindow = parseInfoWindow(infoWindowParams)
            baiduMap.showInfoWindow(infoWindow)
        }
        METHOD_HIDE_INFO_WINDOW -> {
            baiduMap.hideInfoWindow()
        }
        METHOD_ANIMATE_MAP_STATUS_LATLNG -> {
            val mapStatusParams = call.arguments<Map<String, Any?>>()
            val zoom = mapStatusParams["zoom"]
            val center = mapStatusParams["center"] as Map<*, *>
            val latLng = deserializeLatLng(center)
            val mapStatusUpdate = if (zoom == null) {
                MapStatusUpdateFactory.newLatLng(latLng)
            } else {
                MapStatusUpdateFactory.newLatLngZoom(latLng, (zoom as Double).toFloat())
            }
            baiduMap.animateMapStatus(mapStatusUpdate)
        }
        METHOD_ANIMATE_MAP_STATUS_BOUNDS -> {
            val mapStatusParams = call.arguments<Map<String, Any?>>()
            val bounds = mapStatusParams["bounds"] as List<*>
            val latLngBounds = LatLngBounds.Builder().apply {
                bounds.forEach {
                    val pairedLatLng = it as Map<*, *>
                    val latLng = deserializeLatLng(pairedLatLng)
                    include(latLng)
                }
            }.build()
            val mapStatusUpdate = MapStatusUpdateFactory.newLatLngBounds(latLngBounds)
            baiduMap.animateMapStatus(mapStatusUpdate)
        }
        METHOD_CLEAR_MAP -> baiduMap.clear()
        else -> throw NotImplementedError("暂未实现该方法.${call.method}")
    }

    private fun animateMapStatus(optionsList:List<OverlayOptions>){
        val latLngBounds = LatLngBounds.Builder().apply {
            optionsList.forEach{
                when(it){
                    is TextOptions -> include(it.position)
                    is MarkerOptions -> include(it.position)
                    is PolylineOptions -> {
                        it.points.forEach { point -> include(point) }
                    }
                    else -> throw NotImplementedError("暂未实现该类型Overlay展示.${it.javaClass.simpleName}")
                }
            }
        }.build()
        val status = MapStatusUpdateFactory.newLatLngBounds(latLngBounds)
        baiduMap.animateMapStatus(status)
    }


}