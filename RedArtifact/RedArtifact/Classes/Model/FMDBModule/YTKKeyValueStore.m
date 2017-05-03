//
//  YTKKeyValueStore.m
//  Ape
//
//  Created by TangQiao on 12-11-6.
//  Copyright (c) 2012年 TangQiao. All rights reserved.
//

#import "YTKKeyValueStore.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabaseQueue.h"

#ifdef DEBUG
#define debugLog(...)    NSLog(__VA_ARGS__)
#define debugMethod()    NSLog(@"%s", __func__)
#define debugError()     NSLog(@"Error at %s Line:%d", __func__, __LINE__)
#else
#define debugLog(...)
#define debugMethod()
#define debugError()
#endif

#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@implementation YTKKeyValueItem

- (NSString *)description {
    return [NSString stringWithFormat:@"id=%@, value=%@, timeStamp=%@", _itemId, _itemObject, _createdTime];
}

@end

@interface YTKKeyValueStore()

@property (strong, nonatomic) FMDatabaseQueue * dbQueue;

@end

@implementation YTKKeyValueStore

static NSString *const DEFAULT_DB_NAME = @"database.sqlite";

static NSString *const CREATE_TABLE_SQL =
@"CREATE TABLE IF NOT EXISTS %@ ( \
id TEXT NOT NULL, \
json TEXT NOT NULL, \
createdTime TEXT NOT NULL, \
PRIMARY KEY(id)) \
";

static NSString *const UPDATE_ITEM_SQL = @"REPLACE INTO %@ (id, json, createdTime) values (?, ?, ?)";

static NSString *const QUERY_ITEM_SQL = @"SELECT json, createdTime from %@ where id = ? Limit 1";

static NSString *const SELECT_ALL_SQL = @"SELECT * from %@";

static NSString *const COUNT_ALL_SQL = @"SELECT count(*) as num from %@";

static NSString *const CLEAR_ALL_SQL = @"DELETE from %@";

static NSString *const DELETE_ITEM_SQL = @"DELETE from %@ where id = ?";

static NSString *const DELETE_ITEMS_SQL = @"DELETE from %@ where id in ( %@ )";

static NSString *const DELETE_ITEMS_WITH_PREFIX_SQL = @"DELETE from %@ where id like ? ";

+ (BOOL)checkTableName:(NSString *)tableName {
    if (tableName == nil || tableName.length == 0 || [tableName rangeOfString:@" "].location != NSNotFound) {
        debugLog(@"ERROR, table name: %@ format error.", tableName);
        return NO;
    }
    return YES;
}

- (id)init {
    return [self initDBWithName:DEFAULT_DB_NAME];
}

/*
 * 打开名为dbName的数据库，如果该文件不存在，则创新一个新的
 */
- (id)initDBWithName:(NSString *)dbName {
    self = [super init];
    if (self) {
        NSString * dbPath = [PATH_OF_DOCUMENT stringByAppendingPathComponent:dbName];
        debugLog(@"dbPath = %@", dbPath);
        if (_dbQueue) {
            [self close];
        }
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    return self;
}

/*
 * 打开路径为dbPath的数据库，如果该文件不存在，则创新一个新的
 */
- (id)initWithDBWithPath:(NSString *)dbPath {
    self = [super init];
    if (self) {
        debugLog(@"dbPath = %@", dbPath);
        if (_dbQueue) {
            [self close];
        }
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    return self;
}

/*
 * 创建名为tableName的表，如果已存在，则忽略该操作
 */
- (void)createTableWithName:(NSString *)tableName withComplete:(RAErrorCodeBlock)complete {
    if ([YTKKeyValueStore checkTableName:tableName] == NO) {
        return;
    }
    NSString * sql = [NSString stringWithFormat:CREATE_TABLE_SQL, tableName];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql];
    }];
    RAError *error = nil;
    if (!result) {
        error = [[RAError alloc] initWithDescription:[NSString stringWithFormat:@"ERROR, failed to create table: %@", tableName] code:RAErrorDBTAbleCreateFail errorDetail:nil];
    }
    
    complete(error);
}

/*
 * 检查名为tableName的表是否存在
 */
- (BOOL)isTableExists:(NSString *)tableName{
    if ([YTKKeyValueStore checkTableName:tableName] == NO) {
        return NO;
    }
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db tableExists:tableName];
    }];
    if (!result) {
        debugLog(@"ERROR, table: %@ not exists in current DB", tableName);
    }
    return result;
}

/*
 * 清除数据表中所有数据
 */
- (void)clearTable:(NSString *)tableName withComplete:(RAErrorCodeBlock)complete {
    if ([YTKKeyValueStore checkTableName:tableName] == NO) {
        return;
    }
    NSString * sql = [NSString stringWithFormat:CLEAR_ALL_SQL, tableName];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql];
    }];
    RAError *error = nil;
    if (!result) {
        error = [[RAError alloc] initWithDescription:[NSString stringWithFormat:@"ERROR, failed to clear table: %@", tableName] code:RAErrorDBTAbleClearFail errorDetail:nil];
    }
    complete(error);
}

- (void)putObject:(id)object withId:(NSString *)objectId intoTable:(NSString *)tableName withComplete:(RAErrorCodeBlock)complete {
    
    
    if ([YTKKeyValueStore checkTableName:tableName] == NO) {
        return;
    }
    NSError * error;
    NSData * data = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
    RAError *raerror = nil;
    if (error) {
        raerror = [[RAError alloc] initWithDescription:@"ERROR, faild to get json data" code:AErrorDBJsonDataError errorDetail:nil];
        
        return;
    }
    NSString * jsonString = [[NSString alloc] initWithData:data encoding:(NSUTF8StringEncoding)];
    NSDate * createdTime = [NSDate date];
    NSString * sql = [NSString stringWithFormat:UPDATE_ITEM_SQL, tableName];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql, objectId, jsonString, createdTime];
    }];
    if (!result) {
        raerror = [[RAError alloc] initWithDescription:[NSString stringWithFormat:@"ERROR, failed to insert/replace into table: %@", tableName] code:AErrorDBPutObjectFail errorDetail:nil];
    }
    complete(raerror);
}

- (void)putString:(NSString *)string withId:(NSString *)stringId intoTable:(NSString *)tableName withComplete:(RAErrorCodeBlock)complete {
    if (string == nil) {
        debugLog(@"error, string is nil");
        return;
    }
    [self putObject:@[string] withId:stringId intoTable:tableName withComplete:^(RAError *error) {
        complete(error);
    }];
}

/*
 * 获得指定key的数据
 */

- (id)getObjectById:(NSString *)objectId fromTable:(NSString *)tableName {
    
    YTKKeyValueItem * item = [self getYTKKeyValueItemById:objectId fromTable:tableName];
    if (item) {
        return item.itemObject;
    } else {
        return nil;
    }
}

- (YTKKeyValueItem *)getYTKKeyValueItemById:(NSString *)objectId fromTable:(NSString *)tableName {
    if ([YTKKeyValueStore checkTableName:tableName] == NO) {
        return nil;
    }
    NSString * sql = [NSString stringWithFormat:QUERY_ITEM_SQL, tableName];
    __block NSString * json = nil;
    __block NSDate * createdTime = nil;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:sql, objectId];
        if ([rs next]) {
            json = [rs stringForColumn:@"json"];
            createdTime = [rs dateForColumn:@"createdTime"];
        }
        [rs close];
    }];
    if (json) {
        NSError * error;
        id result = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                                    options:(NSJSONReadingAllowFragments) error:&error];
        if (error) {
            debugLog(@"ERROR, faild to prase to json");
            return nil;
        }
        YTKKeyValueItem * item = [[YTKKeyValueItem alloc] init];
        item.itemId = objectId;
        item.itemObject = result;
        item.createdTime = createdTime;
        return item;
    } else {
        return nil;
    }
}

- (NSString *)getStringById:(NSString *)stringId fromTable:(NSString *)tableName {
    NSArray * array = [self getObjectById:stringId fromTable:tableName];
    if (array && [array isKindOfClass:[NSArray class]]) {
        return array[0];
    }
    return nil;
}

/*
 * 获得numberId的数据
 */
- (NSNumber *)getNumberById:(NSString *)numberId fromTable:(NSString *)tableName {
    NSArray * array = [self getObjectById:numberId fromTable:tableName];
    if (array && [array isKindOfClass:[NSArray class]]) {
        return array[0];
    }
    return nil;
}

/*
 * 获得所有数据
 */
- (NSArray *)getAllItemsFromTable:(NSString *)tableName {
    if ([YTKKeyValueStore checkTableName:tableName] == NO) {
        return nil;
    }
    NSString * sql = [NSString stringWithFormat:SELECT_ALL_SQL, tableName];
    __block NSMutableArray * result = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            YTKKeyValueItem * item = [[YTKKeyValueItem alloc] init];
            item.itemId = [rs stringForColumn:@"id"];
            item.itemObject = [rs stringForColumn:@"json"];
            item.createdTime = [rs dateForColumn:@"createdTime"];
            [result addObject:item];
        }
        [rs close];
    }];
    // parse json string to object
    NSError * error;
    for (YTKKeyValueItem * item in result) {
        error = nil;
        id object = [NSJSONSerialization JSONObjectWithData:[item.itemObject dataUsingEncoding:NSUTF8StringEncoding]
                                                    options:(NSJSONReadingAllowFragments) error:&error];
        if (error) {
            debugLog(@"ERROR, faild to prase to json.");
        } else {
            item.itemObject = object;
        }
    }
    return result;
}

- (NSUInteger)getCountFromTable:(NSString *)tableName
{
    if ([YTKKeyValueStore checkTableName:tableName] == NO) {
        return 0;
    }
    NSString * sql = [NSString stringWithFormat:COUNT_ALL_SQL, tableName];
    __block NSInteger num = 0;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:sql];
        if ([rs next]) {
            num = [rs unsignedLongLongIntForColumn:@"num"];
        }
        [rs close];
    }];
    return num;
}

/*
 * 删除指定key的数据
 */
- (void)deleteObjectById:(NSString *)objectId fromTable:(NSString *)tableName withComplete:(RAErrorCodeBlock)complete {
    if ([YTKKeyValueStore checkTableName:tableName] == NO) {
        return;
    }
    NSString * sql = [NSString stringWithFormat:DELETE_ITEM_SQL, tableName];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql, objectId];
    }];
    RAError *error = nil;
    if (!result) {
        error = [[RAError alloc] initWithDescription:[NSString stringWithFormat:@"ERROR, failed to delete item from table: %@", tableName] code:AErrorDBDeleteFail errorDetail:nil];
    }
    complete(error);
}

/*
 * 批量删除一组key数组的数据
 */
- (void)deleteObjectsByIdArray:(NSArray *)objectIdArray fromTable:(NSString *)tableName withComplete:(RAErrorCodeBlock)complete {
    if ([YTKKeyValueStore checkTableName:tableName] == NO) {
        return;
    }
    NSMutableString *stringBuilder = [NSMutableString string];
    for (id objectId in objectIdArray) {
        NSString *item = [NSString stringWithFormat:@" '%@' ", objectId];
        if (stringBuilder.length == 0) {
            [stringBuilder appendString:item];
        } else {
            [stringBuilder appendString:@","];
            [stringBuilder appendString:item];
        }
    }
    NSString *sql = [NSString stringWithFormat:DELETE_ITEMS_SQL, tableName, stringBuilder];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql];
    }];
    RAError *error = nil;
    if (!result) {
        error = [[RAError alloc] initWithDescription:[NSString stringWithFormat:@"ERROR, failed to delete items by ids from table: %@", tableName] code:AErrorDBDeleteFail errorDetail:nil];
    }
    complete(error);
}

/*
 * 批量删除所有带指定前缀的数据
 */
- (void)deleteObjectsByIdPrefix:(NSString *)objectIdPrefix fromTable:(NSString *)tableName withComplete:(RAErrorCodeBlock)complete {
    if ([YTKKeyValueStore checkTableName:tableName] == NO) {
        return;
    }
    NSString *sql = [NSString stringWithFormat:DELETE_ITEMS_WITH_PREFIX_SQL, tableName];
    NSString *prefixArgument = [NSString stringWithFormat:@"%@%%", objectIdPrefix];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql, prefixArgument];
    }];
    RAError *error = nil;
    if (!result) {
        error = [[RAError alloc] initWithDescription:[NSString stringWithFormat:@"ERROR, failed to delete items by id prefix from table: %@", tableName] code:AErrorDBDeleteFail errorDetail:nil];
    }
    complete(error);
}

- (void)close {
    [_dbQueue close];
    _dbQueue = nil;
}

@end
