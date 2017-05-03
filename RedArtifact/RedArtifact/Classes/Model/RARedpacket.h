//
//  RARedpacket.h
//  RedArtifact
//
//  Created by xiaoma on 16/8/25.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RARedpacket : NSObject

/** adv_id */
@property (nonatomic, copy) NSString *adv_id;

/** pub_id */
@property (nonatomic, copy) NSString *pub_id;

/** red_title */
@property (nonatomic, copy) NSString *red_title;

/** red_description */
@property (nonatomic, copy) NSString *red_description;

/** content */
@property (nonatomic, strong) NSDictionary *red_content;

/** pub_begin_time */
@property (nonatomic, copy) NSString *pub_begin_time;

/** pub_end_time */
@property (nonatomic, copy) NSString *pub_end_time;

/** prize_top_money */
@property (nonatomic, copy) NSString *prize_top_money;

/** bonus_remain_num */
@property (nonatomic, copy) NSString *bonus_remain_num;

//红包状态
@property (nonatomic, assign) NSInteger status;

/************  红包配置  ************/
/** 总人数 */
@property (nonatomic, copy) NSString *prize_total_num;

/** 总金额 */
@property (nonatomic, copy) NSString *prize_total_money;

/** 一等奖人数 */
@property (nonatomic, copy) NSString *prize_top_num;

/** 一等奖金额 */
@property (nonatomic, copy) NSString *prize_top_per_money;

/** 二等奖人数 */
@property (nonatomic, copy) NSString *prize_second_num;

/** 二等奖金额 */
@property (nonatomic, copy) NSString *prize_second_per_money;

/** 三等奖人数 */
@property (nonatomic, copy) NSString *prize_third_num;

/** 三等奖金额 */
@property (nonatomic, copy) NSString *prize_third_per_money;

/** 随机奖人数 */
@property (nonatomic, copy) NSString *prize_consolation_num;

/** 随机奖金额 */
@property (nonatomic, copy) NSString *prize_consolation_per_money;

/** 服务费 */
@property (nonatomic, copy) NSString *prize_service_money;

@end
