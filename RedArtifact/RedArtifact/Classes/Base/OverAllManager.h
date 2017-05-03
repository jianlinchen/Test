//
//  OverAllManager.h
//  RedArtifact
//
//  Created by LiLu on 16/7/25.
//  Copyright © 2016年 jianlin. All rights reserved.

//全局单例
#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "DataBaseManager.h"
#define GLOBARMANAGER [OverAllManager shareInstance]   

// 单例调用方法例子 NSString *str=[GLOBARMANAGER  NSdateToString];

#import <Foundation/Foundation.h>
@interface OverAllManager : NSObject

+ (OverAllManager *)shareInstance;


+ (void)OpenFMDataBase;
// 获取时间戳
- (NSString *)dateString;

// 字典转json
-(NSString*)dictionaryToJson:(NSMutableDictionary *)dic;

// 将NSDate按yyyy-MM-dd HH:mm:ss
- (NSString *)NSdateToString;

//获取文字高度
- (CGSize)sizeText:(NSString*)text
              font:(UIFont*)font
        limitWidth:(float)width;

// 获取文字宽度
- (CGSize)sizeText:(NSString*)text
              font:(UIFont*)font
       limitHeight:(float)height;

/**
 *  裁剪图片尺寸倍数
 */
-(UIImage *)scaleImage:(UIImage *)image
               toScale:(float)scaleSize;
/**
 *  压缩图片尺寸(即：重新绘制新的比例尺寸)
 */
- (UIImage*)imageWithImageSimple:(UIImage*)image
                    scaledToSize:(CGSize)newSize;

/**
 *  压缩图片清晰图（减少内存）
 */
-(NSData *)data :(UIImage *)image;

//获取版本号
-(NSString *)getverson;

/**
 *  弹出警示框
 */
+(void)alertView:(NSString *)title;
@end
