//
//  LoginViewController.m
//  RedArtifact
//
//  Created by LiLu on 16/7/25.
//  Copyright © 2016年 jianlin. All rights reserved.
//


#import "LoginViewController.h"
#import "User.h"
#import "Server.h"
#import "SingleWebViewController.h"
#import "NSString+AES.h"
#import "RegisterViewController.h"
#import "QuickLoginViewController.h"
#import "RestPasswordViewController.h"
#import "MapLocation.h"
#import "CustomAlertView.h"

@interface LoginViewController () <UITextFieldDelegate>
{
    NSString *_encryptStr;//加密字符串
    
    NSString *_locationLng;//经度
    NSString *_locationLat;//纬度
}
/** 布局高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line_bottomHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *usernameLabel_topHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *login_top_logoHeight;

@property (weak, nonatomic) IBOutlet UIImageView *phoneImgView;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImgView;
@property (weak, nonatomic) IBOutlet UIImageView *eyeImgView;

@property (weak, nonatomic) IBOutlet UITextField *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;

@end

@implementation LoginViewController

#pragma mark - cyclelife method
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    
    _encryptStr = nil;
    [self setLayoutConstraint];
    _locationLat = @"1";
    _locationLng = @"1";

    [self setTextPlaceholder];
    [Tools getServerKeyCommon];
    [self getLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
     NSString * uerToken = [[NSUserDefaults standardUserDefaults] objectForKey:OrAlertView];
    if ([uerToken isEqualToString:@"1"]) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了" message:@"身份认证已失效，请重新登录"];
                        [alertView showTarget:self.navigationController];
    }
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:OrAlertView];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - textfiled delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.usernameLabel == textField) {
        self.phoneImgView.image = [UIImage imageNamed:@"login-phone-input-icon"];
    }
    if (self.passwordLabel == textField) {
        self.passwordImgView.image = [UIImage imageNamed:@"login-password-input-icon"];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.usernameLabel == textField) {
        if (self.usernameLabel.text.length > 0) {
            self.phoneImgView.image = [UIImage imageNamed:@"login-phone-input-icon"];
        } else {
            self.phoneImgView.image = [UIImage imageNamed:@"login-phone-icon"];
        }
    }
    
    if (self.passwordLabel == textField) {
        if (self.passwordLabel.text.length > 0) {
            self.passwordImgView.image = [UIImage imageNamed:@"login-password-input-icon"];
        } else {
            self.passwordImgView.image = [UIImage imageNamed:@"login-password-icon"];
        }
        
    }
}
- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == self.usernameLabel) {
        if (textField.text.length > 11) {
            
            textField.text = [textField.text substringToIndex:11];
        }
    }
}
#pragma mark - Button Action
- (IBAction)passwordVisibleAction:(UIButton *)sender {
    self.passwordLabel.secureTextEntry = !self.passwordLabel.isSecureTextEntry;
    self.passwordLabel.text = self.passwordLabel.text;
    
    if (sender.tag == 1000) {
        sender.tag = 1001;
        self.eyeImgView.image = [UIImage imageNamed:@"login-eyes-input-icon"];
    } else {
        sender.tag = 1000;
        self.eyeImgView.image = [UIImage imageNamed:@"login-eyes-icon"];
    }
    
}

- (IBAction)lookAgreementActon:(id)sender {
    SingleWebViewController *aggrementVC=[[SingleWebViewController alloc]init];
    aggrementVC.title=@"使用协议";
    aggrementVC.webUrl=TermOfUse;
    [self.navigationController pushViewController:aggrementVC animated:YES];
}

- (IBAction)forgetPasswordAction:(id)sender {
    RestPasswordViewController *vc = [[RestPasswordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)registerAction:(id)sender {
    RegisterViewController *vc = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)quickLoginAction:(id)sender {
    QuickLoginViewController *vc = [[QuickLoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)loginAction:(id)sender {

    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (![reach isReachable]) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"请检查网络设置"];
        [alertView showTarget:self];
        return;

    }
    
    if ([_locationLng isEqualToString:@"1"]||[_locationLng isEqualToString:@"1"]) {
        
        [self getLocation];
        return;
        
    }
    if (self.usernameLabel.text.length != 11) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了" message:@"手机号输入有误"];
        [alertView showTarget:self];
        
    } else if (self.passwordLabel.text.length < 6||self.passwordLabel.text.length>12){
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错啦！" message:@"密码格式不符合要求"];
        
        [alertView showTarget:self];
    } else {
        NSMutableDictionary *program = [[NSMutableDictionary alloc] init];
        [program setValue:self.usernameLabel.text forKey:@"telphone"];
    
        NSString *paStr=[NSString stringWithFormat:@"%@%@%@", [Server shareInstance].password_secret_key_common,self.passwordLabel.text,[Server shareInstance].password_secret_key_common];
            
        NSString *transtStr2=[NSString base64StringFromText:paStr];
            
       [program setValue:transtStr2 forKey:@"password"];
            
            [program setValue:_locationLng forKey:@"lng"];
            [program setValue:_locationLat forKey:@"lat"];
        
        
         [MBProgressHUD showMessag:@"" toView:self.view];
            [GLOBLHttp Method:GET withTransmitHeader:nil withApiProgram:program withBodyProgram:nil withPathApi:GetUserAuthentication completed:^(id data, NSString *stringData) {
                if (data) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                    User *user = [User sharedInstance];
                    user.accesstoken = data[@"data"][@"accesstoken"] ? data[@"data"][@"accesstoken"] : @"";
                    user.userId = data[@"data"][@"userid"] ? data[@"data"][@"userid"] : @"";
                    user.userNmae = self.usernameLabel.text;
                    user.password = self.passwordLabel.text;
                    user.isLogin = YES;
                    [user save];
                    // 登录成功
                    [Tools getServerKeyConfig];// 获取全局变量值
                    [MBProgressHUD showError:@"登录成功" toView:self.view];
                    [Tools getPersonInfo];//获取个人信息
                    [Tools getServerKeyConfig];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil];
                    
                }
            } failed:^(RAError *error) {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                if (error.code==60000002) {
                    CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"手机号未注册"];
                    [alertView showTarget:self];
                }else if (error.code==60000034){
                    CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"账户密码不匹配"];
                    [alertView showTarget:self];
 
                }else if (error.code==  RAErrorServerNotReachable){
                    CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"请检查网络设置"];
                    [alertView showTarget:self];
                    
                }else if (error.code==  60000023){
                    CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"手机号输入有误"];
                    [alertView showTarget:self];
                    
                }
                else{
                    CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"登录失败，请重新登录"];
                    [alertView showTarget:self];
 
                }
                    
            }];
    }
}
#pragma mark - privite
/** 自动布局设置 */
- (void)setLayoutConstraint {
    if (UIScreenHeight == 568) {
        _usernameLabel_topHeight.constant = 568.0/667.0 *120 - 10;
        _line_bottomHeight.constant = 568.0/667.0 *85 - 10;
        _login_top_logoHeight.constant = 568.0/667.0 *93 - 10;
    } else if (UIScreenHeight == 480) {
        _usernameLabel_topHeight.constant = 480.0/667.0 *120 + 20;
        _line_bottomHeight.constant = 480.0/667.0 *85 - 20;
        _login_top_logoHeight.constant = 480.0/667.0 *93;
    }
}
/** 设置text默认字符 */
- (void)setTextPlaceholder {
    [self.usernameLabel addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [Tools setTextFieldPlaceHolder:self.usernameLabel withTitle:@"请输入11位手机号" withColor:0xffffff];
    [Tools setTextFieldPlaceHolder:self.passwordLabel withTitle:@"请输入6～12位密码" withColor:0xffffff];
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
        
        _locationLat = [NSString stringWithFormat:@"%f",userLatitude];
        
        _locationLng=[NSString stringWithFormat:@"%f",userLongitude];
        
    } failureBlock:^(NSString *errorMsg, NSUInteger errorCode) {
        NSLog(@"============%@",errorMsg);
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
