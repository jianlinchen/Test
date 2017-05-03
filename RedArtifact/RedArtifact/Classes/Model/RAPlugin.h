//
//  RAPlugin.h
//  RedArtifact
//
//  Created by xiaoma on 16/8/24.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RAPlugin : NSObject

/** app_id */
@property (nonatomic, copy) NSString *app_id;

/** logo */
@property (nonatomic, copy) NSString *logo;

/** name */
@property (nonatomic, copy) NSString *name;

/** target */
@property (nonatomic, copy) NSString *target;

/** link */
@property (nonatomic, copy) NSString *link;

/** create_time */
@property (nonatomic, copy) NSString *create_time;

/** lastmodified_time */
@property (nonatomic, copy) NSString *lastmodified_time;

/** plugin_id */
@property (nonatomic, copy) NSString *plugin_id;


@end
