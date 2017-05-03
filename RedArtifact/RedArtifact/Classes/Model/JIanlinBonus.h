//
//  JIanlinBonus.h
//  RedArtifact
//
//  Created by LiLu on 16/10/11.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JIanlinBonus : NSObject


/** adv_id */
@property (nonatomic, copy) NSString *adv_id;

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
