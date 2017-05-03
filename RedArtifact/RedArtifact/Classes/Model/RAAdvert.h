//
//  RAAdvert.h
//  RedArtifact
//
//  Created by xiaoma on 16/8/8.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RAAdvert : NSObject

/*************   广告   ************/
/*
 * 发布人ID
 */
@property (copy, nonatomic) NSString *pub_user_id;

/*
 * 发布人logo
 */
@property (copy, nonatomic) NSString *pub_user_logo;

/*
 * 发布人实名
 */
@property (copy, nonatomic) NSString *pub_user_realname;

/*
 * 发布人昵称
 */
@property (copy, nonatomic) NSString *pub_user_nickname;

/*
 * 发布人名称
 */
@property (copy, nonatomic) NSString *pub_user_name;

/*
 * 发布文本类型
 */
@property (copy, nonatomic) NSString *pub_ext_type;

/*
 * 发布文本ID
 */
@property (copy, nonatomic) NSString *pub_ext_id;

/*
 * 广告标题
 */
@property (copy, nonatomic) NSString *advert_title;

/*
 * 广告描述
 */
@property (copy, nonatomic) NSString *advert_description;

/*
 * 广告内容
 */
@property (strong, nonatomic) NSDictionary *advert_content;

/*
 * 广告发布地址
 */
@property (copy, nonatomic) NSString *contact_address;

/*
 * 广告发布lat
 */
@property (copy, nonatomic) NSString *contact_lat;

/*
 * 广告发布lng
 */
@property (copy, nonatomic) NSString *contact_lng;

/*
 * 广告状态
 * 1:草稿 2:已提交 3:审核拒绝 4:已删除 9:已发布 12:已完成
 */
@property (copy, nonatomic) NSString *advert_status;

/*
 * 广告ID
 */
@property (copy, nonatomic) NSString *advert_id;

/*
 * 广告创建时间
 */
@property (copy, nonatomic) NSString *advert_create_time;

/*
 * 投放开始时间
 */
@property (copy, nonatomic) NSString *pub_begin_time;

/*
 * 投放结束时间
 */
@property (copy, nonatomic) NSString *pub_end_time;

/*
 * 广告完成状态
 * 0:未发起退款申请 1:已申请  9:已完成  8:无需退款
 */
@property (copy, nonatomic) NSString *refund_status;

/*
 * 退款总金额
 */
@property (copy, nonatomic) NSString *refund_total_amount;

/*************   投放地址   ************/
/*
 * 投放地址
 */
@property (copy, nonatomic) NSString *pub_address;
/*
 * 投放范围
 */
@property (copy, nonatomic) NSString *pub_range;

/*************   红包   ************/
/*
 * 红包总金额
 */
@property (copy, nonatomic) NSString *bonus_total_amount;

/*
 * 红包剩余数量
 */
@property (copy, nonatomic) NSString *bonus_remain_num;

/*
 * 红包总数量
 */
@property (copy, nonatomic) NSString *bonus_total_num;

/*
 * 红包已领取数量
 */
@property (copy, nonatomic) NSString *bonus_accepted_num;

/*
 * 红包已领取金额
 */
@property (copy, nonatomic) NSString *bonus_accepted_amount;


@end
