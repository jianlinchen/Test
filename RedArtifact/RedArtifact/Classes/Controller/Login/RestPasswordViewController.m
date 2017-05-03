//
//  RestPasswordViewController.m
//  RedArtifact
//
//  Created by LiLu on 16/8/22.
//  Copyright © 2016年 jianlin. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "RestPasswordViewController.h"
#import "NSString+AES.h"
#import "Server.h"
#import "CustomAlertView.h"

@interface RestPasswordViewController ()

@end

@implementation RestPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"重置密码";
    self.cirButton.layer.cornerRadius = 5;
    self.cirButton.layer.masksToBounds = YES;
    
    [self.phoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

        [Tools getServerKeyCommon];
}

- (IBAction)getIdentifyAction:(id)sender {
    
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
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    dic[@"telphone"]=self.phoneTextField.text;
    dic[@"type"]=@"reset_password";
    [GLOBLHttp Method:GET withTransmitHeader:nil withApiProgram:dic withBodyProgram:nil withPathApi:GetDentifyingcode completed:^(id data, NSString *stringData) {
        NSLog(@"成功%@",stringData);
        [Tools setTimerWithTimecount:121 timerRuning:^(NSString *tiemStr) {
            [self.identifyButton setTitle:[NSString stringWithFormat:@"%@S",tiemStr] forState:UIControlStateNormal];
            self.identifyButton.userInteractionEnabled = NO;
        } tiemrInvalid:^(BOOL invalid) {
            if (invalid) {
                [self.identifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.identifyButton.userInteractionEnabled = YES;
            }
        }];
        
    } failed:^(RAError *error) {
        if (error) {
//            [self.hudManager showMessage:error.errorDescription duration:1.0];
            NSString *messageStr;
            if (error.code ==60000023) {
                messageStr=@"手机号输入有误";
            }else{
                messageStr=error.errorDetail;
                
            }

            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错啦！" message:messageStr];
            
            [alertView showTarget:self];

        }
        [self.identifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.identifyButton.userInteractionEnabled = YES;
    }];
}

- (IBAction)cirAction:(id)sender {

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
    
    if (self.identifyTextField.text.length==0) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"验证码输入有误"];
        [alertView showTarget:self];
        return;
    }
    
    if (self.passwordTextField.text.length<6||self.passwordTextField.text.length>12) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"密码格式不符合要求"];
        
        [alertView showTarget:self];
        return;
    }
    
    NSString *paStr=[NSString stringWithFormat:@"%@%@%@", [Server shareInstance].password_secret_key_common,self.passwordTextField.text,[Server shareInstance].password_secret_key_common];
    
    NSString *transtStr2=[NSString base64StringFromText:paStr];
    NSMutableDictionary *bodyDic=[[NSMutableDictionary alloc]init];

    bodyDic [@"telphone"]=self.phoneTextField.text;
    bodyDic [@"verifycode"]=self.identifyTextField.text;
    bodyDic [@"password"]=transtStr2;
    
    HttpRequest *request = [[HttpRequest alloc] init];
    request.isVlaueKey = YES;
    [request Method:POST withTransmitHeader:nil withApiProgram:nil withBodyProgram:bodyDic withPathApi:RestUserPassword completed:^(id data, NSString *stringData) {
        if ([data[@"message"] isEqualToString:@"OK"]) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];

        }else{

            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"重置失败，请重试"];
            
            [alertView showTarget:self];
        }
        
    } failed:^(RAError *error) {
        if (error.code == TELPHONE_IDENTIFYING_CODE_NOT_MATCH) {
            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"验证码输入有误"];
            
            [alertView showTarget:self];
        } else if (error.code == USER_PASSWORD_INVALID) {
            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"验证码输入有误"];
            
            [alertView showTarget:self];
        } else if (error.code == USER_NOT_FOUND_BY_UK) {
            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"手机号未注册"];
            
            [alertView showTarget:self];
        }else if (error.code == 60000015) {
            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"密码格式不符合要求"];
            
            [alertView showTarget:self];
        }
        else {
            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"重置失败，请重试"];
            
            [alertView showTarget:self];
        }
    }];
    
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == self.phoneTextField) {
        if (textField.text.length > 11) {
            
            textField.text = [textField.text substringToIndex:11];
        }
    }
}

@end
