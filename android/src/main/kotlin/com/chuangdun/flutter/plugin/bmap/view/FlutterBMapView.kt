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
import io.flutter.plugin.common.EventChannel
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
private const val METHOD_ANIMATE_MAP_STATUS_BOUNDS_PADDING = "animateMapStatusNewBoundsPadding"
private const val METHOD_ANIMATE_MAP_STATUS_BOUNDS_ZOOM = "animateMapStatusNewBoundsZoom"
private const val METHOD_CLEAR_MAP = "clearMap"
private const val EVENT_ON_CLICK = 0
private const val EVENT_ON_POI_CLICK = 1
private const val EVENT_ON_LONG_CLICK = 2
private const val EVENT_ON_DOUBLE_CLICK = 3
private const val EVENT_ON_MARKER_CLICK = 4


class FlutterBMapView(activity: Activity, messenger: BinaryMessenger, id: Int,
                      createParams: Map<String, *>?) : PlatformView, MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    private val tag = this.javaClass.simpleName

    private val activityRef: WeakReference<Activity> = WeakReference(activity)
    private val mapView: MapView
    private val baiduMap: BaiduMap
    private var methodChannel: MethodChannel
    private var eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null

    init {
        Log.i(tag, "FlutterBMapView init.")
        mapView = if (createParams == null)
            MapView(activityRef.get())
        else
            MapView(activityRef.get(), initBMapViewOptions(createParams))
        baiduMap = mapView.map
        methodChannel = MethodChannel(messenger, "${BMAPVIEW_REGISTRY_NAME}_$id")
        methodChannel.setMethodCallHandler(this)
        eventChannel = EventChannel(messenger, "${BMAPVIEW_EVENT_CHANNEL}_$id")
        eventChannel.setStreamHandler(this)
        setUpMapListeners()
    }

    override fun onCancel(p0: Any?) {
        this.eventSink = null
    }

    override fun onListen(p0: Any?, eventSink: EventChannel.EventSink) {
        this.eventSink = eventSink
    }

    private fun setUpMapListeners() {
        baiduMap.setOnMapDoubleClickListener { latLng ->
            eventSink?.success(mapOf(
                    "event" to EVENT_ON_DOUBLE_CLICK,
                    "data" to serializeLatLng(latLng)
            ))
        }
        baiduMap.setOnMapLongClickListener { latLng ->
            eventSink?.success(mapOf(
                    "event" to EVENT_ON_LONG_CLICK,
                    "data" to serializeLatLng(latLng)
            ))
        }
        baiduMap.setOnMarkerClickListener { marker ->
            eventSink?.success(mapOf(
                    "event" to EVENT_ON_MARKER_CLICK,
                    "data" to serializeMarker(marker)
            ))
            true
        }
        baiduMap.setOnMapClickListener(object : OnMapClickListener {
            override fun onMapClick(position: LatLng?) {
                position?.let {
                    eventSink?.success(mapOf(
                            "event" to EVENT_ON_CLICK,
                            "data" to serializeLatLng(it)
                    ))
                }
            }

            override fun onMapPoiClick(poi: MapPoi?): Boolean {
                poi?.let {
                    eventSink?.success(mapOf(
                            "event" to EVENT_ON_POI_CLICK,
                            "data" to serializeMapPoi(it)
                    ))
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
}