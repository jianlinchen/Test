//
//  RABlanceBarGain.m
//  RedArtifact
//
//  Created by LiLu on 16/9/19.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "RABlanceBarGain.h"

@implementation RABlanceBarGain
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"log_id"      : @"log_id",
             @"user_id"     : @"user_id",
             @"amount"      : @"amount",
             @"source"      : @"source",
             @"source_id"   : @"source_id",
             @"type"        : @"type",
             @"create_time" : @"create_time",
              @"source_str" : @"source_str",
             
             };
}

MJCodingImplementation
@end
