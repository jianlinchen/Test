//
//  DataBaseManager.h
//  Wei_Shop
//
//  Created by Geniune on 15/11/5.
//  Copyright © 2015年 cjl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"


#define DATAMANAGER [DataBaseManager openDataBase]

@interface DataBaseManager : NSObject

//打开数据库
+ (FMDatabase *)openDataBase;

//创建数据库表
+ (void)createTables;
//插入个人信息的表格
+(void)insertPersonCacheToDB:(NSString *)telephone dataDic:(NSDictionary *)dic nowDate:(NSDate *)currentDate;
//得到个人数据
+(void)getPersonCacheToDBCompleted:(void (^)(id))success;








#pragma mark - 搜索历史记录
//搜索历史记录插入数据库
+ (void)insertSearchHistoryToDB:(NSString *)keWord;
//搜索历史记录从数据库中取出
+ (NSMutableArray *)getSearchHistoryData;


// 删除单个数据
+(void)DeleteSingleHistoryData:(NSString *)keyWord;
//删除所有搜索历史记录
+ (void)DeleteSearchHistoryData;

#pragma mark - 聊天历史记录缓存
//聊天历史记录插入
+ (void)insertIMHistoryToDB:(NSString *)messageId userId:(NSString *)userId shopId:(NSString *)shopId sendTime:(NSString *)sendTime messageType:(NSString *)type content:(NSString *)content receiveOrSend:(NSString *)RS;

//聊天历史记录取出
+ (NSArray *)getIMHistoryData:(NSString *)userId shopId:(NSString *)shopId;


#pragma mark - 未读消息缓存
//未读消息记录插入
+ (void)insertUnReadListToDB:(NSString *)senderId senderName:(NSString *)senderName senderIcon:(NSString *)senderIcon content:(NSString *)lastContent lastSendTime:(NSString *)lastSendTime;
//未读消息记录取出
+ (void)getUnReadListDataCompleted:(void (^)(id))success;
//删除与某个人的未读消息
+ (void)deleteUnReadList:(NSString *)senderId Completed:(void (^)(id))success;





#pragma mark - 搜索客户历史记录插入数据库
//查询客户，历史by  CJL

+(void)insertSearchClientToDB:(NSString *)keWord;
//搜索历史记录从数据库中取出
+ (NSMutableArray *)getSearchClientData;
//删除所有搜索历史记录
+ (void)DeleteSearchClientData;


//删除一条搜索历史记录
+ (void)DeletSingleeSearchClientData;




#pragma mark -查找 和 添加 融云客户的昵称和头像
//删除所有融云史记录
//+ (void)DeleteRongYunData;
// *插入融云客户的昵称和头像
+(void)insertRongYunToDB:(NSString *)shopID imId:(NSString *)imId imName:(NSString *)imName imIcon:(NSString *)imIcon imToken:(NSString *)imToken ;

//查找融云客户的昵称和头像
+ (NSArray *)getRongYunData:(NSString *)ShopId ;


//更新融云客户的昵称和头像
//+ (void)updateRongYunData:(NSString *)shopID imId:(NSString *)imId imName:(NSString *)imName imIcon:(NSString *)imIcon ;
//// *取出
+ (void)updateRongYunData:(NSString *)shopID imId:(NSString *)imId imName:(NSString *)imName imIcon:(NSString *)imIcon ;

+(void)deleSIngleRongYun:(NSString *)shopID imId:(NSString *)imId;
@end
