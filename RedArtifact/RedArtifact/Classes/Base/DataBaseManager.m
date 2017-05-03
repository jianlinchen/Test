//
//  DataBaseManager.m
//  Wei_Shop
//
//  Created by Geniune on 15/11/5.
//  Copyright © 2015年 cjl. All rights reserved.
//

#import "DataBaseManager.h"
#import "JLdbModel.h"

@implementation DataBaseManager




//打开数据库
+ (FMDatabase *)openDataBase{

    NSString *path = NSHomeDirectory();
    path = [path stringByAppendingPathComponent:@"Documents/data.db"];
    
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    if(db.open){
        return db;
    }else{
        [db open];
        return db;
    }
}

//创建表的集合
+ (void)createTables{
    
    [DataBaseManager createPersonCacheTable];
    
}

+(BOOL)createPersonCacheTable{
    BOOL res = [DATAMANAGER executeUpdate:@"create table if not exists PersonCache(telephone,object,date)"];
    
    if (res == NO) {
        NSLog(@"PersonCache创建失败");
    }else if(res==YES){
        NSLog(@"PersonCache创建成功");
    }
    return res;
}

//个人信息存入
+(void)insertPersonCacheToDB:(NSString *)telephone dataDic:(NSDictionary *)dic nowDate:(NSDate *)currentDate {
    BOOL flag = [DATAMANAGER executeUpdate:@"INSERT INTO PersonCache (telephone,object,date) VALUES (?,?,?)",telephone,dic,currentDate];
    if(flag){
        NSLog(@"PersonCache插入成功");
    }else{
        NSLog(@"PersonCache插入成功");
    }

    
}
//得到个人数据
+(void)getPersonCacheToDBCompleted:(void (^)(id))success{
    
    
    FMResultSet* set = [DATAMANAGER executeQuery:@"select * from PersonCache"];

    JLdbModel * model = [[JLdbModel alloc] init];
    while ([set next]){
    model.itemId =[set stringForColumnIndex:0];
    model.itemObject = [set stringForColumnIndex:1];
    model.createdTime =[set dateForColumnIndex:2];;

    }
    if(success){
        success(model);
    }
   
}

//未读消息记录取出
+ (void)getUnReadListDataCompleted:(void (^)(id))success{
    
    FMResultSet* set = [DATAMANAGER executeQuery:@"select * from UnReadList"];
    
    NSMutableArray* array = [NSMutableArray new];
    
    while ([set next]){
        
        NSMutableDictionary *dic = [NSMutableDictionary new];
        dic[@"senderId"]    = [set stringForColumnIndex:0];
        dic[@"senderName"]  = [set stringForColumnIndex:1];
        dic[@"senderIcon"]  = [set stringForColumnIndex:2];
        dic[@"lastContent"] = [set stringForColumnIndex:3];
        dic[@"lastSendTime"]= [set stringForColumnIndex:4];
        [array addObject:dic];
    }
    NSArray *sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        NSMutableDictionary *dic1 = (NSMutableDictionary *)obj1;
        NSMutableDictionary *dic2 = (NSMutableDictionary *)obj2;
        
        if ([dic1[@"lastSendTime"] compare:dic2[@"lastSendTime"]] == NSOrderedAscending) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([dic1[@"lastSendTime"] compare:dic2[@"lastSendTime"]] == NSOrderedDescending) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    if(success){
        success(sortedArray);
    }
}
//删除与某个人的未读消息
+ (void)deleteUnReadList:(NSString *)senderId Completed:(void (^)(id))success{
    
    BOOL res = [DATAMANAGER executeUpdate:@"delete from UnReadList where senderId=?",senderId];

    if (res == NO) {
        NSLog(@"UnReadList删除失败");
    }else if(res==YES){
        NSLog(@"UnReadList删除成功");
        if(success){
            success(nil);
        }
    }
}

//搜索历史数据库表
+ (BOOL)createIMHistoryTable{
    
    BOOL res = [DATAMANAGER executeUpdate:@"create table if not exists IMHistoryList(id PRIMARY KEY,userId,shopId,sendTime,type,content,RS)"];
    
    if (res == NO) {
        NSLog(@"IMHistoryList创建失败");
    }else if(res==YES){
        NSLog(@"IMHistoryList创建成功");
    }
    return res;
}

//聊天历史记录插入
+ (void)insertIMHistoryToDB:(NSString *)messageId userId:(NSString *)userId shopId:(NSString *)shopId sendTime:(NSString *)sendTime messageType:(NSString *)type content:(NSString *)content receiveOrSend:(NSString *)RS{
    
    BOOL flag = [DATAMANAGER executeUpdate:@"INSERT INTO IMHistoryList (id,userId,shopId,sendTime,type,content,RS) VALUES (?,?,?,?,?,?,?)",messageId,userId,shopId,sendTime,type,content,RS];
    if(flag){
        NSLog(@"聊天记录插入成功");
    }
}

//聊天历史记录取出
+ (NSArray *)getIMHistoryData:(NSString *)userId shopId:(NSString *)shopId{
    
    FMResultSet* set = [DATAMANAGER executeQuery:@"select * from IMHistoryList where userId=? and shopId=?",userId,shopId];
    
    NSMutableArray* array = [NSMutableArray new];
    
    while ([set next]){
        //按条取出数据，转换为Model输出
//        Message *message = [[Message alloc]init];
//        //消息id
//        message.messageId = [set stringForColumnIndex:0];
//        //用户id
//        message.msgUserId = [set stringForColumnIndex:1];
//        //商家id
//        message.shopId = [set stringForColumnIndex:2];
//        //时间戳
//        message.sendTime = [set stringForColumnIndex:3];
//        //数据类型
//        message.msgContentType = [set stringForColumnIndex:4];
//        //内容
//        message.content = [set stringForColumnIndex:5];
//        //收到/发出消息:
//        message.RSType = [set stringForColumnIndex:6];
//        message.msgUserName = @"";
//        
//        [array addObject:message];
    }
    [set close];
    
    //根据时间戳排序
    NSArray *sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        //这里的代码可以参照上面compare:默认的排序方法，也可以把自定义的方法写在这里，给对象排序
//        Message *object1 = (Message *)obj1;
//        Message *object2 = (Message *)obj2;
//        
//        if ([object1.sendTime compare:object2.sendTime] == NSOrderedAscending) {
//            return (NSComparisonResult)NSOrderedAscending;
//        }
//        if ([object1.sendTime compare:object2.sendTime] == NSOrderedDescending) {
//            return (NSComparisonResult)NSOrderedDescending;
//        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    return sortedArray;
    

}


//搜索历史数据库表
+ (BOOL)createSearchHistoryTable{
    
    BOOL res = [DATAMANAGER executeUpdate:@"create table if not exists SearchHistoryList(keyWord)"];
    
    if (res == NO) {
        NSLog(@"SearchHistoryList创建失败");
    }else if(res==YES){
        NSLog(@"SearchHistoryList创建成功");
    }
    return res;
}


//搜索历史记录插入数据库
+ (void)insertSearchHistoryToDB:(NSString *)keyWord{
    
    BOOL flag = [DATAMANAGER executeUpdate:@"INSERT INTO SearchHistoryList (keyWord) VALUES (?)",keyWord];
    if(flag){
        NSLog(@"删除成功大大啊大大大的++++++++++++++++++++++++++++++++");
    }else{
        NSLog(@"删除dadada失败");
    }

   
}

//搜索历史记录从数据库中取出
+ (NSMutableArray *)getSearchHistoryData{
    
    FMResultSet* set = [DATAMANAGER executeQuery:@"select * from SearchHistoryList"];
    
    NSMutableArray* array = [NSMutableArray new];
    
    while ([set next]){

        [array addObject:[set stringForColumnIndex:0]];
    }
    [set close];
    
    return array;
}

+(void)DeleteSingleHistoryData:(NSString *)keyWord{
    [DATAMANAGER executeUpdate:@"delete from SearchHistoryList where "];
    
}
+ (void)DeleteSearchHistoryData{
    
    [DATAMANAGER executeUpdate:@"delete from SearchHistoryList"];
}

//搜索历史数据库表


+ (BOOL)createSearchClientTable{
    
    BOOL res = [DATAMANAGER executeUpdate:@"create table if not exists SearchClientList(keyWord)"];
    
    if (res == NO) {
        NSLog(@"SearchClientList创建失败");
    }else if(res==YES){
        NSLog(@"SearchClientList创建成功");
    }
    return res;
}


//搜索历史记录插入数据库
+ (void)insertSearchClientToDB:(NSString *)keyWord{
    
    BOOL flag = [DATAMANAGER executeUpdate:@"INSERT INTO SearchClientList (keyWord) VALUES (?)",keyWord];
    if(flag){
        NSLog(@"删除成功大大啊大大大的++++++++++++++++++++++++++++++++");
    }else{
        NSLog(@"删除dadada失败");
    }

    
}




//搜索历史记录从数据库中取出
+ (NSMutableArray *)getSearchClientData{
    
    FMResultSet* set = [DATAMANAGER executeQuery:@"select * from SearchClientList"];
    
    NSMutableArray* array = [NSMutableArray new];
    
    while ([set next]){
        
        [array addObject:[set stringForColumnIndex:0]];
    }
    [set close];
    
    return array;
}

+ (void)DeleteSearchClientData{
    
    [DATAMANAGER executeUpdate:@"delete from SearchClientList"];
}
//删除一条搜索历史记录
+ (void)DeletSingleeSearchClientData{
    
};

#pragma mark -查找 和 添加 融云客户的昵称和头像

//判断是否创建融云客户昵称头像列表数据库表
+ (BOOL)createRongyunTable{
    
    BOOL res = [DATAMANAGER executeUpdate:@"create table if not exists RongYunList( shopID,imId ,imName,imIcon,imToken)"];
    
    if (res == NO) {
        NSLog(@"RongYunList创建失败");
    }else if(res==YES){
        NSLog(@"RongYunList创建成功");
    }
    return res;
}


//+(void)createRongyunTable{
//    
//}

// *插入融云客户的昵称和头像
+ (void)insertRongYunToDB:(NSString *)shopID imId:(NSString *)imId imName:(NSString *)imName imIcon:(NSString *)imIcon imToken:(NSString *)imToken  {
    
    // BOOL flag = [DATAMANAGER executeUpdate:@"INSERT INTO RongYunList (keyWord) VALUES (?)",keyWord];
    BOOL flag = [DATAMANAGER executeUpdate:@"INSERT INTO RongYunList (shopID,imId,imName,imIcon,imIcon) VALUES (?,?,?,?,?)",shopID,imId,imName,imIcon,imToken];
    if(flag){
        NSLog(@"插入融云数据昵称头像成功");
    }else{
        NSLog(@"未能插入插入融云数据 昵称头像未能插入插入融云数据 昵称头像未能插入插入融云数据 昵称头像");
    }
}

//查找所有融云客户的昵称和头像
+ (NSArray *)getRongYunData:(NSString *)shopID {
    
    FMResultSet* set = [DATAMANAGER executeQuery:@"select * from RongYunList where shopID=?",shopID];
    
    NSMutableArray* array = [NSMutableArray new];
    
    while ([set next]){
        //按条取出数据，转换为Model输出
//        RcimUser *rec = [[RcimUser alloc]init];
//        //融云用户shdpID
//        rec.shopId= [set stringForColumnIndex:0];
//        //融云用户id
//        rec.userId = [set stringForColumnIndex:1];
//        //融云用户昵称
//        rec.userName = [set stringForColumnIndex:2];
//        
//        //融云头像
//        rec.portrait = [set stringForColumnIndex:3];
//        //融云头像
//        rec.imToken = [set stringForColumnIndex:4];
//
//        [array addObject:rec];
    }
    [set close];
    return array;
}

// *取出

//替换修改某条数据数据
//+ (void)updateRongYunData:(NSString *)shopID shopID:(NSString *)imId imName:(NSString *)imName imIcon:(NSString *)imIcon {
//    
//   BOOL flag = [DATAMANAGER executeUpdate:@" update RongYunList set imName = ? and imIcon = ? WHERE shopID = ? and imId = ?",imName,imIcon,shopID,imId];
//    if(flag){
//        NSLog(@"更新失败");
//    }
//    
//}{

+ (void)updateRongYunData:(NSString *)shopID imId:(NSString *)imId imName:(NSString *)imName imIcon:(NSString *)imIcon{
       BOOL flag = [DATAMANAGER executeUpdate:@"update RongYunList set imName = ?, imIcon = ? where shopID = ? and imId = ?",imName,imIcon,shopID,imId];
    if(flag){
          NSLog(@"更新成功大大啊大大大的++++++++++++++++++++++++++++++++");
    }else{
          NSLog(@"更新dadada失败");
    }

//        if(flag){
//            NSLog(@"更新失败");
//        }else{
//            NSLog(@"更新成功大大啊大大大的++++++++++++++++++++++++++++++++");
//
//        }
//    
    
}

+(void)deleSIngleRongYun:(NSString *)shopID imId:(NSString *)imId{
    BOOL flag= [DATAMANAGER executeUpdate:@"DELETE FROM RongYunList WHERE shopID=? and imId =?",shopID,imId];

    if(flag){
        NSLog(@"删除成功大大啊大大大的++++++++++++++++++++++++++++++++");
    }else{
        NSLog(@"删除dadada失败");
    }

    
}
@end
