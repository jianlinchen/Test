//
//  RAUserInfo.m
//  RedArtifact
//
//  Created by xiaoma on 16/8/8.
//  Copyright © 2016年 jianlin. All rights reserved.
//


#import "RAUserInfo.h"
//生日
static NSString *const kBirthday = @"birthday";
//注册时间
static NSString *const kCreate_time = @"create_time";
//邮箱
static NSString *const kEmail = @"email";
//性别
static NSString *const kGender = @"gender";
//头像
static NSString *const kHeadimg = @"headimg";
//last_verify_time
static NSString *const kLast_verify_time = @"last_verify_time";
//昵称
static NSString *const kNickname = @"nickname";
//实名
static NSString *const kRealname = @"realname";
//secretkey
static NSString *const kSecretkey = @"secretkey";
//status
static NSString *const kStatus = @"status";
//手机
static NSString *const kTelphone = @"telphone";
//type
static NSString *const kType = @"type";
//union_ext_id
static NSString *const kUnion_ext_id = @"union_ext_id";
//verify_reason
static NSString *const kVerify_reason = @"verify_reason";
//verify_status
static NSString *const kVerify_status = @"verify_status";

@implementation RAUserInfo

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"birthday" : kBirthday,
             @"create_time" : kCreate_time,
             @"email" : kEmail,
             @"gender" : kGender,
             @"headimg" : kHeadimg,
             @"last_verify_time" : kLast_verify_time,
             @"nickname" : kNickname,
             @"realname" : kRealname,
             @"secretkey" : kSecretkey,
             @"status" : kStatus,
             @"telphone" : kTelphone,
             @"type" : kType,
             @"union_ext_id" : kUnion_ext_id,
             @"verify_reason" : kVerify_reason,
             @"verify_status" : kVerify_status
             };
}

MJCodingImplementation

@end
