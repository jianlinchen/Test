//
//  JLSandBoxPath.h
//  RedArtifact
//
//  Created by LiLu on 16/8/16.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLSandBoxPath : NSObject
// 获取沙盒Document的文件目录
+ (NSString *)getDocumentDirectory;

// 获取沙盒Library的文件目录
+ (NSString *)getLibraryDirectory;

// 获取沙盒Library/Caches的文件目录
+ (NSString *)getCachesDirectory;

// 获取沙盒Preference的文件目录
+ (NSString *)getPreferencePanesDirectory;

// 获取沙盒tmp的文件目录
+ (NSString *)getTmpDirectory;
@end
