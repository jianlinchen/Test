//
//  MBProgressHUD+Add.m
//  MaoMeng
//
//  Created by Jerry on 14-12-27.
//  Copyright (c) 2014年 www.xlingmao.com All rights reserved.
//

#import "MBProgressHUD+Add.h"

@implementation MBProgressHUD (Add)

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:1.5];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view {
    
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    if(message)
        hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    hud.color = [UIColor clearColor];
    UIView *gifView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 190, 70)];
    gifView.backgroundColor=RGBHex(0xc6c6c6);
//    gifView.alpha=0.3;
    gifView.layer.masksToBounds=YES;
    gifView.layer.cornerRadius=8.0f;
    
    UILabel *loadingLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 10, 90, 50)];
    loadingLabel.text=@"加载中...";
    loadingLabel.textColor=RGBHex(0xffffff);
    loadingLabel.font=[UIFont systemFontOfSize:17];
    
    
    UIImageView * imagev = [[UIImageView alloc]
                                           initWithFrame:CGRectMake(5, 10, 100, 50)];
    imagev.contentMode=UIViewContentModeCenter;
    imagev.animationDuration=2.5;
    //设置重复次数,0表示不重复
    imagev.animationRepeatCount=0;
    //开始动画
    [imagev startAnimating];
    //设置动画帧
    imagev.animationImages=[NSArray arrayWithObjects:
                            [UIImage imageNamed:@"loading_Image-1"],
                            [UIImage imageNamed:@"loading_Image-2"],
                            [UIImage imageNamed:@"loading_Image-3"],
                            [UIImage imageNamed:@"loading_Image-4"],
                            [UIImage imageNamed:@"loading_Image-5"],
                            [UIImage imageNamed:@"loading_Image-6"],
                            [UIImage imageNamed:@"loading_Image-7"],
                            [UIImage imageNamed:@"loading_Image-8"],
                            [UIImage imageNamed:@"loading_Image-9"],
                            [UIImage imageNamed:@"loading_Image-10"],
                            [UIImage imageNamed:@"loading_Image-11"],
                            [UIImage imageNamed:@"loading_Image-12"],
                            [UIImage imageNamed:@"loading_Image-13"],
                            [UIImage imageNamed:@"loading_Image-14"],
                            [UIImage imageNamed:@"loading_Image-15"],
                            [UIImage imageNamed:@"loading_Image-16"],
                            [UIImage imageNamed:@"loading_Image-17"],
                            [UIImage imageNamed:@"loading_Image-18"],
                            nil ];
    [gifView addSubview:imagev];
    [gifView addSubview:loadingLabel];
    hud.customView = gifView;
    hud.mode = MBProgressHUDModeCustomView;
    [imagev startAnimating];
    
    return hud;
}
@end
