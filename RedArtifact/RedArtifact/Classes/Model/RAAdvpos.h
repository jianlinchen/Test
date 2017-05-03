//
//  RAAdvpos.h
//  RedArtifact
//
//  Created by xiaoma on 16/8/24.
//  Copyright © 2016年 jianlin. All rights reserved.
//  广告轮播图

#import <Foundation/Foundation.h>

@interface RAAdvpos : NSObject

/** 广告轮播位ID */
@property (copy, nonatomic) NSString *advposID;

/** name */
@property (copy, nonatomic) NSString *adv_merchant_name;

/** adv_target */
@property (copy, nonatomic) NSString *adv_target;

/** adv_image */
@property (copy, nonatomic) NSString *adv_image;

/** begin_time */
@property (copy, nonatomic) NSString *begin_time;

/** end_time */
@property (copy, nonatomic) NSString *end_time;

/** status */
@property (copy, nonatomic) NSString *status;

/** create_time */
@property (copy, nonatomic) NSString *create_time;

/** lastmodified_time */
@property (copy, nonatomic) NSString *lastmodified_time;


@end
