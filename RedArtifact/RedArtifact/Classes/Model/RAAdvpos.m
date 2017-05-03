//
//  RAAdvpos.m
//  RedArtifact
//
//  Created by xiaoma on 16/8/24.
//  Copyright © 2016年 jianlin. All rights reserved.
//  广告轮播图

#import "RAAdvpos.h"
/** 广告轮播位ID */
static NSString *const kAdvposID = @"id";

/** name */
static NSString *const kAdv_merchant_name = @"adv_merchant_name";

/** adv_target */
static NSString *const kAdv_target = @"adv_target";

/** adv_image */
static NSString *const kAdv_image = @"adv_image";

/** begin_time */
static NSString *const kBegin_time = @"begin_time";

/** end_time */
static NSString *const kEnd_time = @"end_time";

/** status */
static NSString *const kStatus = @"status";

/** create_time */
static NSString *const kCreate_time = @"create_time";

/** lastmodified_time */
static NSString *const kLastmodified_time = @"lastmodified_time";


@implementation RAAdvpos

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"advposID" : kAdvposID,
             @"adv_merchant_name" : kAdv_merchant_name,
             @"adv_target" : kAdv_target,
             @"adv_image" : kAdv_image,
             @"begin_time" : kBegin_time,
             @"end_time" : kEnd_time,
             @"status" : kStatus,
             @"create_time" : kCreate_time,
             @"lastmodified_time" : kLastmodified_time
             };
}

MJCodingImplementation

@end

