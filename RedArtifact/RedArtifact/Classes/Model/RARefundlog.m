//
//  RARefundlog.m
//  RedArtifact
//
//  Created by xiaoma on 16/9/7.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "RARefundlog.h"

/** log_id */
static NSString *const kLog_id = @"log_id";

/** user_id */
static NSString *const kUser_id = @"user_id";

/** refund_status
 *0 未申请退款 1 	已申请退款 2 	退款受理中 8 无需退款 9 退款完成
 */
static NSString *const kRefund_status = @"refund_status";

/** create_time */
static NSString *const kCreate_time = @"create_time";

/** refund_status_str */
static NSString *const kRefund_status_str = @"refund_status_str";

/** refund_total_amount */
static NSString *const kRefund_total_amount = @"refund_total_amount";

@implementation RARefundlog

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"log_id" : kLog_id,
             @"user_id" : kUser_id,
             @"refund_status" : kRefund_status,
             @"create_time" : kCreate_time,
             @"refund_status_str" : kRefund_status_str,
             @"refund_total_amount" : kRefund_total_amount,
             };
}

MJCodingImplementation

@end
