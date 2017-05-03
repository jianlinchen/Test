//
//  Server.h
//  RedArtifact
//
//  Created by xiaoma on 16/8/22.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Server : NSObject

/*
 * password_secret_key(有accesstoken)
 */
@property (copy, nonatomic) NSString *password_secret_key;

/*
 * password_secret_key_no(没有accesstoken)
 */
@property (copy, nonatomic) NSString *password_secret_key_common;

/*
 * api
 */
@property (copy, nonatomic) NSString *api;

/*
 * push_alias_id
 */
@property (copy, nonatomic) NSString *push_alias_id;

/*
 * suggest_words
 */
@property (copy, nonatomic) NSDictionary *suggest_words;

/*
 * 客服电话
 */
@property (copy, nonatomic) NSString *server_tel;

/*
 * 举报内容
 */
@property (strong, nonatomic) NSArray *accusation_options;


/*
 * 最低提现金额
 */
@property (copy, nonatomic) NSString *transfer_min_amount;

/*
 * 每日最高提现次数
 */
@property (copy, nonatomic) NSString *trasnfer_request_limit_per_day;

/*
 * 未领取红包分享描述
 */
@property (copy, nonatomic) NSString *description_unaccepted_redpacket_share;

/*
 * 已领取红包分享描述
 */
@property (copy, nonatomic) NSString *description_on_accepted_redpacket_share;

/*
 * 超级红包分享描述
 */
@property (copy, nonatomic) NSString *super_bonus_description;


/*
 * 红包分享标题
 */
@property (copy, nonatomic) NSString *redpacket_share_title;

/*
 * 分享URL
 */
@property (copy, nonatomic) NSString *share_link;


/*
 * 二维码分享链接
 */
@property (copy, nonatomic) NSDictionary *promotion_share_info;

/*
 * 支付成功分享描述
 */
@property (copy, nonatomic) NSString *description_on_pay_success;


+ (instancetype)shareInstance;

- (void)save;

@end
