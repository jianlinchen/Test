//
//  RAPlugin.m
//  RedArtifact
//
//  Created by xiaoma on 16/8/24.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "RAPlugin.h"
/** app_id */
static NSString *const kApp_id = @"app_id";

/** logo */
static NSString *const kLogo= @"logo";

/** name */
static NSString *const kName = @"name";

/** target */
static NSString *const kTarget = @"target";

/** link */
static NSString *const kLink = @"link";

/** create_time */
static NSString *const kCreate_time = @"create_time";

/** lastmodified_time */
static NSString *const kLastmodified_time = @"lastmodified_time";

/** plugin_id */
static NSString *const kPlugin_id = @"plugin_id";


@implementation RAPlugin

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"app_id" : kApp_id,
             @"logo" : kLogo,
             @"name" : kName,
             @"target" : kTarget,
             @"link" : kLink,
             @"create_time" : kCreate_time,
             @"lastmodified_time" : kLastmodified_time,
             @"plugin_id" : kPlugin_id
             };
}

MJCodingImplementation

@end
