
//
//  RAConsumer.m
//  RedArtifact
//
//  Created by xiaoma on 16/9/19.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "RAConsumer.h"

/** log_id */
static NSString *const kLog_id = @"log_id";

/** adv_id */
static NSString *const kAdv_id = @"adv_id";

/** pub_id */
static NSString *const kPub_id = @"pub_id";

/** pub_name */
static NSString *const kPub_name = @"pub_name";

/** user_id */
static NSString *const kUser_id = @"user_id";

/** prize_level */
static NSString *const kPrize_level = @"prize_level";

/** money */
static NSString *const kMoney = @"money";

/** adv_title */
static NSString *const kAdv_title = @"adv_title";

/** adv_description */
static NSString *const kAdv_description = @"adv_description";

/** 广告内容 */
static NSString *const kAdvert_content = @"adv_content";

/** user_telphone */
static NSString *const kUser_telphone = @"user_telphone";

/** user_nickname */
static NSString *const kUser_nickname = @"user_nickname";

/** user_heading */
static NSString *const kUser_heading = @"user_headimg";

/** create_time */
static NSString *const kCreate_time = @"create_time";


@implementation RAConsumer

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"log_id" : kLog_id,
             @"adv_id" : kAdv_id,
             @"pub_id" : kPub_id,
             @"pub_name" : kPub_name,
             @"user_id" : kUser_id,
             @"prize_level" : kPrize_level,
             @"money" : kMoney,
             @"adv_title" : kAdv_title,
             @"adv_description" : kAdv_description,
             @"adv_content" : kAdvert_content,
             @"user_telphone" : kUser_telphone,
             @"user_nickname" : kUser_nickname,
             @"user_heading" : kUser_heading,
             @"create_time" : kCreate_time,
             };
}

MJCodingImplementation

@end
