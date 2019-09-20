package com.chuangdun.flutter.plugin.bmap.platform

import android.os.Bundle
import android.util.Log
import android.widget.TextView
import com.baidu.mapapi.map.*
import com.baidu.mapapi.model.LatLng
import com.chuangdun.flutter.plugin.bmap.FlutterBMapPlugin
import com.chuangdun.flutter.plugin.bmap.R
import com.chuangdun.flutter.plugin.bmap.platform.view.*
import java.io.Serializable


fun initBMapViewOptions(createParams: Map<String, *>): BaiduMapOptions {
    Log.d("BMapUtils", "initBMapViewOptions:$createParams")
    val baiduMapOptions = BaiduMapOptions()
    val compassEnabled = createParams.getOrElse("compassEnabled", {true})
    val logoPosition = createParams.getOrElse("logoPosition", { LogoPosition.logoPostionleftBottom.name})
    val mapType = createParams.getOrElse("mapType", { BaiduMap.MAP_TYPE_NORMAL})
    val overlookingGesturesEnabled = createParams.getOrElse("overlookingGesturesEnabled", {true})
    val rotateGesturesEnabled = createParams.getOrElse("rotateGesturesEnabled", {true})
    val scaleControlEnabled = createParams.getOrElse("scaleControlEnabled", {true})
    val scrollGesturesEnabled = createParams.getOrElse("scrollGesturesEnabled", {true})
    val zoomControlsEnabled = createParams.getOrElse("zoomControlsEnabled", {true})
    val zoomGesturesEnabled = createParams.getOrElse("zoomGesturesEnabled", {true})
    val mapStatus = createParams.getOrElse("mapStatus", { hashMapOf<String, Any>()}) as Map<String, Any>
    val overlook = mapStatus.getOrElse("overlook", { DEFAULT_MAPSTATUS_OVERLOOK })
    val rotate = mapStatus.getOrElse("rotate", { DEFAULT_MAPSTATUS_ROTATE })
    val zoom = mapStatus.getOrElse("zoom", { DEFAULT_MAPSTATUS_ZOOM })
    val target = mapStatus.getOrElse("target", { hashMapOf<String, Any>()}) as Map<String, Any>
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

fun parseMarkerOptionsList(optionList: List<Map<String, Any>>): List<MarkerOptions>{
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
        //val infoWindowOptions = it["infoWindow"] as HashMap<*, *> ?
        //val infoWindow = infoWindowOptions?.let { options -> parseInfoWindow(options) }
        val latitude = position["latitude"] as Double
        val longitude = position["longitude"] as Double
        val latLng = LatLng(latitude, longitude)
        val markerOptions = MarkerOptions()
        val bundle = Bundle()
        for ((key, value) in extraInfo.entries){
            bundle.putSerializable(key as String, value as Serializable)
        }
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
//            infoWindow?.let {
//                markerOptions.infoWindow(infoWindow)
//            }
        }
        markerOptionsList.add(markerOptions)
    }
    return markerOptionsList
}

fun parseTextOptionsList(optionList: List<Map<String, Any?>>): List<TextOptions> {
    val textOptionsList = mutableListOf<TextOptions>()
    optionList.map {
        val alignX = it["alignX"] as Int
        val alignY = it["alignY"] as Int
        val position = it["position"] as Map<String, Double>
        val text = it["text"] as String
        val visible = it["visible"] as Boolean
        val bgColor = it["bgColor"] as String
        val fontColor = it["fontColor"] as String
        val fontSize = it["fontSize"] as Int
        val rotate = it["rotate"] as Double
        val extraInfo = it["extraInfo"] as Map<String, Any>
        val zIndex = it["zIndex"] as Int
        val latitude = position["latitude"]
        val longitude = position["longitude"]
        val latLng = LatLng(latitude!!, longitude!!)
        val textOptions = TextOptions()
        val bundle = Bundle()
        for ((key, value) in extraInfo.entries){
            bundle.putSerializable(key, value as Serializable)
        }
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
    val position = infoWindowOptions["position"] as HashMap<*, *>
    val latitude = position["latitude"] as Double
    val longitude = position["longitude"] as Double
    val info = infoWindowOptions["info"] as String
    val yOffset = infoWindowOptions["yOffset"] as Int
    val textColor = infoWindowOptions["textColor"] as String
    val textSize = infoWindowOptions["textSize"] as Double
    val tag = infoWindowOptions["tag"] as String?
    val latLng = LatLng(latitude, longitude)
    val mInflater = FlutterBMapPlugin.registrar.activity().layoutInflater
    val infoWindowView = mInflater.inflate(R.layout.info_window, null, false) as TextView
    infoWindowView.apply {
        setTextColor(textColor.toLong().toInt())
        setTextSize(textSize.toFloat())
        text = info
    }
    val infoWindow = InfoWindow(infoWindowView, latLng, yOffset)
    tag?.let {
        infoWindow.tag = it
    }
    return infoWindow
}

fun parseTexturePolyline(texturePolylineOptions: Map<*, *>): PolylineOptions {
    var points = texturePolylineOptions["points"] as List<*>
    var customTextureList = texturePolylineOptions["customTextureList"] as List<String>
    var textureIndex = texturePolylineOptions["textureIndex"] as List<Int>
    var width = texturePolylineOptions["width"] as Int
    var dottedLine = texturePolylineOptions["dottedLine"] as Boolean
    var latLngList = points.map {
        deserializeLatLng(it as Map<*, *>)
    }.toList()
    var textureList = customTextureList.map {
        BMapViewAssets.getBitmapDescriptor(it)
    }.toList()
    var polylineOptions = PolylineOptions()

    polylineOptions.apply {
        width(width)
        dottedLine(dottedLine)
        points(latLngList)
        customTextureList(textureList)
        textureIndex(textureIndex)
    }
    return polylineOptions

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