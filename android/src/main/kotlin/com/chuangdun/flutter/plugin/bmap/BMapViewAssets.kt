package com.chuangdun.flutter.plugin.bmap

import android.graphics.BitmapFactory
import com.baidu.mapapi.map.BitmapDescriptor
import com.baidu.mapapi.map.BitmapDescriptorFactory
import com.chuangdun.flutter.plugin.bmap.FlutterBMapPlugin.Companion.registrar

object BMapViewAssets {
    private val assetManager = registrar.context().assets
    private val bitmapDescriptors = mutableMapOf<String, BitmapDescriptor> ()

    fun getBitmapDescriptor(asset: String): BitmapDescriptor{
        if (bitmapDescriptors[asset] != null){
            return bitmapDescriptors[asset]!!
        }
        val assetFileDescriptor = assetManager.openFd(registrar.lookupKeyForAsset(asset))
        val bitmapDescriptor = BitmapDescriptorFactory.fromBitmap(BitmapFactory.decodeStream(
                assetFileDescriptor.createInputStream()
        ))
        bitmapDescriptors[asset] = bitmapDescriptor
        return bitmapDescriptor
    }
}