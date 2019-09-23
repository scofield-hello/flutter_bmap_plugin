package com.chuangdun.flutter.plugin.bmap

import android.app.Activity
import android.content.Context
import com.chuangdun.flutter.plugin.bmap.view.FlutterBMapView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.util.Preconditions
import java.lang.ref.WeakReference

class FlutterBMapViewFactory(activity: Activity, private val messenger: BinaryMessenger)
    : PlatformViewFactory(StandardMessageCodec.INSTANCE){

    private val activityRef: WeakReference<Activity> = WeakReference(activity)

    override fun create(context: Context?, id: Int, createParams: Any?): PlatformView {
        Preconditions.checkNotNull(context)
        Preconditions.checkNotNull(activityRef.get())
        require((createParams == null || createParams is HashMap<*, *>)) { "地图初始化参数有误." }
        val nullableParams = createParams as Map<String, *>?
        return FlutterBMapView(activity = activityRef.get()!!,
                messenger = messenger, id = id, createParams = nullableParams)
    }

}