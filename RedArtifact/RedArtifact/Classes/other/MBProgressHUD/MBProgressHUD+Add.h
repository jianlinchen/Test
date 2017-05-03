//
//  MBProgressHUD+Add.h
//  MaoMeng
//
//  Created by Jerry on 14-12-27.
//  Copyright (c) 2014年 www.xlingmao.com All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Add)
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;

@end
