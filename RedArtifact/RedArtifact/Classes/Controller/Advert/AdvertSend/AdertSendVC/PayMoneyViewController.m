//
//  PayMoneyViewController.m
//  RedArtifact
//
//  Created by LiLu on 16/9/5.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "PayMoneyViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "Order.h"
#import "WXApiRequestHandler.h"
#import "WXApi.h"
#import "PaySuccessAndShareVC.h"

@interface PayMoneyViewController (){
    NSInteger typeNSInteger;//支付方式选择
    
    NSString *prayID;     //订单账号
    
    
    
}
@end

@implementation PayMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"支付";
    
    

//    self.moenyLabel.text=self.moneyStr;
    NSString *monStr=[NSString setNumLabelWithStr:self.moneyStr];
    self.moenyLabel.text=[NSString stringWithFormat:@"￥%@", monStr];
    typeNSInteger=2;
    self.cirButton.layer.cornerRadius = 5;
    self.cirButton.layer.masksToBounds = YES;
    [self getNav];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (payPush:) name:PushSuccess object:nil];
    
    
}

-(UIImage *) getImageFromURL:(NSString *)fileURL {
    DLog(@"执行图片下载函数");
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}
-(void)getNav{
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-black-return-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}
-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:BackAdvert object:@"支付失败"];
}
- (IBAction)cirfimPayAction:(id)sender {
    
    if (typeNSInteger==2) {
        [self processAliPay];
    }else{
        [self processWeiChatPay];
    }
    
}
- (IBAction)aliPAyAction:(id)sender {
    typeNSInteger=2;
    self.rightAliPayImageView.image=[UIImage imageNamed:@"send_advert-Select"];
    self.rightWeiXinImageView.image=[UIImage imageNamed:@"send_advert-Norma"];
}

- (IBAction)WeiXinPayAction:(id)sender {
    
    typeNSInteger=1;
    self.rightWeiXinImageView.image=[UIImage imageNamed:@"send_advert-Select"];
    self.rightAliPayImageView.image=[UIImage imageNamed:@"send_advert-Norma"];
    
}
#pragma 支付宝----支付流程
-(void)processAliPay{
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (![reach isReachable]) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"请检查网络设置"];
        [alertView showTarget:self];
        return;
        
    }
    
     [MBProgressHUD showMessag:@"" toView:self.view];
    NSMutableDictionary *headerDic=[[NSMutableDictionary alloc]init];
    headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
    headerDic[@"IDENTITY"] =@"PRODUCER";
    
    NSMutableDictionary *bodyDic=[[NSMutableDictionary alloc]init];
    bodyDic[@"pay_type"]=@"2";
    bodyDic[@"adv_id"]  =self.adv_id;
    
    
    HttpRequest *request = [[HttpRequest alloc] init];
    request.isVlaueKey = YES;
    [request Method:(POST) withTransmitHeader:headerDic withApiProgram:nil withBodyProgram:bodyDic withPathApi:PostPaymentOrder completed:^(id data, NSString *stringData) {
       
      [MBProgressHUD hideHUDForView:self.view animated:YES];

        
        NSDictionary *dic=data;
        
        NSString *orderStr=dic[@"data"][@"pay_uri"];
        DLog(@"成功了");
        
        NSString *appScheme = @"wx36e34c361a0b2b3f";
        
        [[AlipaySDK defaultService] payOrder:orderStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            DLog(@"APViewController---reslut = %@",resultDic);
            
            if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:PushSuccess object:@"支付成功"];
            }else{
                
        [[NSNotificationCenter defaultCenter] postNotificationName:PushSuccess object:@"支付失败"];
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"抱歉，支付失败！" delegate:self cancelButtonTitle:@"再来一次" otherButtonTitles:nil, nil];
//                [alert show];
            }
        }];
        
        
    } failed:^(RAError *error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error.code==13000040) {
            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了!" message:@"此订单已过期，请重新创建"];
            [alertView showTarget:self.navigationController];
    
        }else{
            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:error.errorDetail];
            [alertView showTarget:self.navigationController];
//        [self.hudManager showMessage:error.errorDetail duration:1.0];
        }
    }];

}
#pragma 微信----支付流程
-(void)processWeiChatPay{
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (![reach isReachable]) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"请检查网络设置"];
        [alertView showTarget:self];
        return;
        
    }
    
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]){
    
    NSString *payId=self.adv_id;
    NSString *res = [WXApiRequestHandler jumpToBizPay:payId];
    if( ![@"" isEqual:res] ){
    [[NSNotificationCenter defaultCenter] postNotificationName:PushSuccess object:@"支付失败"];
    }else{
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil];
        //            NSLog(@"支付成功了微信，需要回到rootviewcontroller");
    }
    
    }else{
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"请先安装微信"];
        [alertView showTarget:self.navigationController];
        
//        [MBProgressHUD showError:@"请先安装微信" toView:self.view];
    }
}

-(void)payPush:(NSNotification *)text{
    PaySuccessAndShareVC *VC=[[PaySuccessAndShareVC alloc]init];
    VC.shareImageURL = self.shareImageURL;
    VC.shareSuccesssVcTitle=self.shareSuccesssTitle;
    VC.sharePrice = self.moneyStr;
    if ([text.object isEqualToString:@"支付失败"]) {
        VC.orSucessStr=@"支付失败";
        
    }
    [self.navigationController pushViewController:VC animated:YES];

}
@end
