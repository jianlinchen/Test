//
//  RASuperbonus.h
//  RedArtifact
//
//  Created by xiaoma on 16/9/21.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RASuperbonus : NSObject

/** event_id */
@property (nonatomic, copy) NSString *event_id;

/** end_time */
@property (nonatomic, copy) NSString *end_time;

/** end_time_str */
@property (nonatomic, copy) NSString *end_time_str;

/** bonus_money */
@property (nonatomic, copy) NSString *bonus_money;

/** begin_time */
@property (nonatomic, copy) NSString *begin_time;

/** begin_time_str */
@property (nonatomic, copy) NSString *begin_time_str;

/** bonus_num */
@property (nonatomic, copy) NSString *bonus_num;

/** create_time */
@property (nonatomic, copy) NSString *create_time;

/** create_time_str */
@property (nonatomic, copy) NSString *create_time_str;

/** description */
@property (nonatomic, copy) NSString *superbonus_description;

/** event_name */
@property (nonatomic, copy) NSString *event_name;

/** images */
@property (nonatomic, strong) NSArray *images;

/** keyword */
@property (nonatomic, copy) NSString *keyword;

/** max_join_user_num */
@property (nonatomic, copy) NSString *max_join_user_num;

/** merchant_name */
@property (nonatomic, copy) NSString *merchant_name;

/** reward_page */
@property (nonatomic, copy) NSString *reward_page;

/** user_count */
@property (nonatomic, copy) NSString *user_count;

//是否参与 1:已参与 0:未参与
@property (nonatomic, copy) NSString *join_state;

/** 参与人数 */
@property (nonatomic, strong) NSArray *reward_users;

@end
