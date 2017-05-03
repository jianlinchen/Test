//
//  RAAdvert.m
//  RedArtifact
//
//  Created by xiaoma on 16/8/8.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "RAAdvert.h"
//发布人ID
static NSString *const kPub_user_id = @"pub_user_id";
//发布人logo
static NSString *const kPub_user_logo = @"pub_user_logo";
//发布人实名
static NSString *const kPub_user_realname = @"pub_user_realname";
//发布人昵称
static NSString *const kPub_user_nickname = @"pub_user_nickname";
//发布人名称
static NSString *const kPub_user_name = @"pub_name";
//发布文本类型
static NSString *const kPub_ext_type = @"pub_ext_type";
//发布文本ID
static NSString *const kPub_ext_id = @"pub_ext_id";
//广告标题
static NSString *const kAdvert_title = @"title";
//广告描述
static NSString *const kAdvert_description = @"description";
//广告内容
static NSString *const kAdvert_content = @"content";
//广告发布地址
static NSString *const kContact_address = @"contact_address";
//广告发布lat
static NSString *const kContact_lat = @"contact_lat";
//广告发布lng
static NSString *const kContact_lng = @"contact_lng";
//广告状态
static NSString *const kAdvert_status = @"status";
//广告ID
static NSString *const kAdvert_id = @"adv_id";
//广告创建时间
static NSString *const kAdvert_create_time = @"create_time";
//投放开始时间
static NSString *const kPub_begin_time = @"pub_begin_time";
//投放结束时间
static NSString *const kPub_end_time = @"pub_end_time";
//已完成退款状态
static NSString *const kRefund_status = @"refund_status";
//退款总金额
static NSString *const kRefund_total_amount = @"refund_total_amount";


/*************** 投放地址  **************/
//投放地址
static NSString *const kPub_address = @"pub_address";
//投放范围
static NSString *const kPub_range = @"pub_range";

/*************** 红包  **************/
//红包总金额
static NSString *const kBonus_total_amount = @"bonus_total_amount";
//红包剩余数量
static NSString *const kBonus_remain_num = @"bonus_remain_num";
//红包总数量
static NSString *const kBonus_total_num = @"bonus_total_num";
//红包已领取金额
static NSString *const kBonus_accepted_amount = @"bonus_accepted_amount";
//红包已领取数量
static NSString *const kBonus_accepted_num = @"bonus_accepted_num";


@implementation RAAdvert

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"pub_user_id" : kPub_user_id,
             @"pub_user_logo" : kPub_user_logo,
             @"pub_user_realname" : kPub_user_realname,
             @"pub_user_nickname" : kPub_user_nickname,
             @"pub_user_name" : kPub_user_name,
             @"pub_ext_type" : kPub_ext_type,
             @"pub_ext_id" : kPub_ext_id,
             @"advert_title" : kAdvert_title,
             @"advert_description" : kAdvert_description,
             @"advert_content" : kAdvert_content,
             @"contact_address" : kContact_address,
             @"contact_lat" : kContact_lat,
             @"contact_lng" : kContact_lng,
             @"advert_status" : kAdvert_status,
             @"advert_id" : kAdvert_id,
             @"advert_create_time" : kAdvert_create_time,
             @"pub_begin_time" : kPub_begin_time,
             @"pub_end_time" : kPub_end_time,
             @"refund_status" : kRefund_status,
             @"refund_total_amount" : kRefund_total_amount,
             //投放地址
             @"pub_address" : kPub_address,
             @"pub_range" : kPub_range,
             //红包
             @"bonus_total_amount" : kBonus_total_amount,
             @"bonus_remain_num" : kBonus_remain_num,
             @"bonus_total_amount" : kBonus_total_num,
             @"bonus_accepted_amount" : kBonus_accepted_amount,
             @"bonus_accepted_num" : kBonus_accepted_num,
             };
}

MJCodingImplementation

@end