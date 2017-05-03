//
//  RATabViewController.m
//  RedArtifact
//
//  Created by xiaoma on 16/8/9.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "RATabViewController.h"
#import "RANavigationController.h"
#import "RAHomeViewController.h"
#import "MineViewController.h"
#import "RedpackViewController.h"
#import "AdvertSendViewController.h"
#import "AdvertMineHostController.h"
#import "RedpackHostViewController.h"
#import "LBTabBar.h"
#import "UIImage+Image.h"

@interface RATabViewController ()<LBTabBarDelegate>

@end

@implementation RATabViewController
/** 第一次调用类的时候会调用该方法 */
+ (void)initialize {
    // 设置UITabBarItem的主题
    [self setupTabBarItemTheme];
}

/** 设置UITabBarItem的主题 */
+ (void)setupTabBarItemTheme {
    // 通过设置 appearance对象，能够修改整个项目中所有UITabBarItem的样式
    UITabBarItem *appearance = [UITabBarItem appearance];
    
    [appearance setTitleTextAttributes:@{
                                         NSForegroundColorAttributeName : [UIColor colorWithHex:0x666666],
                                         NSFontAttributeName : [UIFont systemFontOfSize:10.0f],
                                         } forState:UIControlStateNormal];
    
    [appearance setTitleTextAttributes:@{
                                         NSForegroundColorAttributeName : [UIColor colorWithHex:0xff4848],
                                         NSFontAttributeName : [UIFont systemFontOfSize:10.0f],
                                         } forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    LBTabBar *tabbar = [[LBTabBar alloc] init];
    tabbar.myDelegate = self;
    //kvc实质是修改了系统的_tabBar
    [self setValue:tabbar forKeyPath:@"tabBar"];
    [self setUpAllChildVc];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (TabSelect) name:@"TabSelect" object:nil];

}
- (void)TabSelect{
    self.selectedIndex=2;
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"AdvertMineHostControllerTabSelect" object:nil];
}
#pragma 初始化tabBar上除了中间按钮之外所有的按钮

- (void)setUpAllChildVc
{
    
    RAHomeViewController *HomeVC = [[RAHomeViewController alloc] init];
    [self setUpOneChildVcWithVc:HomeVC Image:@"home_normal" selectedImage:@"home_highlight" title:@"首页"];
    
    RedpackHostViewController *FishVC = [[RedpackHostViewController alloc] init];
    [self setUpOneChildVcWithVc:FishVC Image:@"fish_normal" selectedImage:@"fish_highlight" title:@"红包"];
    
    AdvertMineHostController *MessageVC = [[AdvertMineHostController alloc] init];
    [self setUpOneChildVcWithVc:MessageVC Image:@"message_normal" selectedImage:@"message_highlight" title:@"广告"];
    
    MineViewController *MineVC = [[MineViewController alloc] init];
    [self setUpOneChildVcWithVc:MineVC Image:@"account_normal" selectedImage:@"account_highlight" title:@"我的"];
 
}

#pragma mark - 初始化设置tabBar上面单个按钮的方法

/**
 *  @author li bo, 16/05/10
 *
 *  设置单个tabBarButton
 *
 *  @param Vc            每一个按钮对应的控制器
 *  @param image         每一个按钮对应的普通状态下图片
 *  @param selectedImage 每一个按钮对应的选中状态下的图片
 *  @param title         每一个按钮对应的标题
 */
- (void)setUpOneChildVcWithVc:(UIViewController *)Vc Image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    RANavigationController *nav = [[RANavigationController alloc] initWithRootViewController:Vc];
    
    
//    Vc.view.backgroundColor = [self randomColor];
    
    UIImage *myImage = [UIImage imageNamed:image];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //tabBarItem，是系统提供模型，专门负责tabbar上按钮的文字以及图片展示
    Vc.tabBarItem.image = myImage;
    
    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    Vc.tabBarItem.selectedImage = mySelectedImage;
    
    Vc.tabBarItem.title = title;
    
    Vc.navigationItem.title = title;
    
    [self addChildViewController:nav];
    
}


#pragma mark - ------------------------------------------------------------------
#pragma mark - LBTabBarDelegate
//点击中间按钮的代理方法
- (void)tabBarPlusBtnClick:(LBTabBar *)tabBar
{
    
    
     AdvertSendViewController *plusVC = [[AdvertSendViewController alloc] init];
     RANavigationController *navVc = [[RANavigationController alloc] initWithRootViewController:plusVC];
        [self presentViewController:navVc animated:YES completion:nil];
//    [self.navigationController pushViewController:navVc animated:YES];
}

@end
