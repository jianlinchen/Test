//
//  RABlanceBarGain.h
//  RedArtifact
//
//  Created by LiLu on 16/9/19.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RABlanceBarGain : NSObject
/** log_id */
@property (copy, nonatomic) NSString *log_id;

/** user_id */
@property (copy, nonatomic) NSString *user_id;

/** amount */
@property (copy, nonatomic) NSString *amount;

/** source */
@property (copy, nonatomic) NSString *source;

/** source_id" */
@property (copy, nonatomic) NSString *source_id;

/** type */
@property (copy, nonatomic) NSString *type;

/** create_time */
@property (copy, nonatomic) NSString *create_time;

/** source_str */
@property (copy, nonatomic) NSString *source_str;

@end
