//
//  RADBTool.m
//  RedArtifact
//
//  Created by xiaoma on 16/9/22.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "RADBTool.h"

@implementation RADBTool

/*
 * 获取表中object的数据
 * objectID
 * tableName
 */
+ (YTKKeyValueItem *)getObjectItemDataWithObjectID:(NSString *)objectID withTableName:(NSString *)tableName {
    NSString *objectId = [NSString stringWithFormat:@"%@%@",objectID,[User sharedInstance].userNmae];
    if (![[AppDelegate appDelegate].fmdbStore isTableExists:tableName]) {
        [[AppDelegate appDelegate].fmdbStore createTableWithName:tableName withComplete:^(RAError *error) {
            DLog(@"创建%@表成功",tableName);
        }];
        return nil;
    } else {
        YTKKeyValueItem *item = [[YTKKeyValueItem alloc] init];
        item = [[AppDelegate appDelegate].fmdbStore getYTKKeyValueItemById:objectId fromTable:tableName];
        
        return item;
    }
}

/*
 * 更新表中数据
 */
+ (void)putObject:(id)object withId:(NSString *)objectId intoTable:(NSString *)tableName withComplete:(RAErrorCodeBlock)complete {
    NSString *objectID = [NSString stringWithFormat:@"%@%@",objectId,[User sharedInstance].userNmae];
    
    [[AppDelegate appDelegate].fmdbStore putObject:object withId:objectID intoTable:tableName withComplete:^(RAError *error) {
        if (error) {
            DLog(@"%@",error.errorDescription);
        }
    }];
}

/*
 * 判断是否过期
 * objectId
 * expirydate 有效期（单位：h）
 */
+ (BOOL)isInvalidWithObjectID:(YTKKeyValueItem *)object withExpirydate:(NSInteger)expirydate {
    if (object != nil) {
        if (expirydate >= 0) {
            if (object.createdTime) {
                //创建时间时间戳
                NSTimeInterval buildInterval = [object.createdTime timeIntervalSince1970];
                //当前时间时间戳
                NSTimeInterval currentInterval = [[NSDate date] timeIntervalSince1970];
                if (buildInterval + expirydate*3600 > currentInterval) {
                    return NO;
                } else {
                    return YES;
                }
                
            } else {
                return YES;
            }
        } else {
            return NO;
        }
    } else {
        return YES;
    }

}

/*
 * 删除指定key的数据
 */
+ (void)deleteObjectById:(NSString *)objectId fromTable:(NSString *)tableName withComplete:(RAErrorCodeBlock)complete {
    NSString *objectID = [NSString stringWithFormat:@"%@%@",objectId,[User sharedInstance].userNmae];
    [[AppDelegate appDelegate].fmdbStore deleteObjectById:objectID fromTable:tableName withComplete:^(RAError *error) {
        if (error) {
            DLog(@"%@",error.errorDescription);
        }
    }];
}

/*
 * 清除数据表中所有数据
 */
+ (void)clearTable:(NSArray *)tableNames withComplete:(RAErrorCodeBlock)complete {
    if (tableNames.count > 0) {
        for (int i = 0; i < tableNames.count; i++) {
            NSString *tableName = tableNames[i];
            [[AppDelegate appDelegate].fmdbStore clearTable:tableName withComplete:nil];
        }
    } else {
        /*
         kHomeTableName 首页
         kSuperbonusTableName 超级大红包
         kRedpacketTableName 红包
         kRedpacketRankTableName 红包排行榜
         kAdvertTableName 广告
         kSenderAdvertisementDetailTableName 发布者-获取广告信息
         kSenderAdvertisementPublishDetailTableName 发布者-获取广告发布信息
         kSenderAdvertisementBonusTableName 发布者-获取红包配置
         kRefundLogTableName 结算进度
         kBonusStatisticsTableName 到达统计
         personCacheTableName  个人中心
         */
        NSArray *tables = [NSArray arrayWithObjects:kHomeTableName,kSuperbonusTableName,kRedpacketTableName,kRedpacketRankTableName,kAdvertTableName,kSenderAdvertisementDetailTableName,kSenderAdvertisementPublishDetailTableName,kSenderAdvertisementBonusTableName,kRefundLogTableName,kBonusStatisticsTableName, personCacheTableName,nil];
        for (int i = 0; i < tables.count; i++) {
            NSString *tableName = tables[i];
            [[AppDelegate appDelegate].fmdbStore clearTable:tableName withComplete:^(RAError *error) {
                if (error) {
                    DLog(@"%@",error.errorDescription);
                }
            }];
        }
    }
}

/*
 * 缓存是否销毁判断
 * expirydate 有效期（单位：h）
 */
+ (BOOL)isDestroyCahcheWithBuildTime:(NSInteger)buildtime andWithExpirydate:(NSInteger)expirydate {
    NSInteger endTime = buildtime + expirydate*3600;
    if ([[NSDate getCurrentDateInterval] integerValue] >= endTime) {
        return YES;
    } else {
        return NO;
    }
}

/* 时间点
 * 是否到某个时间点
 * enddate 过期时间
 */
+ (BOOL)isArrivedAtEndDate:(NSInteger)endDate {
    NSInteger endTime = endDate - 60;
    if ([[NSDate getCurrentDateInterval] integerValue] >= endTime) {
        return YES;
    } else {
        return NO;
    }
}

@end
