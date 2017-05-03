//
//  DetailWithDrawViewController.m
//  RedArtifact
//
//  Created by LiLu on 16/9/18.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "DetailWithDrawViewController.h"
#import "DetailWithDrawCell.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "Server.h"
#import "WithDrawMoeyViewController.h"
@interface DetailWithDrawViewController (){
    NSString *codeStr;//授权
}
@property (nonatomic,strong) NSMutableArray  *showArray;
@end

@implementation DetailWithDrawViewController
-(NSMutableArray *)showArray{
    if (!_showArray) {
        
        NSArray *arr=[Server shareInstance].suggest_words[@"transfer_request_notice"];
        _showArray=[[NSMutableArray alloc]initWithArray:arr];
        
    }
    return _showArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    if ([self.cantrayStr isEqualToString:@"1"]) {
        self.weiPayCantrayImageView.image=[UIImage imageNamed:@"my_banlance_weipay"];
        self.weipayCantaryLabel.text=@"微信";
        self.weipayNameLabel.text=@"用户标识  :";
        self.weipayAccountLabel.text=@"姓        名 :";
        self.weipayGrayLabel.text=@"推荐安装微信版本5.0以上使用";
        self.weiPaymoneyLabel.text=@"提现金额 :";
        self.nameTextField.enabled=NO;
        self.nameTextField.text=self.openId;
        self.accountTextField.placeholder=@"请输入真实姓名";
        
    }
     [self payNameTextField:self.nameTextField AndAccountField:self.accountTextField andMoneyTextfield:self.moneyTextField];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.detailTableView.tableHeaderView=self.detailHeaderView;
    self.detailTableView.tableFooterView=[[UIView alloc]init];
    self.detailTableView.estimatedRowHeight=25;
    self.detailTableView.backgroundColor=RGBHex(0xeeeeee);
    self.commitButton.layer.cornerRadius = 5;
    self.commitButton.layer.masksToBounds = YES;
    self.accountTextField.delegate=self;
    self.nameTextField.delegate=self;
    self.moneyTextField.delegate=self;
    self.declareLabel.text=[Server shareInstance].suggest_words[@"transfer_request"];
    
    self.moneyTextField.placeholder=[NSString stringWithFormat:@"可提现金额%@元",self.moneyStr];
    
    if ([self.cantrayStr isEqualToString:@"1"]){
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEdit:)
                                                name:@"UITextFieldTextDidChangeNotification" object:self.accountTextField];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeButton:)
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:self.moneyTextField
         ];

    }else{
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEdit:)
                                                name:@"UITextFieldTextDidChangeNotification" object:self.nameTextField];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeButton:)
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:self.accountTextField
         ];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeButton:)
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:self.moneyTextField
         ];

    }
    
}
-(void)changeButton:(NSNotification *)obj{
     [self payNameTextField:self.nameTextField AndAccountField:self.accountTextField andMoneyTextfield:self.moneyTextField];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
     [self payNameTextField:self.nameTextField AndAccountField:self.accountTextField andMoneyTextfield:self.moneyTextField];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self payNameTextField:self.nameTextField AndAccountField:self.accountTextField andMoneyTextfield:self.moneyTextField];
}

-(void)payNameTextField :(UITextField *)nameTextField AndAccountField:(UITextField *)accountField andMoneyTextfield:(UITextField*)moneyTextField{
    
    if (nameTextField.text.length==0||accountField.text.length==0||moneyTextField.text.length==0) {
        self.commitButton.enabled=NO;
        self.commitButton.backgroundColor=RGBHex(0xfcb5b3);
 
        
    }else{
        self.commitButton.enabled=YES;
        self.commitButton.backgroundColor=RGBHex(0xdb413c);

    }
}
-(void)textFiledEdit:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    DLog(@"+++++++++++++++++++++++%@",lang);
    if ([lang isEqualToString:@"zh-Hans"]||[lang isEqualToString:@"zh-Hant"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写zh-Hant（繁体中午）
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 6) {
                textField.text = [toBeString substringToIndex:6];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > 6) {
            textField.text = [toBeString substringToIndex:6];
        }
    }
    [self payNameTextField:self.nameTextField AndAccountField:self.accountTextField andMoneyTextfield:self.moneyTextField];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                    name:@"UITextFieldTextDidChangeNotification"
                    object:self.nameTextField];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                    name:@"UITextFieldTextDidChangeNotification"
                    object:self.accountTextField];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
        static NSString *CellIdentifier = @"DetailWithDrawCell";
        DetailWithDrawCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DetailWithDrawCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

        cell.drawLabel.text=[NSString stringWithFormat:@"%ld、%@",indexPath.row +1,self.showArray[indexPath.row]];
        return cell ;
   }

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
     headerView.backgroundColor=RGBHex(0xeeeeee);
    UILabel *sectionHeaderLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 20)];
    sectionHeaderLabel.text=@"提现说明";
    sectionHeaderLabel.textColor=RGBHex(0x666666);
    sectionHeaderLabel.font=[UIFont systemFontOfSize:12.0];
    [headerView addSubview:sectionHeaderLabel];
    return headerView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return 4;
}
- (IBAction)commitAction:(id)sender {
    if ([self.cantrayStr isEqualToString:@"1"]){
        [self getgetMoneyFromWeiXinPay];
        
    }else{
        [self getMoneyFromAlipay];
    }
}
#pragma 支付宝提现
-(void)getMoneyFromAlipay{
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (![reach isReachable]) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"请检查网络设置"];
        [alertView showTarget:self];
        return;
        
    }
    if (self.nameTextField.text.length==0||self.accountTextField.text.length==0||self.moneyTextField.text.length==0) {
        
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了" message:@"请补充内容"];
        [alertView showTarget:self.self.navigationController];
        
        return;
    }
    int A =[self.moneyStr doubleValue]*100;
    int B=[self.moneyTextField.text doubleValue]*100;
    
    DLog(@"金额%@",[Server shareInstance].transfer_min_amount);
    
    int C=[[Server shareInstance].transfer_min_amount  intValue];
    if (B<C) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了" message:@"提现余额不低于2元"];
        [alertView showTarget:self.navigationController];
        
        return;
    }
    
    if (A<B) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了" message:@"提现余额不足"];
        [alertView showTarget:self.navigationController];
        
        return;
    }
     [MBProgressHUD showMessag:@"" toView:self.view];
    NSMutableDictionary *headerDic=[[NSMutableDictionary alloc]init];
    headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
    NSMutableDictionary *bodyDic  = [[NSMutableDictionary alloc]init];
    bodyDic[@"pay_type"]          = @"2";
    bodyDic[@"action"]            = @"REQUEST_WITH_DRAW";
    bodyDic[@"ext_id"]            =self.accountTextField.text;
    bodyDic[@"ext_name"]          =self.nameTextField.text;
    double amountVlue=[self.moneyTextField.text floatValue]*100;
    
    bodyDic[@"amount"]=[NSString stringWithFormat:@"%f",amountVlue];
    
    HttpRequest *request          = [[HttpRequest alloc] init];
    request.isVlaueKey            = YES;
    [request Method:POST withTransmitHeader:headerDic withApiProgram:nil withBodyProgram:bodyDic withPathApi:PostFinanceTransfer completed:^(id data, NSString *stringData) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[WithDrawMoeyViewController class]]) {
                WithDrawMoeyViewController *revise =(WithDrawMoeyViewController *)controller;
                [self.navigationController popToViewController:revise animated:YES];
            }
        }

        
    } failed:^(RAError *error) {
      [MBProgressHUD hideHUDForView:self.view animated:YES];
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了" message:error.errorDetail];
        [alertView showTarget:self.tabBarController];

    }];

}
#pragma 微信提现
-(void)getgetMoneyFromWeiXinPay{
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (![reach isReachable]) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"请检查网络设置"];
        [alertView showTarget:self];
        return;
        
    }
    
    if (self.nameTextField.text.length==0||self.accountTextField.text.length==0) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了" message:@"请补充内容"];
        [alertView showTarget:self.self.navigationController];
        return;
    }
    int A =[self.moneyStr doubleValue]*100;
    int B=[self.moneyTextField.text doubleValue]*100;
    
    int C=[[Server shareInstance].transfer_min_amount  intValue];
    
    if (B<C) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了" message:@"提现余额不低于2元"];
        [alertView showTarget:self.navigationController];
        
        return;
    }
    if (A<B) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了" message:@"提现余额不足"];
        [alertView showTarget:self.self.navigationController];
        
        return;
    }
     [MBProgressHUD showMessag:@"" toView:self.view];
    NSMutableDictionary *headerDic=[[NSMutableDictionary alloc]init];
    headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
    NSMutableDictionary *bodyDic=[[NSMutableDictionary alloc]init];
    bodyDic[@"pay_type"]=@"1";
    bodyDic[@"action"]=@"REQUEST_WITH_DRAW";
    bodyDic[@"ext_id"]=self.nameTextField.text;
    bodyDic[@"ext_name"]=self.accountTextField.text;
//    bodyDic[@"amount"]=[NSString stringWithFormat:@"%@00",self.moneyTextField.text];
    
    double amountVlue=[self.moneyTextField.text floatValue]*100;
    
    bodyDic[@"amount"]=[NSString stringWithFormat:@"%f",amountVlue];

    HttpRequest *request = [[HttpRequest alloc] init];
    request.isVlaueKey = YES;
    [request Method:POST withTransmitHeader:headerDic withApiProgram:nil withBodyProgram:bodyDic withPathApi:PostFinanceTransfer completed:^(id data, NSString *stringData) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[WithDrawMoeyViewController class]]) {
                WithDrawMoeyViewController *revise =(WithDrawMoeyViewController *)controller;
                [self.navigationController popToViewController:revise animated:YES];
            }
        }
        
        
    } failed:^(RAError *error) {
  [MBProgressHUD hideHUDForView:self.view animated:YES];
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了" message:error.errorDetail];
        [alertView showTarget:self.self.navigationController];
        
    }];
 
}
@end
