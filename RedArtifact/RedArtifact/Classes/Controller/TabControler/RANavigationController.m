//
//  RANavigationController.m
//  RedArtifact
//
//  Created by xiaoma on 16/8/9.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "RANavigationController.h"
#import "LoginViewController.h"
#import "User.h"

@interface RANavigationController () <UINavigationControllerDelegate> {
    UINavigationController *_currentNavigationController;
}

@end

@implementation RANavigationController

/** 第一次调用类的时候会调用该方法 */
+ (void)initialize {
    // 设置UINavigationBar的主题
    [self setupNavigationBarTheme];
    [self setupBarButtonItemTheme];
}

/** 设置UINavigationBar的主题 */
+ (void)setupNavigationBarTheme {
    // 通过设置 appearance对象，能够修改整个项目中所有UINavigationBar的样式
    UINavigationBar *appearance = [UINavigationBar appearance];
//
//    // 设置UIBarButtonItem的tintColor
//    appearance.tintColor = [UIColor blackColor];
//    
//    // 设置UINavigationBar的背景色 及titleView文字属性
//    [appearance setBarTintColor:[UIColor colorWithHex:MAINCOLOR]];
//

    [appearance setTitleTextAttributes:[Tools getNavigationBarTitleTextAttributes]];
    
    
    if (IOS7) {
        [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"NavBackGround"] forBarMetrics:UIBarMetricsDefault];
        
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        
    } else {
        [[UINavigationBar appearance] setTintColor:MAIN_COLOR];
        [[UINavigationBar appearance] setBackgroundColor:MAIN_COLOR];
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    }
}
/** 设置UIBarButtonItem的主题 */
+ (void)setupBarButtonItemTheme {
    //通过设置 appearance对象，能够修改整个项目中所有UIBarButtonItem的样式
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    
    // 设置文字的属性
    // 1.设置普通状态下文字的属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    // 设置字体
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    
    // 设置颜色为橙色
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [appearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 2.设置高亮状态下文字的属性
    NSMutableDictionary *hightextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    // 设置颜色为红色
    hightextAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [appearance setTitleTextAttributes:hightextAttrs forState:UIControlStateHighlighted];
    
    // 3.设置不可用状态下文字的属性
    NSMutableDictionary *disabletextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    disabletextAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [appearance setTitleTextAttributes:disabletextAttrs forState:UIControlStateDisabled];
    
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   
                                   color.CGColor);
    
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return img;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([UINavigationBar instancesRespondToSelector:@selector(setShadowImage:)])
        
    {
        [[UINavigationBar appearance] setShadowImage:[self imageWithColor:[UIColor clearColor] size:CGSizeMake(kScreenWidth, 3)]];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
//    if (![reach isReachable]) {
//        [OverAllManager alertView:@"网络异常,请检查网络连接!"];
//        return;
//    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:@"RAAccessTokenInvalid" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //accesstoken是否过期
//    [self accesstokenIsExpired];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Override

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    // 如果现在push的不是栈顶控制器，则隐藏tabbar工具条
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-black-return-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    }
    
    [super pushViewController:viewController animated:animated];
}

#pragma mark - UINavigaionControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    _currentNavigationController = navigationController;
}

#pragma mark - back
- (void)back {
    [self popViewControllerAnimated:YES];
}
#pragma mark - login
- (void)login {
    if (_currentNavigationController) {
        NSLog(@"去登录");
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

//#pragma mark - 判断accesstoken是否过期
//- (void)accesstokenIsExpired {
//    if ([NSDate timeIntervalWithTime:[User sharedInstance].accesstokenTime] <= 0) {
//        NSLog(@"accesstoken过期");
//        [self refreshAccesstoken];
//    }
//}
//
//- (void)refreshAccesstoken {
//    NSMutableDictionary *program = [[NSMutableDictionary alloc] init];
//    [program setValue:[User sharedInstance].accesstoken forKey:@"ACCESS-TOKEN"];
//    [[HttpRequest shareInstance] Method:GET withTransmitHeader:program withApiProgram:nil withBodyProgram:nil withPathApi:GetUserRefreshtoken completed:^(id data, NSString *stringData) {
//        if (data) {
//            User *user = [User sharedInstance];
//            user.accesstoken = data[@"data"][@"accesstoken"] ? data[@"data"][@"accesstoken"] : @"";
//            user.userId = data[@"data"][@"userid"] ? data[@"data"][@"userid"] : @"";
//            float time = [data[@"data"][@"time"] doubleValue] + [data[@"data"][@"expire_time"] doubleValue]*3/4;
//            user.accesstokenTime = time;
//            user.isLogin = YES;
//            [user save];
//        }
//    } failed:^(RAError *error) {
//        NSLog(@"%@",error.errorDescription);
//    }];
//}
//
@end
