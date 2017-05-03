//
//  RARefundlog.h
//  RedArtifact
//
//  Created by xiaoma on 16/9/7.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RARefundlog : NSObject

/** log_id */
@property (nonatomic, copy) NSString *log_id;

/** user_id */
@property (nonatomic, copy) NSString *user_id;

/** refund_status
 *0 未申请退款 1 	已申请退款 2 	退款受理中 8 无需退款 9 退款完成
 */
@property (nonatomic, copy) NSString *refund_status;

/** create_time */
@property (nonatomic, copy) NSString *create_time;

/** refund_status_str */
@property (nonatomic, copy) NSString *refund_status_str;

/** refund_total_amount */
@property (nonatomic, copy) NSString *refund_total_amount;

@end
