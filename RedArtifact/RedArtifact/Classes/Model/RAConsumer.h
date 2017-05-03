//
//  RAConsumer.h
//  RedArtifact
//
//  Created by xiaoma on 16/9/19.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RAConsumer : NSObject

/** log_id */
@property (copy, nonatomic) NSString *log_id;

/** adv_id */
@property (copy, nonatomic) NSString *adv_id;

/** pub_name */
@property (copy, nonatomic) NSString *pub_name;

/** pub_id */
@property (copy, nonatomic) NSString *pub_id;

/** user_id */
@property (copy, nonatomic) NSString *user_id;

/** prize_level */
@property (copy, nonatomic) NSString *prize_level;

/** money */
@property (copy, nonatomic) NSString *money;

/** adv_title */
@property (copy, nonatomic) NSString *adv_title;

/** adv_description */
@property (copy, nonatomic) NSString *adv_description;

/** 广告内容 */
@property (strong, nonatomic) NSDictionary *adv_content;

/** user_telphone */
@property (copy, nonatomic) NSString *user_telphone;

/** user_nickname */
@property (copy, nonatomic) NSString *user_nickname;

/** user_heading */
@property (copy, nonatomic) NSString *user_heading;

/** create_time */
@property (copy, nonatomic) NSString *create_time;


@end
