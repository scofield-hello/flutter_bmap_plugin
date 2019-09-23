package com.chuangdun.flutter.plugin.bmap

import com.baidu.mapapi.model.LatLng
import com.baidu.mapapi.utils.AreaUtil
import com.baidu.mapapi.utils.CoordinateConverter
import com.baidu.mapapi.utils.DistanceUtil
import com.baidu.mapapi.utils.SpatialRelationUtil
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

object BMapApiUtilsHandler : MethodChannel.MethodCallHandler {
    private const val METHOD_CONVERT = "convert"
    private const val METHOD_CONVERT_LIST = "convertList"
    private const val METHOD_GET_DISTANCE = "getDistance"
    private const val METHOD_CALCULATE_AREA = "calculateArea"
    private const val METHOD_GET_NEAREST_POINT_FROM_LINE = "getNearestPointFromLine"
    private const val METHOD_IS_CIRCLE_CONTAINS_POINT = "isCircleContainsPoint"
    private const val METHOD_IS_POLYGON_CONTAINS_POINT = "isPolygonContainsPoint"

    private fun convert(coordType: CoordinateConverter.CoordType, srcCoord: LatLng): LatLng {
        val converter = CoordinateConverter().from(coordType)
        return converter.coord(srcCoord).convert()
    }

    private fun convertList(coordType: CoordinateConverter.CoordType, srcCoordList: List<LatLng>): List<LatLng> {
        val converter = CoordinateConverter().from(coordType)
        return srcCoordList.map { converter.coord(it).convert() }
    }

    private fun getDistance(from: LatLng, to: LatLng): Double {
        return DistanceUtil.getDistance(from, to)
    }

    /**
     * 计算地图上矩形区域的面积，单位平方米.
     */
    private fun calculateArea(northeast: LatLng, southwest: LatLng): Double {
        return AreaUtil.calculateArea(northeast, southwest)
    }

    /**
     * 返回某点距线上最近的点.
     */
    private fun getNearestPointFromLine(points: List<LatLng>, point: LatLng): LatLng {
        return SpatialRelationUtil.getNearestPointFromLine(points, point)
    }

    /**
     * 判断圆形是否包含传入的经纬度点.
     */
    private fun isCircleContainsPoint(center: LatLng, radius: Int, point: LatLng): Boolean {
        return SpatialRelationUtil.isCircleContainsPoint(center, radius, point)
    }

    /**
     * 返回一个点是否在一个多边形区域内.
     */
    private fun isPolygonContainsPoint(points: List<LatLng>, point: LatLng): Boolean {
        return SpatialRelationUtil.isPolygonContainsPoint(points, point)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            METHOD_CONVERT -> {
                val coordType = call.argument<String>("coordType")!!
                val srcCoord = call.argument<Map<*, *>>("srcCoord")!!
                val latLng = convert(
                        CoordinateConverter.CoordType.valueOf(coordType),
                        deserializeLatLng(srcCoord))
                result.success(serializeLatLng(latLng))
            }
            METHOD_CONVERT_LIST -> {
                val coordType = call.argument<String>("coordType")!!
                val srcCoordList = call.argument<List<Map<*, *>>>("srcCoordList")!!
                val srcList = srcCoordList.map { deserializeLatLng(it) }
                val destList = convertList(
                        CoordinateConverter.CoordType.valueOf(coordType),
                        srcList).map { serializeLatLng(it) }
                result.success(destList)
            }
            METHOD_GET_DISTANCE -> {
                val from = call.argument<Map<*, *>>("from")!!
                val to = call.argument<Map<*, *>>("to")!!
                result.success(getDistance(deserializeLatLng(from), deserializeLatLng(to)))
            }
            METHOD_CALCULATE_AREA -> {
                val northeast = call.argument<Map<*, *>>("northeast")!!
                val southwest = call.argument<Map<*, *>>("southwest")!!
                result.success(calculateArea(deserializeLatLng(northeast), deserializeLatLng(southwest)))
            }
            METHOD_GET_NEAREST_POINT_FROM_LINE -> {
                val points = call.argument<List<Map<*, *>>>("points")!!
                val point = call.argument<Map<*, *>>("point")!!
                val srcPoints = points.map { deserializeLatLng(it) }
                val srcPoint = deserializeLatLng(point)
                val latLng = getNearestPointFromLine(srcPoints, srcPoint)
                result.success(serializeLatLng(latLng))
            }
            METHOD_IS_CIRCLE_CONTAINS_POINT -> {
                val center = call.argument<Map<*, *>>("center")!!
                val radius = call.argument<Int>("radius")!!
                val point = call.argument<Map<*, *>>("point")!!
                val srcCenter = deserializeLatLng(center)
                val srcPoint = deserializeLatLng(point)
                val contains = isCircleContainsPoint(srcCenter, radius, srcPoint)
                result.success(contains)
            }
            METHOD_IS_POLYGON_CONTAINS_POINT -> {
                val points = call.argument<List<Map<*, *>>>("points")!!
                val point = call.argument<Map<*, *>>("point")!!
                val srcPoints = points.map { deserializeLatLng(it) }
                val srcPoint = deserializeLatLng(point)
                val contains = isPolygonContainsPoint(srcPoints, srcPoint)
                result.success(contains)
            }
            else -> result.notImplemented()
        }
    }
}