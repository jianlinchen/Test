//
//  AppDelegate.m
//  RedArtifact
//
//  Created by LiLu on 16/7/25.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "RATabViewController.h"
#import "CatchCrash.h"
#import "MapLocation.h"
#import "JPUSHService.h"
#import "RANavigationController.h"
#import "QuickLoginViewController.h"
#import "Server.h"
#import "AdvertSendViewController.h"
#import "RedPacketSetViewController.h"
#import "MapRangeViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "PayMoneyViewController.h"

#import "WXApi.h"
#import "WXApiObject.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "GuideViewController.h"
#import "OverAllManager.h"


@interface AppDelegate (){
    int p;
    BMKMapManager   * _mapManager;
    NSString        * mandatoryStr;
    NSString        * packagesStr;
    BOOL              ernterYES;//判断是否进入后台
    
}
@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier bgTask;
@property (nonatomic,copy) RATabViewController *redTab;
@end

@implementation AppDelegate

+ (AppDelegate *)appDelegate; {
    return (AppDelegate *) [[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:OrAlertView];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:AdvertListIndex];
    
    // Override point for customization after application launch.
      self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
     [OverAllManager OpenFMDataBase];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(repeatTime) userInfo:nil repeats:YES];

    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel apsForProduction:isProduction];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    
    
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    [self didRootVC];
    
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (skipRootVC:) name:@"LoginSuccess" object:nil];
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (quictToLoginVC:) name:@"quitToLoginVC" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (payNOtice:) name:@"payNOtice" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (JupshNOtice:) name:@"JupshNOtice" object:nil];
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"RedArtifact.db"];
    self.fmdbStore = store;
    
//    
//     [OverAllManager OpenFMDataBase];
    self.screenRateWidth = UIScreenWidth/375;
    self.screenRateHeight = UIScreenHeight/667;
    
    // 调用极光推送
    [self accentJPus:launchOptions];
    
    //调用百度地图
    [self baidu];
    //注册消息处理函数的处理方法，异常处理
//    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    //向微信注册wxd930ea5d5a258f4f
    [WXApi registerApp:weiAppid withDescription:@"demo 2.0"];
//    [self weiXinPay];
    
    //设置友盟
    [self setUMSocial];
    
//    [self repeatTime];
    [self updateVersion];
    return YES;
  
}

#pragma 版本更新
-(void)updateVersion{
    
     NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
      NSString *versonStr = [NSString stringWithFormat:@"%@", [infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    
    if ([User sharedInstance].accesstoken&&[User sharedInstance].accesstoken!=nil ) {
        
        NSMutableDictionary *program = [[NSMutableDictionary alloc] init];
        [program setValue:[User sharedInstance].accesstoken forKey:@"ACCESS-TOKEN"];
        NSMutableDictionary *apiDic=[[NSMutableDictionary alloc]init];
        apiDic[@"platform"]=@"IOS";
        apiDic[@"version"]=versonStr;

        [[HttpRequest shareInstance] Method:GET withTransmitHeader:program withApiProgram:apiDic withBodyProgram:nil withPathApi:GetPlatformUpgrade completed:^(id data, NSString *stringData) {
            if (data) {
                mandatoryStr=[NSString stringWithFormat:@"%@",data[@"data"][@"mandatory"]];
                
                NSString *str= [NSString stringWithFormat:@"%@",data[@"data"][@"mandatory"]];
                 mandatoryStr=str;
                DLog(@"======%@",mandatoryStr);
                NSArray *arr=data[@"data"][@"packages"];
                  packagesStr=arr[0];
                NSString *upgradeStr=[NSString stringWithFormat:@"%@",data[@"data"][@"upgrade"]];
                
                if ([upgradeStr isEqualToString:@"1"] ) {
               
                    CustomAlertView *alertView=[[CustomAlertView alloc]initWithTitle:nil message:@"确认升级新版本？"cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
                    alertView.delegate=self;
                    UIViewController *Vc=[self activityViewController];
                    [alertView showTarget:Vc];

                }
            }
        } failed:^(RAError *error) {
            DLog(@"%@",error.errorDescription);
            
        }];

    }
    
}

- (void)cancelAcion{
    
    if ([ mandatoryStr  isEqualToString:@"0"]) {
        
    }else if([ mandatoryStr  isEqualToString:@"1"]) {
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        UIWindow *window = app.window;
        
        [UIView animateWithDuration:1.0f animations:^{
            window.alpha = 0;
            window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
        } completion:^(BOOL finished) {
            exit(0);
        }];
        //exit(0);
    }

}
- (void)sureAcion{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:packagesStr]];
    
    if ([mandatoryStr  isEqualToString:@"1"]) {
        
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        UIWindow *window = app.window;
        [UIView animateWithDuration:1.0f animations:^{
            window.alpha = 0;
            window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
        } completion:^(BOOL finished) {
            exit(0);
        }];
    }
}
- (UIViewController *)activityViewController
{
    UIViewController* activityViewController = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0)
    {
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]])
        {
            activityViewController = nextResponder;
        }
        else
        {
            activityViewController = window.rootViewController;
        }
    }
    
    return activityViewController;
}
#pragma mark - UMSocial
- (void)setUMSocial {
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:umsocialkey];
    
    //打开调试log的开关
//    [UMSocialData openLog:YES];
    
    //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:WEIXIN_APPID appSecret:WEIXIN_APPSRCERT url:@"http://www.umeng.com/social"];
    
    // 打开新浪微博的SSO开关
    // 将在新浪微博注册的应用appkey、redirectURL替换下面参数，并在info.plist的URL Scheme中相应添加wb+appkey，如"wb3921700954"，详情请参考官方文档。
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:SINA_APPKEY
                                              secret:SINA_APPSRCERT
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:QQ_APPID appKey:QQ_APPKEY url:@"http://www.umeng.com/social"];
    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
}

-(void)didRootVC{
  
    if ([User sharedInstance].accesstoken) {
        
        DLog(@"[User sharedInstance].accesstoke  %@",[User sharedInstance].accesstoken);
        RATabViewController *tabBarVc = [[RATabViewController alloc] init];

//        GuideViewController *tabBarVc = [[GuideViewController alloc] init];
        CATransition *anim = [[CATransition alloc] init];
        anim.type = @"rippleEffect";
        anim.duration = 1.0;
        [self.window.layer addAnimation:anim forKey:nil];
//        self.redTab=tabBarVc;
        self.window.rootViewController = tabBarVc;

        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        
    }else{
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
            DLog(@"第一次启动");
            //如果是第一次启动的话,使用UserGuideViewController (用户引导页面) 作为根视图
            GuideViewController * rootVC = [[GuideViewController alloc] init];
            UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:rootVC];
            self.window.rootViewController = naVC;
            [self.window makeKeyAndVisible];

        }else{
        
       RANavigationController *redpackNavCtl = [[RANavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
       self.window.rootViewController = redpackNavCtl;
       self.window.backgroundColor = [UIColor whiteColor];
            [self.window makeKeyAndVisible];
        }
    }
}

-(void)skipRootVC:(id)sender{
    self.window.rootViewController = [[RATabViewController  alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}
#pragma 退出登录方法
-(void)quictToLoginVC:(id)sender{
    
    RANavigationController *redpackNavCtl = [[RANavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    self.window.rootViewController = redpackNavCtl;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

#pragma 同意返回广告的方法
-(void)payNOtice:(NSNotification *)text{
  
  

    if ([text.object isEqualToString:@"支付成功"]) {
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:AdvertListIndex];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
         [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:AdvertListIndex];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
   RATabViewController *tabVC=[[RATabViewController  alloc] init];
    self.window.rootViewController =tabVC;
    tabVC.selectedIndex=2;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

}
-(void)JupshNOtice:(id)sender{
    RATabViewController *tabVC=[[RATabViewController  alloc] init];
    
    self.window.rootViewController =tabVC;
    tabVC.selectedIndex=1;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
}
#pragma 极光推送
- (void)accentJPus:(NSDictionary *)launchOptions{
    if (launchOptions) {
        
        NSDictionary *pushNotificationKey = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        if (pushNotificationKey) {
            NSDictionary * userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
            
            [self receiveRemoteNotification:userInfo];
            
        }
    }

}
#pragma 调用百度地图
- (void)baidu{
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:BaiDuAppkey  generalDelegate:nil];
    if (!ret) {
        DLog(@"manager start failed!");
    }else{
        DLog(@"百度地图接入成功");
    }
}
#pragma 定时发送位置和重新注册
- (void)repeatTime {
    if ([User sharedInstance].accesstoken) {
   
        p ++;
        [self didLogin];
        DLog(@"%d",p);
        MapLocation *locationManager = [MapLocation sharedInstance];
        locationManager.isGeocoder = NO;
        
        [locationManager startGetLocation:^(CLLocationCoordinate2D currentCoordinate, double userLatitude, double userLongitude, NSString *city) {
            
            NSString *strLat=[NSString stringWithFormat:@"%f",userLatitude];
            
            NSString *strLng=[NSString stringWithFormat:@"%f",userLongitude];
            
            DLog(@"strLat是%@ ======strLng是%@",strLat,strLng);
            NSMutableDictionary *program=[[NSMutableDictionary alloc]init];
            program[@"lat"]=strLat;
            program[@"lng"]=strLng;
            NSMutableDictionary *headerDic=[[NSMutableDictionary alloc]init];
            headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
            [GLOBLHttp Method:POST withTransmitHeader:headerDic withApiProgram:nil withBodyProgram:program withPathApi:PostUserPosition completed:^(NSDictionary *dic, NSString *stringData) {
                
                DLog(@"成功%@",dic.description);
                
            } failed:^(RAError *error) {
                DLog(@"失败%@",error.description);
            }];
            
            
            DLog(@"%f===%f===%@",userLatitude,userLongitude,city
                  );
            
        } failureBlock:^(NSString *errorMsg, NSUInteger errorCode) {
            
        }];
    }
    
}

- (void)networkDidLogin:(NSNotification *)notification {
    
    [self didLogin];
    DLog(@"111111111");
    
    
}
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias{
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,
     [self logSet:tags], alias];
    
    DLog(@"TagsAlias回调:%@", callbackString);
}
- (NSString *)logSet:(NSSet *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
     [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
//    [JPush setBodge:0];
    [JPUSHService resetBadge];
    
     ernterYES=YES;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     ernterYES = NO;
    UIApplication*   app = [UIApplication sharedApplication];
    
    __block  UIBackgroundTaskIdentifier bgTask;
    
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (bgTask != UIBackgroundTaskInvalid)
                
            {
                
                bgTask = UIBackgroundTaskInvalid;
                
            }
            
        });
        
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (bgTask != UIBackgroundTaskInvalid)
                
            {
                
                bgTask = UIBackgroundTaskInvalid;
                
            }
            
        });
        
    });
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            DLog(@"safepay--result = %@---resultStatus--%@",resultDic,[resultDic objectForKey:@"resultStatus"]);
            
            if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                
               [[NSNotificationCenter defaultCenter] postNotificationName:PushSuccess object:@"支付成功"];
                
            }else{
                
                  [[NSNotificationCenter defaultCenter] postNotificationName:PushSuccess object:@"支付失败"];
//      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"抱歉，支付失败！" delegate:self cancelButtonTitle:@"再来一次" otherButtonTitles:nil, nil];
//                [alert show];
            }
            
            
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){
        //支付宝钱包快登授权返回authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            DLog(@"platformapi---result = %@---resultStatus--%@",resultDic,[resultDic objectForKey:@"resultStatus"]);
            if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
               [[NSNotificationCenter defaultCenter] postNotificationName:PushSuccess object:@"支付成功"];
            }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:PushSuccess object:@"支付失败"];
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"抱歉，支付失败！" delegate:self cancelButtonTitle:@"再来一次" otherButtonTitles:nil, nil];
//                [alert show];
            }
            
        }];
    }
    //微信
    if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
        return [WXApi handleOpenURL:url delegate:self];
        
    }
    
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    } else {
        return result;
    }

    return YES;
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    return  [WXApi handleOpenURL:url delegate:self];
    return  [WXApi handleOpenURL:url delegate:self] || [UMSocialSnsService handleOpenURL:url];
}

// 9.0支付调用方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options

{
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            DLog(@"safepay--result = %@---resultStatus--%@",resultDic,[resultDic objectForKey:@"resultStatus"]);
            
            if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                
            [[NSNotificationCenter defaultCenter] postNotificationName:PushSuccess object:@"支付成功"];
                
            }else{
                
                
            [[NSNotificationCenter defaultCenter] postNotificationName:PushSuccess object:@"支付失败"];
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"抱歉，支付失败！" delegate:self cancelButtonTitle:@"再来一次" otherButtonTitles:nil, nil];
//                [alert show];
            }
            
            
        }];
        return YES;
    }
    
    
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

-(void) onReq:(BaseReq*)req {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//生成jpush要的自定义推送编号
- (void)didLogin
{
    DLog(@"极光推送的%@",[Server shareInstance].push_alias_id);
    
    if ([Server shareInstance].push_alias_id) {
        [JPUSHService setAlias:[Server shareInstance].push_alias_id
              callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                        object:self];
    }
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [JPUSHService registerDeviceToken:deviceToken];
    [self  didLogin];
}
- (void)getNotificationRemoteNotfication:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification object];
    [self receiveRemoteNotification:userInfo];
}
- (void)receiveRemoteNotification:(NSDictionary *)userInfo
{
    NSDictionary *dic = (NSDictionary *)userInfo;
    
   if ([userInfo[@"type"] isEqualToString:@"broadcast"]) {
    
     [[NSUserDefaults standardUserDefaults]setObject:dic forKey:BroadcastNSdufalut];
   }else if ([userInfo[@"type"] isEqualToString:@"notice"]){
       
      
       // 进入后台
       if (ernterYES==NO) {
           [[NSNotificationCenter defaultCenter] postNotificationName:@"payNOtice" object:nil];
           DLog(@"进入后台台");
           //进入前台台
       }else{
           DLog(@"进入前前前前前前前前前前前前前前前台台");
       }
       
   }
    
}

//这一部是接收到自定义的消息
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
//    NSLog(@"这一部是接收到自定义的消息推送过来以后走的代理方法%@",notification);
//    
//    NSDictionary *dic=notification.userInfo;
//    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:dic.description delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [view show];
    
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSDictionary *dic = (NSDictionary *)userInfo;
    if ([userInfo[@"type"] isEqualToString:@"broadcast"]) {
        
       [[NSUserDefaults standardUserDefaults]setObject:dic forKey:BroadcastNSdufalut];
    }else if ([userInfo[@"type"] isEqualToString:@"notice"]){
        
        // 进入后台
        if (ernterYES==NO) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"JupshNOtice" object:nil];
            DLog(@"进入后台台");
          //进入前台台
        }else{
            DLog(@"进入前前前前前前前前前前前前前前前台台");
        }
        
    }

      [JPUSHService handleRemoteNotification:userInfo];
    
}
//推送过来以后走的代理方法
//iOS 7 Remote Notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:  (NSDictionary *)userInfo fetchCompletionHandler:(void (^)   (UIBackgroundFetchResult))completionHandler {
    DLog(@"推送过来以后走的代理方法didReceiveRemoteNotification%@",userInfo);
    
    if ([userInfo[@"type"] isEqualToString:@"broadcast"]) {
        
      [[NSUserDefaults standardUserDefaults]setObject:userInfo forKey:BroadcastNSdufalut];
    }else if ([userInfo[@"type"] isEqualToString:@"notice"]){
        
        // 进入后台
        if (ernterYES==NO) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"JupshNOtice" object:nil];
            DLog(@"进入后台台");
            //进入前台台
        }else{
            DLog(@"进入前前前前前前前前前前前前前前前台台");
        }
        
    }

   [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
}

-(void)onResp:(BaseReq *)resp
{
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        DLog(@"微信分享");
        
        //
    }else if ([resp isKindOfClass:[PayResp class]]){
        PayResp *response = (PayResp *)resp;
        
        if (response.errCode== 0) {
          
           
             [[NSNotificationCenter defaultCenter] postNotificationName:PushSuccess object:@"支付成功"];
            
        }else{
            DLog(@"%d",response.errCode);
            [[NSNotificationCenter defaultCenter] postNotificationName:PushSuccess object:@"支付失败"];
        }

        
        //支付成功
         
    }else {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0) {
            NSString *code = aresp.code;
            //  NSDictionary *dic = @{@"code":code};
            NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:code ];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
        }else{
            DLog(@"%d",aresp.errCode);
        }
    }  
    
}

@end
