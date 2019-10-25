//
//  Misc.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-22.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "Misc.h"

@implementation Misc

+ (NSString *)toAMapErrorDesc:(NSInteger)errorCode {
    switch (errorCode) {
        case 1000 :
            return @"请求正常";
        case 1001 :
            return @"开发者签名未通过";
        case 1002 :
            return @"用户Key不正确或过期";
        case 1003 :
            return @"没有权限使用相应的接口";
        case 1008 :
            return @"MD5安全码未通过验证";
        case 1009 :
            return @"请求Key与绑定平台不符";
        case 1012 :
            return @"权限不足，服务请求被拒绝";
        case 1013 :
            return @"该Key被删除";
        case 1100 :
            return @"引擎服务响应错误";
        case 1101 :
            return @"引擎返回数据异常";
        case 1102 :
            return @"高德服务端请求链接超时";
        case 1103 :
            return @"读取服务结果返回超时";
        case 1200 :
            return @"请求参数非法";
        case 1201 :
            return @"请求条件中，缺少必填参数";
        case 1202 :
            return @"服务请求协议非法";
        case 1203 :
            return @"服务端未知错误";
        case 1800 :
            return @"服务端新增错误";
        case 1801 :
            return @"协议解析错误";
        case 1802 :
            return @"socket 连接超时 - SocketTimeoutException";
        case 1803 :
            return @"url异常 - MalformedURLException";
        case 1804 :
            return @"未知主机 - UnKnowHostException";
        case 1806 :
            return @"http或socket连接失败 - ConnectionException";
        case 1900 :
            return @"未知错误";
        case 1901 :
            return @"参数无效";
        case 1902 :
            return @"IO 操作异常 - IOException";
        case 1903 :
            return @"空指针异常 - NullPointException";
        case 2000 :
            return @"Tableid格式不正确";
        case 2001 :
            return @"数据ID不存在";
        case 2002 :
            return @"云检索服务器维护中";
        case 2003 :
            return @"Key对应的tableID不存在";
        case 2100 :
            return @"找不到对应的userid信息";
        case 2101 :
            return @"App Key未开通“附近”功能";
        case 2200 :
            return @"在开启自动上传功能的同时对表进行清除或者开启单点上传的功能";
        case 2201 :
            return @"USERID非法";
        case 2202 :
            return @"NearbyInfo对象为空";
        case 2203 :
            return @"两次单次上传的间隔低于7秒";
        case 2204 :
            return @"Point为空，或与前次上传的相同";
        case 3000 :
            return @"规划点（包括起点、终点、途经点）不在中国陆地范围内";
        case 3001 :
            return @"规划点（包括起点、终点、途经点）附近搜不到路";
        case 3002 :
            return @"路线计算失败，通常是由于道路连通关系导致";
        case 3003 :
            return @"步行算路起点、终点距离过长导致算路失败。";
        case 4000 :
            return @"短串分享认证失败";
        case 4001 :
            return @"短串请求失败";
        default:
            return @"无法识别的代码";
    }
}


@end
