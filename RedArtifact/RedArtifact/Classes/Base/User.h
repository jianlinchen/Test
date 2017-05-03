//
//  User.h
//  RedArtifact
//
//  Created by xiaoma on 16/8/8.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

/*
 * 用户ID
 */
@property (copy, nonatomic) NSString *userId;

/*
 * 用户头像
 */
@property (copy, nonatomic) NSString *userAvatar;

/*
 * 用户名
 */
@property (copy, nonatomic) NSString *userNmae;

/*
 * 用户昵称
 */
@property (copy, nonatomic) NSString *nickName;

/*
 * 登录密码
 */
@property (copy, nonatomic) NSString *password;

/*
 * 登录令牌
 */
@property (copy, nonatomic) NSString *accesstoken;

/*
 * accesstoken截止时间戳
 */
@property (assign, nonatomic) NSTimeInterval accesstokenTime;

/*
 * 是否登录
 */
@property (nonatomic, assign) BOOL   isLogin;


+ (instancetype)sharedInstance;

- (void)save;

@end
