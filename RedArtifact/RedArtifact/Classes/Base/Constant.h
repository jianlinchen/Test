//
//  Constant.h
//  Wei_Shop
//
//  Created by Geniune on 15/11/2.
//  Copyright © 2015年 cjl. All rights reserved.
//

//app_id
#define APPID           @"d6423624d4248404550712141315f49b"
//APP SECRET KEY
#define APPSECRETKEY    @"df9458272715538a23c0f45dafbadf2c"

//屏幕宽度
#define UIScreenWidth CGRectGetWidth([[UIScreen mainScreen] bounds])
//屏幕高度
#define UIScreenHeight CGRectGetHeight([[UIScreen mainScreen] bounds])
//主色调
#define MAINCOLOR 0xdddddd
//字体转换
#define font(_font_) [UIFont systemFontOfSize:_font_]
//屏幕尺寸转换
#define RateWidth [AppDelegate appDelegate].screenRateWidth
#define RateHeight [AppDelegate appDelegate].screenRateHeight



#ifndef Constant_h
#define Constant_h

#endif /* Constant_h */

//#define OurWebUrl       @"https://wmw.wmwbeautysalon.com/agreement.html"
#define OurWebUrl       @"http://wap.wmwbeautysalon.com/agreement.html"

#define ACCESSTOKEN    @"ACCESS-TOKEN"

/**
 *  使用16位表达
 */
#define RGBHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//#define KScreenWidth [UIScreen mainScreen].bounds.size.width

#define HKRGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0];
#define HKGlobalColor HKRGBColor(223,223,223)


#define MAIN_COLOR ([UIColor colorWithRed:236.0/255 green:112.0/255 blue:50.0/255 alpha:1])
#define MAIN_COLOR_2 ([UIColor colorWithRed:162.0/255 green:137.0/255 blue:86.0/255 alpha:1])

#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)

//iOS系统版本
#define iOS_V   [[[UIDevice currentDevice] systemVersion] floatValue]

#define iOSv8   (iOS_V >= 8.0)
#define iOSv7   (iOS_V >= 7.0 && iOS_V < 8.0)
#define iOSo7   iOS_V >= 7.0

#define UUID    [[UIDevice currentDevice].identifierForVendor UUIDString]

#define Version [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define StrFromObj(objValue)     [NSString stringWithFormat: @"%@", objValue]

