package com.chuangdun.flutter.plugin.bmap

import android.Manifest
import android.app.Activity
import android.content.pm.PackageManager
import android.util.Log
import android.widget.Toast
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.baidu.location.BDAbstractLocationListener
import com.baidu.location.BDLocation
import com.baidu.location.LocationClient
import com.baidu.location.LocationClientOption
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import java.lang.ref.WeakReference

private const val REQUEST_PERMISSIONS = 1
private const val METHOD_IS_START = "isStart"
private const val METHOD_START_LOCATION = "startLocation"
private const val METHOD_REQUEST_LOCATION = "requestLocation"
private const val METHOD_STOP_LOCATION = "stopLocation"
private const val EVENT_ON_RECEIVE_LOCATION = 0

/**
 * 定位
 */
class LocationHandler(activity: Activity) : MethodChannel.MethodCallHandler,
        EventChannel.StreamHandler,
        PluginRegistry.RequestPermissionsResultListener {
    private val tag = this.javaClass.simpleName
    private val activityRef = WeakReference<Activity>(activity)

    private val permissions = arrayOf(
            Manifest.permission.ACCESS_COARSE_LOCATION,
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.READ_EXTERNAL_STORAGE,
            Manifest.permission.WRITE_EXTERNAL_STORAGE)

    private val locationClient = LocationClient(activity.applicationContext)
    private var events: EventChannel.EventSink? = null
    private lateinit var listener: BDAbstractLocationListener
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (!checkPermissions()) {
            requestPermissions()
            result.error("PERMISSION_DENIED", "请先授予应用必要的权限.", null)
            return
        }
        when (call.method) {
            METHOD_IS_START -> isStart(result)
            METHOD_START_LOCATION -> startLocation(call.arguments as Map<*, *>, result)
            METHOD_REQUEST_LOCATION -> requestLocation(result)
            METHOD_STOP_LOCATION -> stopLocation(result)
            else -> result.notImplemented()
        }
    }

    private fun checkPermissions(): Boolean {
        var granted = true
        val activity = activityRef.get()
        for (permission in permissions) {
            granted = granted && ContextCompat.checkSelfPermission(activity!!, permission) == PackageManager.PERMISSION_GRANTED
        }
        return granted
    }

    private fun requestPermissions() {
        val activity = activityRef.get()
        ActivityCompat.requestPermissions(activity!!,
                permissions, REQUEST_PERMISSIONS)
    }

    private fun initLocationOptions(options: Map<*, *>): LocationClientOption {
        Log.d(tag, "initLocationOptions:$options")
        val locationOption = LocationClientOption()
        locationOption.coorType = options["coorType"] as String
        locationOption.locationMode = LocationClientOption
                .LocationMode.valueOf(options["locationMode"] as String)
        locationOption.setIsNeedAddress(options["isNeedAddress"] as Boolean)
        locationOption.openGps = options["openGps"] as Boolean
        locationOption.scanSpan = options["scanSpan"] as Int
        locationOption.timeOut = options["timeOut"] as Int
        locationOption.prodName = options["prodName"] as String
        locationOption.isIgnoreCacheException = options["isIgnoreCacheException"] as Boolean
        locationOption.isIgnoreKillProcess = options["isIgnoreKillProcess"] as Boolean
        locationOption.enableSimulateGps = options["enableSimulateGps"] as Boolean
        locationOption.mIsNeedDeviceDirect = options["isNeedDeviceDirect"] as Boolean
        locationOption.isNeedAltitude = options["isNeedAltitude"] as Boolean
        locationOption.setIsNeedLocationDescribe(options["isNeedLocationDescribe"] as Boolean)
        locationOption.setIsNeedLocationPoiList(options["isNeedLocationPoiList"] as Boolean)
        locationOption.isLocationNotify = options["isLocationNotify"] as Boolean
        val isOpenAutoNotifyMode = options["isOpenAutoNotifyMode"] as Boolean
        if (isOpenAutoNotifyMode) {
            locationOption.setOpenAutoNotifyMode(
                    options["autoNotifyMinTimeInterval"] as Int,
                    options["autoNotifyMinDistance"] as Int,
                    options["autoNotifyLocSensitivity"] as Int)
        }
        locationOption.isNeedNewVersionRgc = options["isNeedNewVersionRgc"] as Boolean
        return locationOption
    }

    private fun isStart(result: MethodChannel.Result) {
        result.success(locationClient.isStarted)
    }

    private fun startLocation(options: Map<*, *>, result: MethodChannel.Result) {
        Log.i(tag, "启动定位SDK...")
        if (locationClient.isStarted) {
            Log.w(tag, "收到重复启动定位SDK请求.")
            result.error("LOCATION_CLIENT", "重复启动定位.", null)
            return
        } else {
            listener = PluginLocationListener()
            locationClient.locOption = initLocationOptions(options)
            locationClient.registerLocationListener(listener)
            locationClient.start()
            Log.d(tag, "定位SDK已启动.")
            result.success(null)
        }
    }

    private fun requestLocation(result: MethodChannel.Result) {
        Log.i(tag, "请求单次定位...")
        if (locationClient.isStarted) {
            locationClient.requestLocation()
            result.success(null)
        } else {
            Log.w(tag, "定位SDK未启动.")
            result.error("LOCATION_CLIENT", "定位SDK未启动", null)
        }
    }

    private fun stopLocation(result: MethodChannel.Result) {
        Log.i(tag, "关闭定位SDK...")
        if (locationClient.isStarted) {
            locationClient.unRegisterLocationListener(listener)
            locationClient.stop()
            Log.i(tag, "定位SDK已关闭.")
            result.success(null)
        } else {
            Log.w(tag, "收到重复关闭定位SDK请求.")
            result.error("LOCATION_CLIENT", "重复关闭定位.", null)
        }
    }


    override fun onRequestPermissionsResult(requestCode: Int,
                                            permissions: Array<out String>?,
                                            result: IntArray?): Boolean {
        when (requestCode) {
            REQUEST_PERMISSIONS -> {
                var grantedAll = true
                for (granted in result!!) {
                    grantedAll = grantedAll &&
                            granted == PackageManager.PERMISSION_GRANTED
                }
                if (!grantedAll) {
                    Toast.makeText(activityRef.get()!!,
                            "未授予应用必需的权限.", Toast.LENGTH_LONG).show()
                }
            }
            else -> throw NotImplementedError("暂未实现.")
        }
        return true
    }

    inner class PluginLocationListener : BDAbstractLocationListener() {
        override fun onReceiveLocation(location: BDLocation?) {
            val resultMap = mutableMapOf<String, Any?>()
            resultMap["time"] = location?.time
            resultMap["country"] = location?.country
            resultMap["countryCode"] = location?.countryCode
            resultMap["province"] = location?.province
            resultMap["radius"] = location?.radius
            resultMap["city"] = location?.city
            resultMap["cityCode"] = location?.cityCode
            resultMap["adCode"] = location?.adCode
            resultMap["addrStr"] = location?.addrStr
            /**
            val address = mutableMapOf<String, Any?>()
            address["adcode"] = location?.address?.adcode
            address["countryCode"] = location?.address?.countryCode
            address["country"] = location?.address?.country
            address["province"] = location?.address?.province
            address["cityCode"] = location?.address?.cityCode
            address["city"] = location?.address?.city
            address["district"] = location?.address?.district
            address["streetNumber"] = location?.address?.streetNumber
            address["street"] = location?.address?.street
            address["address"] = location?.address?.address
            resultMap["address"] = address
            */
            resultMap["altitude"] = location?.altitude
            resultMap["latitude"] = location?.latitude
            resultMap["longitude"] = location?.longitude
            resultMap["coorType"] = location?.coorType
            //resultMap["delayTime"] = location?.delayTime
            resultMap["direction"] = location?.direction
            resultMap["district"] = location?.district
            resultMap["floor"] = location?.floor
            /**
            resultMap["gpsAccuracyStatus"] = location?.gpsAccuracyStatus
            resultMap["gpsCheckStatus"] = location?.gpsCheckStatus
            resultMap["indoorLocationSource"] = location?.indoorLocationSource
            resultMap["indoorLocationSurpport"] = location?.indoorLocationSurpport
            resultMap["indoorLocationSurpportBuidlingID"] = location?.indoorLocationSurpportBuidlingID
            resultMap["indoorLocationSurpportBuidlingName"] = location?.indoorLocationSurpportBuidlingName
            resultMap["indoorNetworkState"] = location?.indoorNetworkState
            */
            resultMap["buildingID"] = location?.buildingID
            resultMap["buildingName"] = location?.buildingName
            /**
            resultMap["indoorSurpportPolygon"] = location?.indoorSurpportPolygon
            resultMap["isCellChangeFlag"] = location?.isCellChangeFlag
            */
            resultMap["locType"] = location?.locType
            /**
            resultMap["locTypeDescription"] = location?.locTypeDescription
            resultMap["isInIndoorPark"] = location?.isInIndoorPark
            resultMap["isIndoorLocMode"] = location?.isIndoorLocMode
            resultMap["isNrlAvailable"] = location?.isNrlAvailable
            resultMap["isParkAvailable"] = location?.isParkAvailable
            resultMap["locationDescribe"] = location?.locationDescribe
            */
            resultMap["locationID"] = location?.locationID
            //resultMap["locationWhere"] = location?.locationWhere
            resultMap["networkLocationType"] = location?.networkLocationType
            /**
            resultMap["nrlLat"] = location?.nrlLat
            resultMap["nrlLon"] = location?.nrlLon
            resultMap["nrlResult"] = location?.nrlResult
            resultMap["roadLocString"] = location?.roadLocString
            resultMap["satelliteNumber"] = location?.satelliteNumber
            */
            resultMap["speed"] = location?.speed
            resultMap["street"] = location?.street
            resultMap["streetNumber"] = location?.streetNumber
            //location?.town
            resultMap["town"] = null 
            /**
            resultMap["userIndoorState"] = location?.userIndoorState
            resultMap["vdrJsonString"] = location?.vdrJsonString
            resultMap["descriptionContent"] = location?.describeContents()
            */
            val poiList = location?.poiList
            val serializedPoiList = mutableListOf<Map<String, *>>()
            poiList?.forEach {
                serializedPoiList.add(mapOf("id" to it.id, "name" to it.name, "rank" to it.rank))
            }
            resultMap["poiList"] = serializedPoiList
            events?.success(mapOf(
                    "event" to EVENT_ON_RECEIVE_LOCATION,
                    "data" to resultMap
            ))
        }
    }

    override fun onCancel(obj: Any?) {
        this.events = null
    }

    override fun onListen(obj: Any?, events: EventChannel.EventSink) {
        this.events = events
    }
}
