//
//  WithDrawMoeyViewController.m
//  RedArtifact
//
//  Created by LiLu on 16/9/18.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "WithDrawMoeyViewController.h"
#import "DetailWithDrawViewController.h"
#import "PaymentBanlanceViewController.h"
#import "WXApiManager.h"
#import "QualificationViewController.h"
#import "Server.h"
@interface WithDrawMoeyViewController (){
     NSString *codeStr;//授权
    
      NSString *tranStrMoney;//金额
}

@end

@implementation WithDrawMoeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"提现";
    [self setupNav];//设置右边导航栏
    self.AliPayButton.layer.cornerRadius = 5;
    self.AliPayButton.layer.masksToBounds = YES;
    self.WeiPayButton.layer.cornerRadius = 5;
    self.WeiPayButton.layer.masksToBounds = YES;
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];
    
    if ([self.withDrawUserInfo.verify_status isEqualToString:@"0"]) {
        [self showUnauthorizedView:@"hao" andImage:[UIImage imageNamed:@"888.png"] andBool:YES];
        
    }else if ([self.withDrawUserInfo.verify_status isEqualToString:@"1"]){
        [self showUnauthorizedView:@"hao" andImage:[UIImage imageNamed:@"888.png"] andBool:NO];
        
    }else if ([self.withDrawUserInfo.verify_status isEqualToString:@"2"]){

        
    }else if ([self.withDrawUserInfo.verify_status isEqualToString:@"3"]){
        [self showUnauthorizedView:@"hao" andImage:[UIImage imageNamed:@"888.png"] andBool:YES];
        
    }
     self.alertLabel.text=[Server shareInstance].suggest_words[@"transfer_request"];
}

#pragma 设置导航栏
-(void)setupNav
{
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,80,30)];
    [rightButton setTitle:@"收支明细" forState:UIControlStateNormal];
    [rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    rightButton.titleLabel.font=[UIFont systemFontOfSize :14.0];
    [rightButton addTarget:self action:@selector(click)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
   
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getMoney];
}
#pragma 账号提现
-(void)getMoney{
     [MBProgressHUD showMessag:@"" toView:self.view];
    NSMutableDictionary *program = [[NSMutableDictionary alloc] init];
    [program setValue:[User sharedInstance].accesstoken forKey:@"ACCESS-TOKEN"];
    [[HttpRequest shareInstance] Method:GET withTransmitHeader:program withApiProgram:nil withBodyProgram:nil withPathApi:GetUserBalance completed:^(id data, NSString *stringData) {
        if (data) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSString *transtStr=[NSString stringWithFormat:@"%@",data[@"data"][@"balance"][@"wallet_balance"]];
            NSString *transtStr2=[NSString setNumLabelWithStr:transtStr];
            tranStrMoney=transtStr2;
            
             NSString *moneyStr=[NSString stringWithFormat:@"￥%@",transtStr2];
            self.myBlanceLabel.text=moneyStr;
            
        }
    } failed:^(RAError *error) {
//        NSLog(@"%@",error.errorDescription);
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了" message:error.errorDetail];
        [alertView showTarget:self.navigationController];
    }];
    
    
}

- (void) goVC {
  
    [super goVC];
   
    QualificationViewController *VC=[[QualificationViewController alloc]init];
    
    [self.navigationController pushViewController:VC animated:YES];
    
  }

-(void)click{
    PaymentBanlanceViewController *VC=[[PaymentBanlanceViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
    
}

- (IBAction)AliPayAction:(id)sender {
    DetailWithDrawViewController *VC=[[DetailWithDrawViewController alloc]init];
    VC.title=@"支付宝提现";
    VC.moneyStr=tranStrMoney;
    
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)tongzhi:(NSNotification *)text{
  
    NSString *urlStr=[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WEIXIN_APPID,WEIXIN_APPSRCERT,text.object];
    [GLOBLHttp getWeixin:nil dataApi:urlStr completed:^(id data, NSString *stringData) {
        NSDictionary *dic=data;
        
        if (!dic[@"errcode"]) {
            codeStr=[NSString stringWithFormat:@"%@",dic[@"openid"]];
            DetailWithDrawViewController *VC=[[DetailWithDrawViewController alloc]init];
            VC.title=@"微信提现";
            VC.cantrayStr=@"1";
            VC.openId=codeStr;
            VC.moneyStr=tranStrMoney;

            [self.navigationController pushViewController:VC animated:YES];
            
            
            DLog(@"%@",data);
        }else{
            DLog(@"++++++++++++++++++++++++++++++++++++++");
        }
        
    } failed:^(RAError *error) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了" message:error.errorDetail];
        [alertView showTarget:self.self.navigationController];
//        [MBProgressHUD showError:@"出错了！请重试" toView:self.view];
    }];
}

- (IBAction)WeiPayAction:(id)sender {
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]){
        
       SendAuthReq* req =[[SendAuthReq alloc ] init ] ;
    
       req.scope =@"snsapi_userinfo," ;
    
      req.state =@"123123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    
      [WXApi sendReq:req];

    }else{
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"请先安装微信"];
        [alertView showTarget:self.navigationController];
    }
    
}
   

@end
