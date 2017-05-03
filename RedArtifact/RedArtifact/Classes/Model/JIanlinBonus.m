//
//  JIanlinBonus.m
//  RedArtifact
//
//  Created by LiLu on 16/10/11.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "JIanlinBonus.h"

/** adv_id */
static NSString *const kAdv_id = @"adv_id";

//** prize_top_money */
static NSString *const kPrize_top_money = @"prize_top_money";

/************  红包配置  ************/
/** 总人数 */
static NSString *const kPrize_total_num = @"prize_total_num";

/** 总金额 */
static NSString *const kPrize_total_money = @"prize_total_money";

/** 一等奖人数 */
static NSString *const kPrize_top_num = @"prize_top_num";

/** 一等奖金额 */
static NSString *const kPrize_top_per_money = @"prize_top_per_money";

/** 二等奖人数 */
static NSString *const kPrize_second_num = @"prize_second_num";

/** 二等奖金额 */
static NSString *const kPrize_second_per_money = @"prize_second_per_money";

/** 三等奖人数 */
static NSString *const kPrize_third_num = @"prize_third_num";

/** 三等奖金额 */
static NSString *const kPrize_third_per_money = @"prize_third_per_money";

/** 随机奖人数 */
static NSString *const kPrize_consolation_num = @"prize_consolation_num";

/** 随机奖金额 */
static NSString *const kPrize_consolation_per_money = @"prize_consolation_per_money";

/** 服务费 */
static NSString *const kPrize_service_money = @"prize_service_money";


@implementation JIanlinBonus

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"adv_id" : kAdv_id,
             @"prize_total_num" : kPrize_total_num,
             @"prize_total_money" : kPrize_total_money,
             @"prize_top_num" : kPrize_top_num,
             @"prize_top_per_money" : kPrize_top_per_money,
             @"prize_second_num" : kPrize_second_num,
             @"prize_second_per_money" : kPrize_second_per_money,
             @"prize_third_num" : kPrize_third_num,
             @"prize_third_per_money" : kPrize_third_per_money,
             @"prize_consolation_num" : kPrize_consolation_num,
             @"prize_consolation_per_money" : kPrize_consolation_per_money,
             @"prize_service_money" : kPrize_service_money,
             };
}

@end
