//
//  RADBTool.h
//  RedArtifact
//
//  Created by xiaoma on 16/9/22.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKKeyValueStore.h"

@interface RADBTool : NSObject

/*
 * 获取表中object的数据
 * objectID
 * tableName
 */
+ (YTKKeyValueItem *)getObjectItemDataWithObjectID:(NSString *)objectID withTableName:(NSString *)tableName;

/*
 * 更新表中数据
 */
+ (void)putObject:(id)object withId:(NSString *)objectId intoTable:(NSString *)tableName withComplete:(RAErrorCodeBlock)complete;

/*
 * 判断是否过期
 * objectId
 * expirydate 有效期（单位：h）
 */
+ (BOOL)isInvalidWithObjectID:(YTKKeyValueItem *)object withExpirydate:(NSInteger)expirydate;

/*
 * 删除指定key的数据
 */
+ (void)deleteObjectById:(NSString *)objectId fromTable:(NSString *)tableName withComplete:(RAErrorCodeBlock)complete;

/*
 * 清除数据表中所有数据
 */
+ (void)clearTable:(NSArray *)tableNames withComplete:(RAErrorCodeBlock)complete;


/* 时间段
 * 缓存是否销毁判断
 * expirydate 有效期（单位：h）
 */
+ (BOOL)isDestroyCahcheWithBuildTime:(NSInteger)buildtime andWithExpirydate:(NSInteger)expirydate;

/* 时间点
 * 是否到截止时间
 * enddate 截止时间戳（单位：秒）
 */
+ (BOOL)isArrivedAtEndDate:(NSInteger)endDate;

@end
