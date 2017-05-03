 //
//  QuickLoginViewController.m
//  RedArtifact
//
//  Created by LiLu on 16/8/22.
//  Copyright © 2016年 jianlin. All rights reserved.
//
#import<CommonCrypto/CommonDigest.h>
#import "QuickLoginViewController.h"
#import "SingleWebViewController.h"
#import "NSData+AES.h"
#import "NSString+AES.h"
#import "MD5.h"
#import "MapLocation.h"
#import "User.h"
#import "Server.h"
#import "NSString+Base64.h"
#import "CustomAlertView.h"
#import "MapLocation.h"
@interface QuickLoginViewController (){
    NSString *strLat;
    NSString *strLng;
}

@end

@implementation QuickLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initConer];
    self.phoneTextField.delegate=self;
     strLat = @"1";
     strLng = @"1";
    
    [Tools getServerKeyCommon];

    [self setTextPlaceholder];
    
    [self getLocation];

}

-(void)initConer{
    //sho
    self.phoneView.layer.cornerRadius = 5;
    self.phoneView.layer.masksToBounds = YES;
    
    
    self.veryView.layer.cornerRadius = 5;
    self.veryView.layer.masksToBounds = YES;
    
   
    self.loginButton.layer.cornerRadius = 23;
    self.loginButton.layer.masksToBounds = YES;
    
    
}
#pragma mark - textfiled delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.phoneTextField == textField) {
        self.phoneIconImageView.image = [UIImage imageNamed:@"login-phone-input-icon"];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.phoneTextField == textField) {
        if (self.phoneTextField.text.length > 0) {
            self.phoneIconImageView.image = [UIImage imageNamed:@"login-phone-input-icon"];
        } else {
            self.phoneIconImageView.image = [UIImage imageNamed:@"login-phone-icon"];
        }
    }
    
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == self.phoneTextField) {
        if (textField.text.length > 11) {
            
            textField.text = [textField.text substringToIndex:11];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    DLog(@"KScreenHeightKScreenHeight%f",KScreenHeight);
    if (kScreenWidth==320) {
        if (KScreenHeight==480) {
            self.bottomViewLayout.constant=0;
            self.topLayoutConstraint.constant=90;

        }else{
            self.bottomViewLayout.constant=30;
            self.topLayoutConstraint.constant=100;

        }
        self.verLayout.constant=6;
        self.topBackgroundLayout.constant=110;
        self.logoTopLayout.constant=75;
        self.topLayoutConstraint.constant=100;
        
    }
    self.navigationController.navigationBarHidden = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)dentifyingAction:(id)sender {
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (![reach isReachable]) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"请检查网络设置"];
        [alertView showTarget:self];
        return;
        
    }

    if (self.phoneTextField.text.length!=11) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"手机号输入有误"];
        
        [alertView showTarget:self];
        return;
    }
     [MBProgressHUD showMessag:@"" toView:self.view];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    dic[@"telphone"]=self.phoneTextField.text;
    dic[@"type"]=@"login_code";
    [GLOBLHttp Method:GET withTransmitHeader:nil withApiProgram:dic withBodyProgram:nil withPathApi:GetDentifyingcode completed:^(id data, NSString *stringData) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        DLog(@"成功%@",stringData);
        [Tools setTimerWithTimecount:121 timerRuning:^(NSString *tiemStr) {
            [self.identifyingButton setTitle:[NSString stringWithFormat:@"%@S",tiemStr] forState:UIControlStateNormal];
            self.identifyingButton.userInteractionEnabled = NO;
        } tiemrInvalid:^(BOOL invalid) {
            if (invalid) {
                [self.identifyingButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.identifyingButton.userInteractionEnabled = YES;
            }
        }];
        
    } failed:^(RAError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            DLog(@"快速登录快速登录快速登录%u",error.code);

            NSString *messageStr;
            if (error.code ==60000023) {
                messageStr=@"手机号输入有误";
            }else{
                messageStr=error.errorDetail;
                
            }
            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错啦！" message:messageStr];
            
            [alertView showTarget:self];
        }
        [self.identifyingButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.identifyingButton.userInteractionEnabled = YES;
    }];

}

- (IBAction)loginAction:(id)sender {
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (![reach isReachable]) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"请检查网络设置"];
        [alertView showTarget:self];
        return;
        
    }
    if ([strLat isEqualToString:@"1"]||[strLng isEqualToString:@"1"]) {
        
        [self getLocation];
        return;
        
    }

    if (self.phoneTextField.text.length!=11) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"手机号输入有误"];
        
        [alertView showTarget:self];
        return;
    }
    if (self.identifyingTextField.text.length<4) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"验证码输入有误"];
       
        [alertView showTarget:self];
        return;
    }
    MapLocation *locationManager = [MapLocation sharedInstance];
    locationManager.isGeocoder = NO;
    
    [locationManager startGetLocation:^(CLLocationCoordinate2D currentCoordinate, double userLatitude, double userLongitude, NSString *city) {
        
        strLat=[NSString stringWithFormat:@"%f",userLatitude];
   
        strLng=[NSString stringWithFormat:@"%f",userLongitude];
        
        DLog(@"%f===%f===%@",userLatitude,userLongitude,city
              );
    } failureBlock:^(NSString *errorMsg, NSUInteger errorCode) {
        
    }];
    
    NSMutableDictionary *apiDic=[[NSMutableDictionary alloc]init];
      apiDic[@"telphone"]=self.phoneTextField.text;
      apiDic[@"verifycode"]=self.identifyingTextField.text;
      apiDic[@"lng"]=strLng;
      apiDic[@"lat"]=strLat;
     [MBProgressHUD showMessag:@"" toView:self.view];
    [GLOBLHttp Method:GET withTransmitHeader:nil withApiProgram:apiDic withBodyProgram:nil withPathApi:GetUserAuthentication completed:^(id data, NSString *stringData) {
        User *user = [User sharedInstance];
        user.accesstoken = data[@"data"][@"accesstoken"] ? data[@"data"][@"accesstoken"] : @"";
        user.userId = data[@"data"][@"userid"] ? data[@"data"][@"userid"] : @"";
        user.userNmae = self.phoneTextField.text;
        user.isLogin = YES;
        [user save];
        [Tools getServerKeyConfig];
//        [Tools getPersonInfo];//获取个人信息

        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil];
       
            [MBProgressHUD hideHUDForView:self.view animated:YES];
      
       
    } failed:^(RAError *error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error.code == TELPHONE_IDENTIFYING_CODE_NOT_MATCH) {
            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"验证码输入有误"];
            
            [alertView showTarget:self];
            
        } else if ( error.code == 60000023){

            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"手机号输入有误"];
            
            [alertView showTarget:self];
            
        }else if (error.code==  RAErrorServerNotReachable){
            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"请检查网络设置"];
            [alertView showTarget:self];
            
        }else{
            
            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"登录失败，请重新登录"];
            
            [alertView showTarget:self];

        }
    }];
}

- (IBAction)aggrementAction:(id)sender {
    
    SingleWebViewController *aggrementVC=[[SingleWebViewController alloc]init];
    aggrementVC.title=@"使用协议";
    aggrementVC.webUrl=TermOfUse;
    
    [self.navigationController pushViewController:aggrementVC animated:NO];
}
- (IBAction)doBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/** 设置text默认字符 */
- (void)setTextPlaceholder {
    [self.phoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [Tools setTextFieldPlaceHolder:self.phoneTextField withTitle:@"请输入11位手机号码" withColor:0xffffff];
    [Tools setTextFieldPlaceHolder:self.identifyingTextField withTitle:@"请输入验证码" withColor:0xffffff];
}
#pragma mark - 定位获取经纬度
- (void)getLocation {
    
    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        
        CustomAlertView *alertView=[[CustomAlertView alloc]initWithTitle:@"请到手机设置中开启定位服务" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"设置"];
        alertView.delegate=self;
        
        [alertView showTarget:self.navigationController];
        
        return;
        
    }
    
    
    MapLocation *locationManager = [MapLocation sharedInstance];
    locationManager.isGeocoder = NO;
    
    [locationManager startGetLocation:^(CLLocationCoordinate2D currentCoordinate, double userLatitude, double userLongitude, NSString *city) {
        
        strLat = [NSString stringWithFormat:@"%f",userLatitude];
        
        strLng=[NSString stringWithFormat:@"%f",userLongitude];
        
    } failureBlock:^(NSString *errorMsg, NSUInteger errorCode) {
        DLog(@"============%@",errorMsg);
    }];
}
- (void)sureAcion{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
        
    }
    
}
-(void)cancelAcion{
    
    
}

@end
