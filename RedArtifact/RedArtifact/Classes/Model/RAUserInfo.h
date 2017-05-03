//
//  RAUserInfo.h
//  RedArtifact
//
//  Created by xiaoma on 16/8/8.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RAUserInfo : NSObject
/*
 * 生日
 */
@property (copy, nonatomic) NSString *birthday;

/*
 * 注册时间
 */
@property (copy, nonatomic) NSString *create_time;

/*
 * 邮箱
 */
@property (copy, nonatomic) NSString *user_category;

/*
 * 性别：0-未设置，1-男，2-女
 */
@property (copy, nonatomic) NSString *gender;

/*
 * 头像
 */
@property (copy, nonatomic) NSString *headimg;

/*
 * 最后认证时间
 */
@property (copy, nonatomic) NSString *last_verify_time;

/*
 * 昵称
 */
@property (copy, nonatomic) NSString *nickname;

/*
 * 实名
 */
@property (copy, nonatomic) NSString *realname;

/*
 * secretkey
 */
@property (copy, nonatomic) NSString *secretkey;

/*
 * status: 2-被禁用，3-被移除，9-正常
 */
@property (copy, nonatomic) NSString *status;

/*
 * 电话
 */
@property (copy, nonatomic) NSString *telphone;

/*
 * type：1-公民，2-企业
 */
@property (copy, nonatomic) NSString *type;

/*
 * union_ext_id
 */
@property (copy, nonatomic) NSString *union_ext_id;

/*
 * verify_reason
 */
@property (copy, nonatomic) NSString *verify_reason;

/*
 * verify_status 认证
 */
@property (copy, nonatomic) NSString *verify_status;


@end
