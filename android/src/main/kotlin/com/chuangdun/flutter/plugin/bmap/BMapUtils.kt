package com.chuangdun.flutter.plugin.bmap

import android.os.Bundle
import android.util.Log
import android.widget.TextView
import com.baidu.mapapi.map.*
import com.baidu.mapapi.model.LatLng
import com.baidu.mapapi.model.LatLngBounds
import java.io.Serializable

const val DEFAULT_MAPSTATUS_OVERLOOK = 0.0F
const val DEFAULT_MAPSTATUS_ROTATE = 0.0F
const val DEFAULT_MAPSTATUS_ZOOM = 12.0F
const val DEFAULT_MAPSTATUS_LATITUDE = 39.914935
const val DEFAULT_MAPSTATUS_LONGITUDE = 116.403119

fun initBMapViewOptions(createParams: Map<String, *>): BaiduMapOptions {
    Log.d("BMapUtils", "initBMapViewOptions:$createParams")
    val baiduMapOptions = BaiduMapOptions()
    val compassEnabled = createParams.getOrElse("compassEnabled", { true })
    val logoPosition = createParams.getOrElse("logoPosition", { LogoPosition.logoPostionleftBottom.name })
    val mapType = createParams.getOrElse("mapType", { BaiduMap.MAP_TYPE_NORMAL })
    val overlookingGesturesEnabled = createParams.getOrElse("overlookingGesturesEnabled", { true })
    val rotateGesturesEnabled = createParams.getOrElse("rotateGesturesEnabled", { true })
    val scaleControlEnabled = createParams.getOrElse("scaleControlEnabled", { true })
    val scrollGesturesEnabled = createParams.getOrElse("scrollGesturesEnabled", { true })
    val zoomControlsEnabled = createParams.getOrElse("zoomControlsEnabled", { true })
    val zoomGesturesEnabled = createParams.getOrElse("zoomGesturesEnabled", { true })
    val mapStatus = createParams.getOrElse("mapStatus", { hashMapOf<String, Any>() }) as Map<String, Any>
    val overlook = mapStatus.getOrElse("overlook", { DEFAULT_MAPSTATUS_OVERLOOK })
    val rotate = mapStatus.getOrElse("rotate", { DEFAULT_MAPSTATUS_ROTATE })
    val zoom = mapStatus.getOrElse("zoom", { DEFAULT_MAPSTATUS_ZOOM })
    val target = mapStatus.getOrElse("target", { hashMapOf<String, Any>() }) as Map<String, Any>
    val latitude = target.getOrElse("latitude", { DEFAULT_MAPSTATUS_LATITUDE })
    val longitude = target.getOrElse("longitude", { DEFAULT_MAPSTATUS_LONGITUDE })

    baiduMapOptions.apply {
        compassEnabled(compassEnabled as Boolean)
        logoPosition(LogoPosition.valueOf(logoPosition as String))
        mapType(mapType as Int)
        overlookingGesturesEnabled(overlookingGesturesEnabled as Boolean)
        rotateGesturesEnabled(rotateGesturesEnabled as Boolean)
        scaleControlEnabled(scaleControlEnabled as Boolean)
        scrollGesturesEnabled(scrollGesturesEnabled as Boolean)
        zoomControlsEnabled(zoomControlsEnabled as Boolean)
        zoomGesturesEnabled(zoomGesturesEnabled as Boolean)
        val initLatLng = LatLng(latitude as Double, longitude as Double)
        val initMapStatus = MapStatus.Builder()
                .target(initLatLng)
                .overlook((overlook as Double).toFloat())
                .rotate((rotate as Double).toFloat())
                .zoom((zoom as Double).toFloat())
                .build()
        mapStatus(initMapStatus)
    }
    return baiduMapOptions
}

fun parseMarkerOptionsList(optionList: List<Map<*, *>>): List<MarkerOptions> {
    val markerOptionsList = mutableListOf<MarkerOptions>()
    optionList.map {
        val icon = it["icon"] as String
        val position = it["position"] as Map<*, *>
        val visible = it["visible"] as Boolean
        val animateType = it["animateType"] as String
        val alpha = it["alpha"] as Double
        val perspective = it["perspective"] as Boolean
        val draggable = it["draggable"] as Boolean
        val flat = it["flat"] as Boolean
        val rotate = it["rotate"] as Double
        val extraInfo = it["extraInfo"] as Map<*, *>
        val zIndex = it["zIndex"] as Int
        val latLng = deserializeLatLng(position)
        val markerOptions = MarkerOptions()
        val bundle = deserializeBundle(extraInfo)
        markerOptions.apply {
            icon(BMapViewAssets.getBitmapDescriptor(icon))
            position(latLng)
            visible(visible)
            animateType(MarkerOptions.MarkerAnimateType.valueOf(animateType))
            alpha(alpha.toFloat())
            perspective(perspective)
            draggable(draggable)
            flat(flat)
            rotate(rotate.toFloat())
            extraInfo(bundle)
            zIndex(zIndex)
        }
        markerOptionsList.add(markerOptions)
    }
    return markerOptionsList
}

fun parseTextOptionsList(optionList: List<Map<*, *>>): List<TextOptions> {
    val textOptionsList = mutableListOf<TextOptions>()
    optionList.map {
        val alignX = it["alignX"] as Int
        val alignY = it["alignY"] as Int
        val position = it["position"] as Map<*, *>
        val text = it["text"] as String
        val visible = it["visible"] as Boolean
        val bgColor = it["bgColor"] as String
        val fontColor = it["fontColor"] as String
        val fontSize = it["fontSize"] as Int
        val rotate = it["rotate"] as Double
        val extraInfo = it["extraInfo"] as Map<*, *>
        val zIndex = it["zIndex"] as Int
        val latLng = deserializeLatLng(position)
        val bundle = deserializeBundle(extraInfo)
        val textOptions = TextOptions()
        textOptions.apply {
            position(latLng)
            visible(visible)
            align(alignX, alignY)
            text(text)
            bgColor(bgColor.toLong().toInt())
            fontColor(fontColor.toLong().toInt())
            fontSize(fontSize)
            rotate(rotate.toFloat())
            extraInfo(bundle)
            zIndex(zIndex)
        }
        textOptionsList.add(textOptions)
    }
    return textOptionsList
}

fun parseInfoWindow(infoWindowOptions: Map<*, *>): InfoWindow {
    val position = infoWindowOptions["position"] as Map<*, *>
    val info = infoWindowOptions["info"] as String
    val yOffset = infoWindowOptions["yOffset"] as Int
    val textColor = infoWindowOptions["textColor"] as String
    val textSize = infoWindowOptions["textSize"] as Double
    val tag = infoWindowOptions["tag"] as String?
    val latLng = deserializeLatLng(position)
    val mInflater = FlutterBMapPlugin.registrar.activity().layoutInflater
    val infoWindowView = mInflater.inflate(R.layout.info_window,
            null, false) as TextView
    infoWindowView.apply {
        setTextColor(textColor.toLong().toInt())
        setTextSize(textSize.toFloat())
        text = info
    }
    val infoWindow = InfoWindow(infoWindowView, latLng, yOffset)
    infoWindow.tag = tag
    return infoWindow
}

fun parseTexturePolyline(texturePolylineOptions: Map<*, *>): PolylineOptions {
    val points = texturePolylineOptions["points"] as List<*>
    val customTextureList = texturePolylineOptions["customTextureList"] as List<*>
    val textureIndex = texturePolylineOptions["textureIndex"] as List<Int>
    val width = texturePolylineOptions["width"] as Int
    val dottedLine = texturePolylineOptions["dottedLine"] as Boolean
    val serializedExtraInfo = texturePolylineOptions["extraInfo"] as Map<*, *>
    val extraInfo = deserializeBundle(serializedExtraInfo)
    val latLngList = points.map {
        deserializeLatLng(it as Map<*, *>)
    }
    val textureList = customTextureList.map {
        BMapViewAssets.getBitmapDescriptor(it as String)
    }
    val polylineOptions = PolylineOptions()

    polylineOptions.apply {
        width(width)
        dottedLine(dottedLine)
        points(latLngList)
        customTextureList(textureList)
        textureIndex(textureIndex)
        extraInfo(extraInfo)
    }
    return polylineOptions

}

fun parseMapStatusUpdateNewLatLng(mapStatusParams: Map<String, Any?>): MapStatusUpdate {
    val zoom = mapStatusParams["zoom"] as Double?
    val center = mapStatusParams["center"] as Map<*, *>
    val latLng = deserializeLatLng(center)
    return if (zoom == null) {
        MapStatusUpdateFactory.newLatLng(latLng)
    } else {
        MapStatusUpdateFactory.newLatLngZoom(latLng, zoom.toFloat())
    }
}

fun parseMapStatusUpdateNewBounds(mapStatusParams: Map<String, Any?>): MapStatusUpdate {
    val bounds = mapStatusParams["bounds"] as List<*>
    val width = mapStatusParams["width"] as Int?
    val height = mapStatusParams["height"] as Int?
    val latLngBounds = parseLatLngBounds(bounds)
    return if (width == null || height == null) {
        MapStatusUpdateFactory.newLatLngBounds(latLngBounds)
    } else {
        MapStatusUpdateFactory.newLatLngBounds(latLngBounds, width, height)
    }
}

fun parseLatLngBounds(latLngList: List<*>): LatLngBounds {
    return LatLngBounds.Builder().apply {
        latLngList.forEach {
            val pairedLatLng = it as Map<*, *>
            val latLng = deserializeLatLng(pairedLatLng)
            include(latLng)
        }
    }.build()
}

fun parseMapStatusUpdateNewBoundsPadding(mapStatusParams: Map<String, Any?>): MapStatusUpdate {
    val bounds = mapStatusParams["bounds"] as List<*>
    val paddingLeft = mapStatusParams["paddingLeft"] as Int
    val paddingTop = mapStatusParams["paddingTop"] as Int
    val paddingRight = mapStatusParams["paddingRight"] as Int
    val paddingBottom = mapStatusParams["paddingBottom"] as Int
    val latLngBounds = parseLatLngBounds(bounds)
    return MapStatusUpdateFactory.newLatLngBounds(latLngBounds,
            paddingLeft,
            paddingTop,
            paddingRight,
            paddingBottom)
}

fun parseMapStatusUpdateNewBoundsZoom(mapStatusParams: Map<String, Any?>): MapStatusUpdate {
    val bounds = mapStatusParams["bounds"] as List<*>
    val paddingLeft = mapStatusParams["paddingLeft"] as Int
    val paddingTop = mapStatusParams["paddingTop"] as Int
    val paddingRight = mapStatusParams["paddingRight"] as Int
    val paddingBottom = mapStatusParams["paddingBottom"] as Int
    val latLngBounds = parseLatLngBounds(bounds)
    return MapStatusUpdateFactory.newLatLngZoom(latLngBounds,
            paddingLeft,
            paddingTop,
            paddingRight,
            paddingBottom)
}

fun parseMapStatusUpdate(optionsList: List<OverlayOptions>,
                         paddingLeft: Int = 100, paddingTop: Int = 100,
                         paddingRight: Int = 100, paddingBottom: Int = 100): MapStatusUpdate {
    val latLngBounds = LatLngBounds.Builder().apply {
        optionsList.forEach {
            when (it) {
                is TextOptions -> include(it.position)
                is MarkerOptions -> include(it.position)
                is PolylineOptions -> {
                    it.points.forEach { point -> include(point) }
                }
                else -> throw NotImplementedError("暂未实现该类型Overlay展示.${it.javaClass.simpleName}")
            }
        }
    }.build()
    return MapStatusUpdateFactory.newLatLngBounds(latLngBounds,
            paddingLeft,
            paddingTop,
            paddingRight,
            paddingBottom)
}

fun deserializeBundle(serializedBundle: Map<*, *>): Bundle {
    val bundle = Bundle()
    for ((key, value) in serializedBundle.entries) {
        bundle.putSerializable(key as String,
                value as Serializable)
    }
    return bundle
}

fun serializeBundle(bundle: Bundle?): Map<String, Any?> {
    val serializedBundle = mutableMapOf<String, Any?>()
    bundle?.let { b ->
        b.keySet().forEach { key ->
            serializedBundle[key] = b.get(key)
        }
    }
    return serializedBundle
}

fun deserializeLatLng(serializedLatLng: Map<*, *>): LatLng {
    return LatLng(serializedLatLng["latitude"] as Double, serializedLatLng["longitude"] as Double)
}

fun serializeLatLng(latLng: LatLng?): Map<String, Double> {
    val serializedLatLng = mutableMapOf<String, Double>()
    latLng?.let {
        serializedLatLng["latitude"] = it.latitude
        serializedLatLng["longitude"] = it.longitude
    }
    return serializedLatLng
}

fun serializeMapPoi(poi: MapPoi?): Map<String, Any?> {
    val serializedMapPoi = mutableMapOf<String, Any?>()
    poi?.let {
        serializedMapPoi["uid"] = poi.uid
        serializedMapPoi["name"] = poi.name
        serializedMapPoi["position"] = serializeLatLng(poi.position)
    }
    return serializedMapPoi
}

fun serializeMarker(marker: Marker): Map<String, Any?> {
    val serializedMarker = mutableMapOf<String, Any?>()
    serializedMarker["position"] = serializeLatLng(marker.position)
    serializedMarker["title"] = marker.title
    serializedMarker["extraInfo"] = serializeBundle(marker.extraInfo)
    return serializedMarker
}