//
//  RASuperbonus.m
//  RedArtifact
//
//  Created by xiaoma on 16/9/21.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "RASuperbonus.h"


/** event_id */
static NSString *kEvent_id = @"event_id";

/** end_time */
static NSString *kEnd_time = @"end_time";

/** end_time_str */
static NSString *kEnd_time_str = @"end_time_str";

/** bonus_money */
static NSString *kBonus_money = @"bonus_money";

/** begin_time */
static NSString *kBegin_time= @"begin_time";

/** begin_time_str */
static NSString *kBegin_time_str = @"begin_time_str";

/** create_time */
static NSString *kCreate_time = @"create_time";

/** create_time_str */
static NSString *kCreate_time_str = @"create_time_str";

/** description */
static NSString *kDescription = @"description";

/** event_name */
static NSString *kEvent_name = @"event_name";

/** images */
static NSString *kImages = @"images";

/** keyword */
static NSString *kKeyword = @"keyword";

/** max_join_user_num */
static NSString *kMax_join_user_num = @"max_join_user_num";

/** merchant_name */
static NSString *kMerchant_name = @"merchant_name";

/** reward_page */
static NSString *kReword_page = @"reward_page";

/** user_count */
static NSString *kUser_count = @"user_count";

/** 参与人数 */
static NSString *kReward_users = @"reward_users";

@implementation RASuperbonus

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"event_id" : kEvent_id,
             @"end_time" : kEnd_time,
             @"end_time_str" : kEnd_time_str,
             @"bonus_money" : kBonus_money,
             @"begin_time" : kBegin_time,
             @"begin_time_str" : kBegin_time_str,
             @"create_time" : kCreate_time,
             @"create_time_str" : kCreate_time_str,
             @"superbonus_description" : kDescription,
             @"event_name" : kEvent_name,
             @"images" : kImages,
             @"max_join_user_num" : kMax_join_user_num,
             @"merchant_name" : kMerchant_name,
             @"reward_page" : kReword_page,
             @"user_count" : kUser_count,
             @"reward_users" : kReward_users
             };
}

MJCodingImplementation

@end
