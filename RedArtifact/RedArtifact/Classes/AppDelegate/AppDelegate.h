//
//  AppDelegate.h
//  RedArtifact
//
//  Created by LiLu on 16/7/25.
//  Copyright © 2016年 jianlin. All rights reserved.
//

static NSString *weiAppid = @"wx36e34c361a0b2b3f";//微信APP第
static NSString *appKey = @"62ce0fb5cb17b3be904abbe3";//极光推送的appkey
static NSString *channel = @"Publish channel";
static NSString *umsocialkey = @"573e824567e58e2e7a0013cf";//友盟

//static BOOL isProduction = TRUE;    //false为开发环境，true为生产环境
static BOOL isProduction = FALSE;    //false为开发环境，true为生产环境

#define BaiDuAppkey @"TtGMKGDdwPuurI2s77MeBsTaGw0LDIyk"
#import <UIKit/UIKit.h>

#import "WXApi.h"
#import "CustomAlertView.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,AlertViewSureDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (assign, nonatomic) CGFloat screenRateWidth;

@property (assign, nonatomic) CGFloat screenRateHeight;

@property (strong, nonatomic) YTKKeyValueStore *fmdbStore;

+ (AppDelegate *)appDelegate;

@end

