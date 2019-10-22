package com.chuangdun.flutter.plugin.bmap.view

import android.app.Activity
import android.util.Log
import android.view.View
import com.baidu.mapapi.map.BaiduMap
import com.baidu.mapapi.map.BaiduMap.OnMapClickListener
import com.baidu.mapapi.map.MapPoi
import com.baidu.mapapi.map.MapView
import com.baidu.mapapi.model.LatLng
import com.chuangdun.flutter.plugin.bmap.*
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import java.lang.ref.WeakReference

private const val METHOD_MAP_VIEW_RESUME = "setMapViewResume"
private const val METHOD_MAP_VIEW_PAUSE = "setMapViewPause"
private const val METHOD_MAP_VIEW_DESTROY = "setMapViewDestroy"
private const val METHOD_MAP_VIEW_MARKERS = "addMarkers"
private const val METHOD_ADD_TEXTS = "addTexts"
private const val METHOD_ADD_TEXTURE_POLYLINE = "addTexturePolyline"
private const val METHOD_SHOW_INFO_WINDOW = "showInfoWindow"
private const val METHOD_HIDE_INFO_WINDOW = "hideInfoWindow"
private const val METHOD_ANIMATE_MAP_STATUS_LATLNG = "animateMapStatusNewLatLng"
private const val METHOD_ANIMATE_MAP_STATUS_BOUNDS = "animateMapStatusNewBounds"
private const val METHOD_ANIMATE_MAP_STAUTS_BOUNDS_PADDING = "animateMapStatusNewBoundsPadding"
private const val METHOD_ANIMATE_MAP_STATUS_BOUNDS_ZOOM = "animateMapStatusNewBoundsZoom"
private const val METHOD_CLEAR_MAP = "clearMap"
private const val CALLBACK_ON_MAP_CLICK = "onMapClick"
private const val CALLBACK_ON_MARKER_CLICK = "onMarkerClick"
private const val CALLBACK_ON_MAP_POI_CLICK = "onMapPoiClick"
private const val CALLBACK_ON_MAP_LONG_CLICK = "onMapLongClick"
private const val CALLBACK_ON_MAP_DOUBLE_CLICK = "onMapDoubleClick"
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
            methodChannel.invokeMethod(CALLBACK_ON_MAP_DOUBLE_CLICK, serializeLatLng(latLng))
        }
        baiduMap.setOnMapLongClickListener { latLng ->
            methodChannel.invokeMethod(CALLBACK_ON_MAP_LONG_CLICK, serializeLatLng(latLng))
        }
        baiduMap.setOnMarkerClickListener { marker ->
            methodChannel.invokeMethod(CALLBACK_ON_MARKER_CLICK, serializeMarker(marker))
            true
        }
        baiduMap.setOnMapClickListener(object : OnMapClickListener {
            override fun onMapClick(position: LatLng?) {
                position?.let {
                    methodChannel.invokeMethod(CALLBACK_ON_MAP_CLICK, serializeLatLng(it))
                }
            }

            override fun onMapPoiClick(poi: MapPoi?): Boolean {
                poi?.let {
                    methodChannel.invokeMethod(CALLBACK_ON_MAP_POI_CLICK, serializeMapPoi(it))
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
        METHOD_MAP_VIEW_RESUME -> {
            Log.i(tag, "MapView onResume.")
            mapView.onResume()
        }
        METHOD_MAP_VIEW_PAUSE -> {
            Log.i(tag, "MapView onPause.")
            mapView.onPause()
        }
        METHOD_MAP_VIEW_DESTROY -> {
            Log.i(tag, "MapView onDestroy.")
            mapView.onDestroy()
        }
        METHOD_MAP_VIEW_MARKERS -> {
            val markerOptions = call.arguments<List<Map<String, Any>>>()
            val markerOptionList = parseMarkerOptionsList(markerOptions)
            baiduMap.addOverlays(markerOptionList)
            baiduMap.animateMapStatus(parseMapStatusUpdate(markerOptionList))
        }
        METHOD_ADD_TEXTS -> {
            val textOptionsParams = call.arguments<List<Map<String, Any?>>>()
            val textOptionList = parseTextOptionsList(textOptionsParams)
            baiduMap.addOverlays(textOptionList)
            baiduMap.animateMapStatus(parseMapStatusUpdate(textOptionList))
        }
        METHOD_ADD_TEXTURE_POLYLINE -> {
            val texturePolylineOptions = call.arguments<Map<String, Any?>>()
            val texturePolyline = parseTexturePolyline(texturePolylineOptions)
            baiduMap.addOverlay(texturePolyline)
            baiduMap.animateMapStatus(parseMapStatusUpdate(listOf(texturePolyline)))
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
        METHOD_ANIMATE_MAP_STAUTS_BOUNDS_PADDING -> {
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
}