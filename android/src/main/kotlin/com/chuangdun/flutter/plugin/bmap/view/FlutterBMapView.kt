package com.chuangdun.flutter.plugin.bmap.view

import android.app.Activity
import android.util.Log
import android.view.View
import com.baidu.mapapi.map.*
import com.baidu.mapapi.map.BaiduMap.OnMapClickListener
import com.baidu.mapapi.model.LatLng
import com.chuangdun.flutter.plugin.bmap.*
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import java.lang.ref.WeakReference

class FlutterBMapView(activity: Activity, messenger: BinaryMessenger, id:Int,
                      createParams: Map<String,*>?): PlatformView,MethodChannel.MethodCallHandler{
    private val tag = this.javaClass.simpleName

    private val methodMapViewResume = "setMapViewResume"
    private val methodMapViewPause = "setMapViewPause"
    private val methodMapViewDestroy = "setMapViewDestroy"
    private val methodAddMarkers = "addMarkers"
    private val methodAddTexts = "addTexts"
    private val methodAddTexturePolyline = "addTexturePolyline"
    private val methodShowInfoWindow = "showInfoWindow"
    private val methodHideInfoWindow = "hideInfoWindow"
    private val methodAnimateMapStatusLatLng = "animateMapStatusNewLatLng"
    private val methodAnimateMapStatusBounds = "animateMapStatusNewBounds"
    private val methodAnimateMapStatusBoundsPadding = "animateMapStatusNewBoundsPadding"
    private val methodAnimateMapStatusBoundsZoom = "animateMapStatusNewBoundsZoom"
    private val methodClearMap = "clearMap"

    private val callbackOnMapClick = "onMapClick"
    private val callbackOnMarkerClick = "onMarkerClick"
    private val callbackOnMapPoiClick = "onMapPoiClick"
    private val callbackOnMapLongClick = "onMapLongClick"
    private val callbackOnMapDoubleClick = "onMapDoubleClick"

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
            methodChannel.invokeMethod(callbackOnMapDoubleClick, serializeLatLng(latLng))
        }
        baiduMap.setOnMapLongClickListener { latLng ->
            methodChannel.invokeMethod(callbackOnMapLongClick, serializeLatLng(latLng))
        }
        baiduMap.setOnMarkerClickListener { marker ->
            methodChannel.invokeMethod(callbackOnMarkerClick, serializeMarker(marker))
            true
        }
        baiduMap.setOnMapClickListener(object : OnMapClickListener {
            override fun onMapClick(position: LatLng?) {
                position?.let {
                    methodChannel.invokeMethod(callbackOnMapClick, serializeLatLng(it))
                }
            }

            override fun onMapPoiClick(poi: MapPoi?): Boolean {
                poi?.let {
                    methodChannel.invokeMethod(callbackOnMapPoiClick, serializeMapPoi(it))
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
        methodMapViewResume -> {
            Log.i(tag, "MapView onResume.")
            mapView.onResume()
        }
        methodMapViewPause -> {
            Log.i(tag, "MapView onPause.")
            mapView.onPause()
        }
        methodMapViewDestroy -> {
            Log.i(tag, "MapView onDestroy.")
            mapView.onDestroy()
        }
        methodAddMarkers -> {
            val markerOptions = call.arguments<List<Map<String, Any>>>()
            val markerOptionList = parseMarkerOptionsList(markerOptions)
            baiduMap.addOverlays(markerOptionList)
            baiduMap.animateMapStatus(parseMapStatusUpdate(markerOptionList))
        }
        methodAddTexts -> {
            val textOptionsParams = call.arguments<List<Map<String, Any?>>>()
            val textOptionList = parseTextOptionsList(textOptionsParams)
            baiduMap.addOverlays(textOptionList)
            baiduMap.animateMapStatus(parseMapStatusUpdate(textOptionList))
        }
        methodAddTexturePolyline -> {
            val texturePolylineOptions = call.arguments<Map<String, Any?>>()
            val texturePolyline = parseTexturePolyline(texturePolylineOptions)
            baiduMap.addOverlay(texturePolyline)
            baiduMap.animateMapStatus(parseMapStatusUpdate(listOf(texturePolyline)))
        }
        methodShowInfoWindow -> {
            val infoWindowParams = call.arguments<Map<String, Any?>>()
            val infoWindow = parseInfoWindow(infoWindowParams)
            baiduMap.showInfoWindow(infoWindow)
        }
        methodHideInfoWindow -> {
            baiduMap.hideInfoWindow()
        }
        methodAnimateMapStatusLatLng -> {
            val mapStatusParams = call.arguments<Map<String, Any?>>()
            val mapStatusUpdate = parseMapStatusUpdateNewLatLng(mapStatusParams)
            baiduMap.animateMapStatus(mapStatusUpdate)
        }
        methodAnimateMapStatusBounds -> {
            val mapStatusParams = call.arguments<Map<String, Any?>>()
            val mapStatusUpdate = parseMapStatusUpdateNewBounds(mapStatusParams)
            baiduMap.animateMapStatus(mapStatusUpdate)
        }
        methodAnimateMapStatusBoundsPadding -> {
            val mapStatusParams = call.arguments<Map<String, Any?>>()
            val mapStatusUpdate = parseMapStatusUpdateNewBoundsPadding(mapStatusParams)
            baiduMap.animateMapStatus(mapStatusUpdate)
        }
        methodAnimateMapStatusBoundsZoom -> {
            val mapStatusParams = call.arguments<Map<String, Any?>>()
            val mapStatusUpdate = parseMapStatusUpdateNewBoundsZoom(mapStatusParams)
            baiduMap.animateMapStatus(mapStatusUpdate)
        }
        methodClearMap -> baiduMap.clear()
        else -> throw NotImplementedError("暂未实现该方法.${call.method}")
    }
}