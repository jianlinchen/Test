//
//  RegisterViewController.m
//  RedArtifact
//
//  Created by xiaoma on 16/8/22.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "RegisterViewController.h"
#import "Server.h"
#import "MD5.h"
#import "NSString+AES.h"
#import "SingleWebViewController.h"
#import "MapLocation.h"
#import "CustomAlertView.h"

@interface RegisterViewController () <UITextViewDelegate>
{
    NSString *_encryptStr;
    
    NSString *_locationLng;//经度
    NSString *_locationLat;//纬度
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top_logoHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *usernameLabel_topHeight;

@property (weak, nonatomic) IBOutlet UIImageView *phoneImgView;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImgView;
@property (weak, nonatomic) IBOutlet UIImageView *eyeImgView;

@property (weak, nonatomic) IBOutlet UIButton *verityButton;


@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *verityTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;




@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _encryptStr = nil;
    
    _locationLat = @"1";
    _locationLng = @"1";
    
    [self setLayoutConstraint];
    
    [self setTextPlaceholder];
    
//    if ([User sharedInstance].accesstoken) {
//        [Tools getServerKeyConfig];
//    } else {
        [Tools getServerKeyCommon];
//    }
    
    [self getLocation];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _verityButton.enabled = YES;
    [_verityButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - textfiled delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.phoneTextField == textField) {
        self.phoneImgView.image = [UIImage imageNamed:@"login-phone-input-icon"];
    }
    if (self.passwordTextField == textField) {
        self.passwordImgView.image = [UIImage imageNamed:@"login-password-input-icon"];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.phoneTextField == textField) {
        if (self.phoneTextField.text.length > 0) {
            self.phoneImgView.image = [UIImage imageNamed:@"login-phone-input-icon"];
        } else {
            self.phoneImgView.image = [UIImage imageNamed:@"login-phone-icon"];
        }
    }
    
    if (self.passwordTextField == textField) {
        if (self.passwordTextField.text.length > 0) {
            self.passwordImgView.image = [UIImage imageNamed:@"login-password-input-icon"];
        } else {
            self.passwordImgView.image = [UIImage imageNamed:@"login-password-icon"];
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

#pragma mark - Button Action
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)getVerityCodeAction:(id)sender {
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (![reach isReachable]) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"请检查网络设置"];
        [alertView showTarget:self];
        return;
        
    }

    if (self.phoneTextField.text.length != 11) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"手机号输入有误"];
        
        [alertView showTarget:self];
    } else {
        _verityButton.userInteractionEnabled = NO;
        NSDictionary *params = @{
                                 @"telphone" : self.phoneTextField.text,
                                 @"type" : @"reg_code"
                                 };
         [MBProgressHUD showMessag:@"" toView:self.view];
        [[HttpRequest shareInstance] getidentifyingcode:params dataApi:GetDentifyingcode completed:^(id data, NSString *stringData) {
            if (data) {

            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Tools setTimerWithTimecount:121 timerRuning:^(NSString *tiemStr) {
                    [self.verityButton setTitle:[NSString stringWithFormat:@"%@S",tiemStr] forState:UIControlStateNormal];
                    self.verityButton.userInteractionEnabled = NO;
                } tiemrInvalid:^(BOOL invalid) {
                    if (invalid) {
                        [self.verityButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                        self.verityButton.userInteractionEnabled = YES;
                    }
                }];
            }
        } failed:^(RAError *error) {
            
            if (error) {
      [MBProgressHUD hideHUDForView:self.view animated:YES];
         NSString *messageStr;
                if (error.code ==60000023) {
                    messageStr=@"手机号输入有误";
                }else if (error.code ==60000036){
                    messageStr=@"手机号已注册，如需修改密码,请打开“我的”->“个人中心”去完成重置密码";
 
                }
                else{
                    messageStr=error.errorDetail;

                }
           CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错啦！" message:messageStr];
                
                [alertView showTarget:self];
            }
            _verityButton.userInteractionEnabled = YES;
            [_verityButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        }];
    }
}

- (IBAction)passwordVisibleAction:(UIButton *)sender {
    self.passwordTextField.secureTextEntry = !self.passwordTextField.isSecureTextEntry;
    self.passwordTextField.text = self.passwordTextField.text;
    
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

- (IBAction)registerAction:(id)sender {
    
    
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

    if (self.phoneTextField.text.length != 11) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"手机号输入有误"];
        [alertView showTarget:self];
    } else if (self.verityTextField.text.length == 0){
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"验证码输入有误"];
        
        [alertView showTarget:self];
    } else if (self.passwordTextField.text.length < 6||self.passwordTextField.text.length>12){
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"密码格式不符合要求"];
        
        [alertView showTarget:self];
    } else {

        
       [MBProgressHUD showMessag:@"" toView:self.view];
            NSMutableDictionary *program = [[NSMutableDictionary alloc] init];
            [program setValue:self.phoneTextField.text forKey:@"telphone"];
            [program setValue:self.verityTextField.text forKey:@"verifycode"];
           
            NSString *paStr=[NSString stringWithFormat:@"%@%@%@", [Server shareInstance].password_secret_key_common,self.passwordTextField.text,[Server shareInstance].password_secret_key_common];
            
            NSString *transtStr2=[NSString base64StringFromText:paStr];
            [program setValue:transtStr2 forKey:@"set_password"];
            
            [program setValue:_locationLng forKey:@"lng"];
            [program setValue:_locationLat forKey:@"lat"];
            
            [GLOBLHttp Method:GET withTransmitHeader:nil withApiProgram:program withBodyProgram:nil withPathApi:GetUserAuthentication completed:^(id data, NSString *stringData) {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                if ([data[@"message"] isEqualToString:@"OK"]) {
                    User *user = [User sharedInstance];
                    user.accesstoken = data[@"data"][@"accesstoken"] ? data[@"data"][@"accesstoken"] : @"";
                    user.userId = data[@"data"][@"userid"] ? data[@"data"][@"userid"] : @"";
                    user.userNmae = self.phoneTextField.text;
                    user.isLogin = YES;
                    [user save];
                    
                    [MBProgressHUD showError:@"注册成功" toView:self.view];
//                    [Tools getPersonInfo];//获取个人信息

                    
                    [Tools getServerKeyConfig];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil];
                    
                } else {
                }
            } failed:^(RAError *error) {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (error.code == TELPHONE_IDENTIFYING_CODE_NOT_MATCH) {
                    CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"验证码输入有误"];
                    
                    [alertView showTarget:self];
                } else if (error.code == USER_PASSWORD_INVALID) {
                    CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"密码格式不符合要求"];
                    
                    [alertView showTarget:self];
                }else if (error.code==  RAErrorServerNotReachable){
                    CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"请检查网络设置"];
                    [alertView showTarget:self];
                    
                }else if (error.code==  60000023){
                    CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"手机号输入有误"];
                    [alertView showTarget:self];
                    
                }
                else {
                  CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"注册失败，请重新注册！"];
                    
                    [alertView showTarget:self];

                }
            }];
        }
//    }

}


#pragma mark - privite
/** 自动布局设置 */
- (void)setLayoutConstraint {
    if (UIScreenHeight == 568) {
        _usernameLabel_topHeight.constant = 480.0/667.0 *108;
        _top_logoHeight.constant = 568.0/667.0 *93 - 10;
    } else if (UIScreenHeight == 480) {
        _usernameLabel_topHeight.constant = 480.0/667.0 *108 + 20;
        _top_logoHeight.constant = 480.0/667.0 *93;
    }
}
/** 设置text默认字符 */
- (void)setTextPlaceholder {
    [self.phoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [Tools setTextFieldPlaceHolder:self.phoneTextField withTitle:@"请输入11位手机号码" withColor:0xffffff];
    [Tools setTextFieldPlaceHolder:self.passwordTextField withTitle:@"请输入6～12位密码" withColor:0xffffff];
    [Tools setTextFieldPlaceHolder:self.verityTextField withTitle:@"请输入验证码" withColor:0xffffff];
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
