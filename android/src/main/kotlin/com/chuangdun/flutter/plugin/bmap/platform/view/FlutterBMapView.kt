package com.chuangdun.flutter.plugin.bmap.platform.view

import android.app.Activity
import android.util.Log
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
const val METHOD_ANIMATE_MAP_STATUS_BOUNDS_PADDING = "animateMapStatusNewBoundsPadding"
const val METHOD_ANIMATE_MAP_STATUS_BOUNDS_ZOOM = "animateMapStatusNewBoundsZoom"
const val METHOD_CLEAR_MAP = "clearMap"
const val METHOD_ON_MAP_CLICK = "onMapClick"
const val METHOD_ON_MARKER_CLICK = "onMarkerClick"
const val METHOD_ON_MAP_POI_CLICK = "onMapPoiClick"
const val METHOD_ON_MAP_DOUBLE_CLICK = "onMapDoubleClick"
const val METHOD_ON_MAP_LONG_CLICK = "onMapLongClick"


class FlutterBMapView(activity: Activity, messenger: BinaryMessenger, id:Int,
                      createParams: Map<String,*>?): PlatformView,MethodChannel.MethodCallHandler{
    private val tag = this.javaClass.simpleName
    private val activityRef: WeakReference<Activity> = WeakReference(activity)

    private val mapView: MapView
    private val baiduMap: BaiduMap
    private var methodChannel: MethodChannel

    init {
        Log.i(tag, "FlutterBMapView init.")
        mapView = if (createParams == null)
            MapView(activityRef.get())
        else
            MapView(activityRef.get(), initBMapViewOptions(createParams))
        baiduMap = mapView.map
        methodChannel = MethodChannel(messenger, "${BMAPVIEW_REGISTRY_NAME}_$id")
        methodChannel.setMethodCallHandler(this)
        setUpMapListeners()
    }

    private fun setUpMapListeners() {
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
        Log.i(tag, "getView: $mapView")
        return mapView
    }

    override fun dispose() {
        Log.i(tag, "FlutterBMapView disposed.")
        mapView.onDestroy()
        Log.i(tag, "MapView destroyed.")
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) = when (call.method) {
        METHOD_MAPVIEW_RESUME -> {
            Log.i(tag, "MapView onResume.")
            mapView.onResume()
        }
        METHOD_MAPVIEW_PAUSE -> {
            Log.i(tag, "MapView onPause.")
            mapView.onPause()
        }
        METHOD_MAPVIEW_DESTROY -> {
            Log.i(tag, "MapView onDestroy.")
            mapView.onDestroy()
        }
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
            val mapStatusUpdate = parseMapStatusUpdateNewLatLng(mapStatusParams)
            baiduMap.animateMapStatus(mapStatusUpdate)
        }
        METHOD_ANIMATE_MAP_STATUS_BOUNDS -> {
            val mapStatusParams = call.arguments<Map<String, Any?>>()
            val mapStatusUpdate = parseMapStatusUpdateNewBounds(mapStatusParams)
            baiduMap.animateMapStatus(mapStatusUpdate)
        }
        METHOD_ANIMATE_MAP_STATUS_BOUNDS_PADDING -> {
            val mapStatusParams = call.arguments<Map<String, Any?>>()
            val mapStatusUpdate = parseMapStatusUpdateNewBoundsPadding(mapStatusParams)
            baiduMap.animateMapStatus(mapStatusUpdate)
        }
        METHOD_ANIMATE_MAP_STATUS_BOUNDS_ZOOM -> {
            val mapStatusParams = call.arguments<Map<String, Any?>>()
            val mapStatusUpdate = parseMapStatusUpdateNewBoundsZoom(mapStatusParams)
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
        val status = MapStatusUpdateFactory.newLatLngBounds(latLngBounds, 100, 100, 100, 100)
        baiduMap.animateMapStatus(status)
    }


}