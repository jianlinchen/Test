//
//  YTKKeyValueStore.h
//  Ape
//
//  Created by TangQiao on 12-11-6.
//  Copyright (c) 2012年 TangQiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RAError.h"
//RAErrorCode complete
typedef void (^RAErrorCodeBlock)(RAError *error);

@interface YTKKeyValueItem : NSObject

@property (strong, nonatomic) NSString *itemId;
@property (strong, nonatomic) id itemObject;
@property (strong, nonatomic) NSDate *createdTime;

@end


@interface YTKKeyValueStore : NSObject

/*
 * 打开名为dbName的数据库，如果该文件不存在，则创新一个新的
 */
- (id)initDBWithName:(NSString *)dbName;

/*
 * 打开路径为dbPath的数据库，如果该文件不存在，则创新一个新的
 */
- (id)initWithDBWithPath:(NSString *)dbPath;

/*
 * 创建名为tableName的表，如果已存在，则忽略该操作
 */
- (void)createTableWithName:(NSString *)tableName withComplete:(RAErrorCodeBlock)complete;

/*
 * 检查名为tableName的表是否存在
 */
- (BOOL)isTableExists:(NSString *)tableName;

/*
 * 清除数据表中所有数据
 */
- (void)clearTable:(NSString *)tableName withComplete:(RAErrorCodeBlock)complete;

/*
 * 关闭数据库
 */
- (void)close;

///************************ Put&Get methods *****************************************

- (void)putObject:(id)object withId:(NSString *)objectId intoTable:(NSString *)tableName withComplete:(RAErrorCodeBlock)complete;


- (void)putString:(NSString *)string withId:(NSString *)stringId intoTable:(NSString *)tableName withComplete:(RAErrorCodeBlock)complete;

/*
 * 获得指定key的数据
 */
- (id)getObjectById:(NSString *)objectId fromTable:(NSString *)tableName;

- (YTKKeyValueItem *)getYTKKeyValueItemById:(NSString *)objectId fromTable:(NSString *)tableName;

- (NSString *)getStringById:(NSString *)stringId fromTable:(NSString *)tableName;
/*
 * 获得numberId的数据
 */
- (NSNumber *)getNumberById:(NSString *)numberId fromTable:(NSString *)tableName;

/*
 * 获得所有数据
 */
- (NSArray *)getAllItemsFromTable:(NSString *)tableName;

- (NSUInteger)getCountFromTable:(NSString *)tableName;

/*
 * 删除指定key的数据
 */
- (void)deleteObjectById:(NSString *)objectId fromTable:(NSString *)tableName withComplete:(RAErrorCodeBlock)complete;

/*
 * 批量删除一组key数组的数据
 */
- (void)deleteObjectsByIdArray:(NSArray *)objectIdArray fromTable:(NSString *)tableName withComplete:(RAErrorCodeBlock)complete;

/*
 * 批量删除所有带指定前缀的数据
 */
- (void)deleteObjectsByIdPrefix:(NSString *)objectIdPrefix fromTable:(NSString *)tableName withComplete:(RAErrorCodeBlock)complete;


@end
