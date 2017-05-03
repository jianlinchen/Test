//
//  Tools.h
//  RedArtifact
//
//  Created by xiaoma on 16/8/8.
//  Copyright © 2016年 jianlin. All rights reserved.
//

typedef enum {
    Adding,
    Subtracting,
    Multiplying,
    Dividing,
}calucateWay;

#import <Foundation/Foundation.h>
/** 打开其他app */
typedef void(^OpenSuccess)(BOOL message);

/** 倒计时回调 */
typedef void(^timerRuning)(NSString *tiemStr);//开始倒计时
typedef void(^timerInvalid)(BOOL invalid);//倒计时失效

/** 获取服务器时间回调 */
typedef void(^getServerTimeSuccess)(NSInteger servertime);

@interface Tools : NSObject

/*
 * 价格计算
 */
+ (NSString *)decimalNumberCalucate:(NSString *)originValue1 originValue2:(NSString *)originValue2 calucateWay:(calucateWay)calucateWay;

/*
 * 设置Navigation标题
 */
+ (NSDictionary *)getNavigationBarTitleTextAttributes;

/*
 * 打开其他app
 */
+ (void)openOtherAPPWithURL:(NSString *)appUrl withiTunesURL:(NSString *)iTunesUrl withSuccess:(OpenSuccess)success;

/*
 * 倒计时时间计算
 */
+ (NSDictionary *)timeAfterWithInterval:(NSString *)interval;

/*
 * 设置text默认字体
 */
+ (void)setTextFieldPlaceHolder:(UITextField *)textfield withTitle:(NSString *)title withColor:(NSInteger)color;

/*
 * 获取验证码倒计时功能处理
 */
+ (void)setTimerWithTimecount:(int)timercount timerRuning:(timerRuning)timerRuning tiemrInvalid:(timerInvalid)timerInvalid;

/*
 * 有accesstoken
 ＊ 获取系统配置
 */
+ (void)getServerKeyConfig;

/*
 * 没有accesstoken
 ＊ 获取系统配置
 */
+ (void)getServerKeyCommon;

/*
 * 获取服务器时间
 */
+ (void)getServerTimeSuccess:(getServerTimeSuccess)servertime;

/*
 * 拨打电话
 */
+ (void)callPhoneWithTel:(NSString *)tel;

/*
 * 打开网页
 */
+ (void)openLinkWithUrl:(NSString *)url;

/*
 * 电话号码隐私处理
 */
+ (NSString *)phoneNumberSecret:(NSString *)url;


+ (void)getPersonInfo;


@end



