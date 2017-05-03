//
//  RedPacketSetViewController.m
//  RedArtifact
//
//  Created by LiLu on 16/8/30.
//  Copyright © 2016年 jianlin. All rights reserved.
//
#import "UIViewExt.h"
#import "RedPacketSetViewController.h"
#import "RedPacketTableCell.h"
#import "UUDatePicker.h"
#import "NSDate+RADate.h"
#import "MapRangeViewController.h"
#import "PayMoneyViewController.h"
#import "MapLocation.h"
//#import "RedpackViewController.h"
#import "RedpackDetailViewController.h"
#import "JIanlinBonus.h"

#import "TestView.h"
@interface RedPacketSetViewController ()<UUDatePickerDelegate>{
    
    int            selectDex;    //判断时间选择器是哪个
    NSString *     timeStartStr;   //显示开始时间的字符串
    NSString *     timeEndStr;   //显示结束时间的字符串
    NSDate   *     scrollStartDate;   //显示开始时间的字符串
    NSDate   *     scrollEndDate;   //显示结束时间的字符串
     TestView *testVW;
     TestView *testVW2;
     TestView *testVW3;
  
}
//@property (nonatomic,strong) TestView *testVW;
/**
 *  主要判断返回地址范围的数组
 */
@property (nonatomic,strong) NSMutableArray  *backAddressArray;
/**
 *  时间选择器
 */
@property (nonatomic,strong) UUDatePicker    *datePicker;
/**
 *  黑色透明度背景view
 */
@property (nonatomic,strong) UIView          *bgView;
@property (nonatomic,strong) NSString        *latStr;
@property (nonatomic,strong) NSString        *lngStr;

@end

@implementation RedPacketSetViewController

-(NSMutableArray *)backAddressArray{
    if (!_backAddressArray) {
        _backAddressArray=[[NSMutableArray alloc]init];
    }
    return _backAddressArray;
}

-(UIView *)bgView{
    
    if (!_bgView) {
        _bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KScreenHeight)];
        _bgView.backgroundColor=[UIColor blackColor];
        _bgView.alpha=0.4;
        UITapGestureRecognizer* singleRecognizer= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
        singleRecognizer.delegate=self;
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        
        [_bgView addGestureRecognizer:singleRecognizer];
        
    }
    return _bgView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"红包设置";
    self.redPacketTableView.backgroundColor=RGBHex(0xeeeeee);
    self.redPacketTableView.tableHeaderView=self.redPacketTableHeaderView;
    self.redPacketTableView.estimatedRowHeight = 100;
    self.allAmountTextField.delegate=self;
    self.oneAmountTextField.delegate=self;
    self.twoAmountTextField.delegate=self;
    self.threeAmountTextField.delegate=self;
    self.latStr=@"1";
    self.lngStr=@"1";
    [self getLoactionDoubleStr];
    [self updateShow];
    [self getRangeTransitionArray];
    [self getRedBounceData];
    [self getNav];

    NSString * firstStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"RedPacket"];
    if (![firstStr isEqualToString:@"isFirst"]) {
        [self addNewPersonImageView];
        [[NSUserDefaults standardUserDefaults]setObject:@"isFirst"forKey:@"RedPacket"];
    }


}

-(void)addNewPersonImageView{
  testVW = [[TestView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KScreenHeight)];
  testVW.backgroundColor = [UIColor clearColor];
  testVW.opaque =NO;
  UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTestView:)];
  [testVW addGestureRecognizer:singleTap];
    
    testVW.needRect=CGRectMake(0, 120, kScreenWidth, 50);
    UIImageView *naImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 220, kScreenWidth, 80)];
    naImageView.center=CGPointMake(kScreenWidth/2, 220);
    naImageView.image=[UIImage imageNamed:@"advert_sendRange"];
      naImageView.contentMode=UIViewContentModeCenter;
    [testVW addSubview:naImageView];
    [self.navigationController.view addSubview:testVW];
    
}
// 时间
-(void)handleTestView:(UITapGestureRecognizer*)recognizer
{
    //处理单击操作
    [testVW removeFromSuperview];
    testVW2 = [[TestView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KScreenHeight)];
    testVW2.backgroundColor = [UIColor clearColor];
    testVW2.opaque =NO;
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTestView2:)];
    [testVW2 addGestureRecognizer:singleTap];
    testVW2.needRect=CGRectMake(0, 170, kScreenWidth, 146);
    UIImageView *naImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 200, kScreenWidth, 80)];
      naImageView.contentMode=UIViewContentModeCenter;
    naImageView.center=CGPointMake(kScreenWidth/2, 380);
    naImageView.image=[UIImage imageNamed:@"advert_sendTime"];
    [testVW2 addSubview:naImageView];
    [self.navigationController.view addSubview:testVW2];

}
// 红包个数
-(void)handleTestView2:(UITapGestureRecognizer*)recognizer
{
    //处理单击操作
    [testVW removeFromSuperview];
    [testVW2  removeFromSuperview];
    testVW3 = [[TestView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KScreenHeight)];
    testVW3.backgroundColor = [UIColor clearColor];
    testVW3.opaque =NO;
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTestView3:)];
    [testVW3 addGestureRecognizer:singleTap];
    testVW3.needRect=CGRectMake(0, 305, kScreenWidth, 100);
    UIImageView *naImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 220, kScreenWidth, 80)];
    naImageView.center=CGPointMake(kScreenWidth/2, 240);
    naImageView.image=[UIImage imageNamed:@"advert_sendPAcket"];
      naImageView.contentMode=UIViewContentModeCenter;
    [testVW3 addSubview:naImageView];
    [self.navigationController.view addSubview:testVW3];
}
-(void)handleTestView3:(UITapGestureRecognizer*)recognizer
{
    [testVW removeFromSuperview];
    [testVW2  removeFromSuperview];
    [testVW3  removeFromSuperview];
}


-(void)getNav{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-black-return-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}
-(void)back{
   
    NSString *dateStr1=[NSDate stringFromDate:scrollStartDate withDateFormatter:@"yyyy-MM-dd HH:00"];
    
    NSString *dateStr2=[NSDate stringFromDate:scrollEndDate withDateFormatter:@"yyyy-MM-dd HH:00"];
    
    NSString *timeSp1 = [NSDate intervalTimeWithTimeString:dateStr1 withDateFormatter:nil ]; //时间戳的值
    
    NSString *timeSp2 = [NSDate intervalTimeWithTimeString:dateStr2 withDateFormatter:nil ]; //时间戳的值
    
    [self.navigationController popViewControllerAnimated:YES];
    if (self.BackId) {
        self.BackId(self.adv_id,timeSp1,timeSp2);
    }
}

#pragma  获取广告红包设置内容
-(void)getRedBounceData{
    NSMutableDictionary *headerDic = [[NSMutableDictionary alloc]init];
    headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
    headerDic[@"IDENTITY"] = @"PRODUCER";
    NSMutableDictionary *apiDic = [[NSMutableDictionary alloc]init];
    apiDic[@"adv_id"] = self.adv_id;
    
    [GLOBLHttp Method:GET withTransmitHeader:headerDic withApiProgram:apiDic withBodyProgram:nil withPathApi:PostSenderAdvertisementBonus completed:^(id data, NSString *stringData) {
        
        NSDictionary *dic=data;
        JIanlinBonus *bonus=[JIanlinBonus mj_objectWithKeyValues:dic[@"data"][@"info"]];
        
        // 总个数
        if ([bonus.prize_total_num isEqualToString:@"0"]) {
             self.allAmountTextField.text=@"";
        }else{
             self.allAmountTextField.text=bonus.prize_total_num;
        }
       
        // 一等奖
        if ([bonus.prize_top_num isEqualToString:@"0"]) {
             self.oneAmountTextField.text=@"";
        }else{
            self.oneAmountTextField.text=bonus.prize_top_num;
        }
        
        if ([bonus.prize_top_per_money isEqualToString:@"0"]) {
            self.oneMoneyTextField.text=@"";
        }else{
            self.oneMoneyTextField.text=[NSString setNumLabelWithStr: bonus.prize_top_per_money];
        }
        
        //二等
        if ([bonus.prize_second_num isEqualToString:@"0"]) {
            self.twoAmountTextField.text=@"";
        }else{
            self.twoAmountTextField.text=bonus.prize_second_num;
        }
        
        if ([bonus.prize_second_per_money isEqualToString:@"0"]) {
            self.twoMoneyTextField.text=@"";
        }else{
            self.twoMoneyTextField.text=[NSString setNumLabelWithStr:bonus.prize_second_per_money];
        }
      //三等
        
        if ([bonus.prize_third_num isEqualToString:@"0"]) {
            self.threeAmountTextField.text=@"";
        }else{
            self.threeAmountTextField.text=bonus.prize_third_num;
        }
        
        if ([bonus.prize_third_per_money isEqualToString:@"0"]) {
            self.threeMoneyTextField.text=@"";
        }else{
            self.threeMoneyTextField.text=[NSString setNumLabelWithStr:bonus.prize_third_per_money];
        }
        
        [self zero:self.allAmountTextField one:self.oneAmountTextField two:self.twoAmountTextField three:self.threeAmountTextField ];

    } failed:^(RAError *error) {
        
    }];

}
-(void)getRangeTransitionArray{
    
    NSMutableDictionary *headerDic = [[NSMutableDictionary alloc]init];
    headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
    headerDic[@"IDENTITY"] = @"PRODUCER";
    NSMutableDictionary *apiDic = [[NSMutableDictionary alloc]init];
    apiDic[@"adv_id"] = self.adv_id;
    
    [GLOBLHttp Method:GET withTransmitHeader:headerDic withApiProgram:apiDic withBodyProgram:nil withPathApi:PostRangMap completed:^(id data, NSString *stringData) {
//        NSLog(@"+++++++++++%@",data);
//        
        NSMutableDictionary *dic=data;
        NSArray *getArray=dic[@"data"][@"list"];
        [self.backAddressArray addObjectsFromArray:getArray];
        
        if (self.backAddressArray.count==0) {
            self.rangCountLabel.text=@"点击这里即可投放三个目标";
        }else if (self.backAddressArray.count==1){
            self.rangCountLabel.text=@"您已投放一个目标";
        }else if (self.backAddressArray.count==2){
            self.rangCountLabel.text=@"您已投放两个个目标";
        }else if (self.backAddressArray.count==3){
            self.rangCountLabel.text=@"您已投放三个个目标";
        }
        
    } failed:^(RAError *error) {
        
    }];
 
    
}
#pragma 更新时间显示
-(void)updateShow{
    if ([self.passEndtTimeStr isEqualToString:@"0"]) {
        [self.endTimeButton setTitle:@"未添加" forState:UIControlStateNormal];
        [self.endTimeButton setTitleColor:RGBHex(0x666666) forState:UIControlStateNormal];
    }else{
        
        NSString *btnStr= [NSDate dateWithTimeIntervalString:self.passEndtTimeStr withDateFormatter:@"yyyy-MM-dd HH:00"];
       
        scrollEndDate=[NSDate dateFromString:btnStr withDateFormatter:@"yyyy-MM-dd HH:00"];
        [self.endTimeButton setTitle :btnStr forState:UIControlStateNormal];
        
    }
    
    if ([self.passStartTimeStr isEqualToString:@"0"]) {
        [self.startTimeButton setTitle:@"未添加" forState:UIControlStateNormal];
        [self.startTimeButton setTitleColor:RGBHex(0x666666) forState:UIControlStateNormal];
    }else{
        NSString *btnStr= [NSDate dateWithTimeIntervalString:self.passStartTimeStr withDateFormatter:@"yyyy-MM-dd HH:00"];
        scrollStartDate=[NSDate dateFromString:btnStr withDateFormatter:@"yyyy-MM-dd HH:00"];
        [self.startTimeButton setTitle :btnStr forState:UIControlStateNormal];
        
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"RedPacketTableCell";
    RedPacketTableCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RedPacketTableCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
    }
    return cell  ;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (IBAction)startTimeAction:(id)sender {
    [self.allAmountTextField resignFirstResponder];
    [self.oneAmountTextField resignFirstResponder];
    [self.oneMoneyTextField resignFirstResponder];
    [self.twoAmountTextField resignFirstResponder];
    [self.twoMoneyTextField resignFirstResponder];
    [self.threeAmountTextField resignFirstResponder];
    [self.threeMoneyTextField resignFirstResponder];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH"];
    NSString *reportDate = [format stringFromDate:[NSDate date]];
    NSDate *date = [format dateFromString:reportDate];
    NSDate *newDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date timeIntervalSinceReferenceDate] + 3600)];
    self.datePicker =[[UUDatePicker alloc]initWithframe:CGRectMake(0, 60, SCREEN_WIDTH, 120)
                                               Delegate:self
                                            PickerStyle:UUDateStyle_YearMonthDayHourMinute];
    
    
     NSTimeInterval time=[scrollStartDate timeIntervalSinceDate:newDate];
    
      int pTime=(int)time;
    
    [self.view addSubview:self.bgView];
    selectDex=0;
    [self.popupView setFrame:CGRectMake(0,  KScreenHeight-244, kScreenWidth, 180)];
    
    if (pTime>0) {
        self.datePicker.ScrollToDate=scrollStartDate;
    }else{
        self.datePicker.ScrollToDate=newDate;
       }
    
    self.datePicker.minLimitDate =newDate;

    [self.popupView addSubview:self.datePicker];
    
    [self.view addSubview:self.popupView];
}

- (IBAction)endTimeAction:(id)sender {
    [self.allAmountTextField resignFirstResponder];
    [self.oneAmountTextField resignFirstResponder];
    [self.oneMoneyTextField resignFirstResponder];
    [self.twoAmountTextField resignFirstResponder];
    [self.twoMoneyTextField resignFirstResponder];
    [self.threeAmountTextField resignFirstResponder];
    [self.threeMoneyTextField resignFirstResponder];
    [self.view addSubview:self.bgView];
    selectDex=1;
    [self.popupView setFrame:CGRectMake(0,  KScreenHeight-244, kScreenWidth, 180)];
    
    self.datePicker =[[UUDatePicker alloc]initWithframe:CGRectMake(0, 60, SCREEN_WIDTH, 120)
                                           Delegate:self
                                        PickerStyle:UUDateStyle_YearMonthDayHourMinute];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH"];
    NSString *reportDate    = [format stringFromDate:[NSDate date]];
    NSDate *date            = [format dateFromString:reportDate];
    NSDate *newDate         = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date timeIntervalSinceReferenceDate] + 3600*2)];
    
        NSTimeInterval time=[scrollEndDate timeIntervalSinceDate:newDate];
    
     int pTime=(int)time;
    
    if (pTime>0) {
        self.datePicker.ScrollToDate=scrollEndDate;
    }else{
        self.datePicker.ScrollToDate=newDate;
    }
    
    self.datePicker.minLimitDate =newDate;
    
    [self.popupView addSubview:self.datePicker];
    [self.view addSubview:self.popupView];
    
}

#pragma mark - UUDatePicker's delegate
- (void)uuDatePicker:(UUDatePicker *)datePicker
                year:(NSString *)year
               month:(NSString *)month
                 day:(NSString *)day
                hour:(NSString *)hour
              minute:(NSString *)minute
             weekDay:(NSString *)weekDay
{
    NSString *strTime=[NSString stringWithFormat:@"%@-%@-%@ %@",year,month,day,hour];
  
    NSString *formatStr=@"yyyy-MM-dd HH";
    
    if (selectDex==0) {
        scrollStartDate=[datePicker dateFromString:strTime withFormat:formatStr];
    }else{
        scrollEndDate=[datePicker dateFromString:strTime withFormat:formatStr];
    }
    
}
- (IBAction)cancelAction:(id)sender {
    [self removeView];
}

- (IBAction)cirfimAction:(id)sender {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:00"];
    NSString *reportDate = [format stringFromDate:[NSDate date]];
    NSDate *date = [format dateFromString:reportDate];
    NSDate *startDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date timeIntervalSinceReferenceDate] + 3600)];
    
    int starValue=[NSDate judgeSpace:scrollStartDate andNowDate:startDate];
    
    NSDate *endDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date timeIntervalSinceReferenceDate] + 3600*2)];
    
    
    int endValue=[NSDate judgeSpace:scrollEndDate andNowDate:endDate];
    
    NSDateFormatter *format1 = [[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"yyyy-MM-dd HH:00"];
    if (selectDex==0) {
        if (scrollStartDate==nil|| starValue<3600 ) {
            scrollStartDate=startDate;
        }
        NSString *str=[format stringFromDate:scrollStartDate];
        [self.startTimeButton setTitle:str forState:UIControlStateNormal];
        [self.startTimeButton setTitleColor:RGBHex(0xeb6564) forState:UIControlStateNormal];
    }else{
        if (scrollEndDate==nil||endValue <3600) {
            scrollEndDate=endDate;
        }
         [self.endTimeButton setTitleColor:RGBHex(0xeb6564) forState:UIControlStateNormal];
        NSString *str=[format stringFromDate:scrollEndDate];
        [self.endTimeButton setTitle:str forState:UIControlStateNormal];

    }
    [self removeView];
    
}
//处理单击操作
-(void)SingleTap:(UITapGestureRecognizer*)recognizer
{
    [self removeView];
}
-(void)removeView{
    [self.bgView removeFromSuperview];
    [self.datePicker removeFromSuperview];
   
    [self.popupView removeFromSuperview];
}


- (IBAction)readAction:(id)sender {
    RedpackDetailViewController *VC=[[RedpackDetailViewController alloc]init];
    VC.scanAdv_id=self.adv_id;
    VC.isScan=YES;
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)saveDraft:(id)sender {
    
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (![reach isReachable]) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"请检查网络设置"];
        [alertView showTarget:self];
        return;
        
    }
    
    //保存更新时间
    if (scrollStartDate!=nil||scrollEndDate!=nil) {
        [self saveDraftTime];
    }else{
        //保存更新红包设置
        if (self.allAmountTextField.text.length!=0||self.oneMoneyTextField.text.length!=0||self.oneAmountTextField.text.length!=0||self.twoMoneyTextField.text.length!=0||self.twoAmountTextField.text.length!=0||self.threeMoneyTextField.text.length!=0||self.threeAmountTextField.text.length!=0) {
            
            [self saveDraftPAcket];
        }
    }

    if (scrollStartDate==nil&&scrollEndDate==nil&&self.allAmountTextField.text.length==0&&self.oneMoneyTextField.text.length==0&&self.oneAmountTextField.text.length==0&&self.twoMoneyTextField.text.length==0&&self.twoAmountTextField.text.length==0&&self.threeMoneyTextField.text.length==0&&self.threeAmountTextField.text.length==0) {
        
    [[NSNotificationCenter defaultCenter] postNotificationName:BackAdvert object:@"支付失败"];      
        
    }
}
-(void)saveDraftPAcket{
    
    if (self.allAmountTextField.text.length==0) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"未添加派发总数" ];
        [alertView showTarget:self.navigationController];        return;
    }
    
    double oneMoney1    =[self.oneMoneyTextField.text     doubleValue]*100;
    
    NSString *str1=[NSString stringWithFormat:@"%f",oneMoney1];
    NSArray *array = [str1 componentsSeparatedByString:@"."]; //从字符A中分隔成2个元素的数组
    //    NSLog(@"+++++++++++%@",array[0]);
    int oneMoney =[array[0] intValue];
    
    double twoMoney2    =[self.twoMoneyTextField.text     doubleValue]*100;
    NSString *str2=[NSString stringWithFormat:@"%f",twoMoney2];
    NSArray *array2 = [str2 componentsSeparatedByString:@"."]; //从字符A中分隔成2个元素的数组
    
    int  twoMoney=[array2[0] intValue];
    
    double threeMoney3  =[self.threeMoneyTextField.text   doubleValue]*100;
    
    NSString *str3=[NSString stringWithFormat:@"%f",threeMoney3];
    NSArray *array3 = [str3 componentsSeparatedByString:@"."]; //从字符A中分隔成2个元素的数组
    
    int  threeMoney=[array3[0] intValue];
    
    
    
    int oneAmount     =[self.oneAmountTextField.text     intValue ];
    int twoAmount     =[self.twoAmountTextField.text     intValue];
    int threeAmount   =[self.threeAmountTextField.text   intValue];
    
    int allAmount     =[self.allAmountTextField.text    intValue];
    
    if (allAmount<oneAmount+twoAmount+threeAmount) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"派发总数与红包设置不匹配" ];
        [alertView showTarget:self.navigationController];
        return;
    }
    
    if ([self.oneMoneyTextField.text intValue]<1) {
        
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"单个红包不低于1元" ];
        [alertView showTarget:self.navigationController];
        return;
    }
    if (self.twoMoneyTextField.text.length!=0&&[self.twoMoneyTextField.text intValue]<1) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"单个红包不低于1元" ];
        [alertView showTarget:self.navigationController];
        return;
    }
    
    if (self.threeMoneyTextField.text.length!=0&&[self.threeMoneyTextField.text intValue]<1) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"单个红包不低于1元" ];
        [alertView showTarget:self.navigationController];
        return;
    }
    
    
    if (twoMoney!=0) {
        if (oneMoney <=twoMoney) {
            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"一等红包应大于二等红包" ];
            [alertView showTarget:self.navigationController];
            return;
        }
    }
    
    
    if (twoMoney==0&&threeMoney!=0) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"二等红包应大于三等红包" ];
        [alertView showTarget:self.navigationController];
        return;
    }
    
    if (threeMoney!=0 ) {
        if (twoMoney<=threeMoney) {
            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"二等红包应大于三等红包" ];
            [alertView showTarget:self.navigationController];
            return;
        }
    }
    
    if ((oneMoney!=0&&oneAmount==0)||(oneMoney==0&&oneAmount!=0)||(twoMoney!=0&&twoAmount==0)||(twoAmount==0&&twoMoney!=0)||(threeMoney!=0&&threeAmount==0)||(threeAmount==0&&threeMoney!=0)) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"派发总数与红包设置不匹配" ];
        [alertView showTarget:self.navigationController];
        return;
    }
    
    
    
    
    //判断无三等奖
    if ([self.threeMoneyTextField.text intValue]==0||[self.threeAmountTextField.text intValue]==0) {
        if ([self.allAmountTextField.text intValue]!=oneAmount+twoAmount+threeAmount) {
            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"派发总数与红包设置不匹配" ];
            [alertView showTarget:self.navigationController];
            //            [MBProgressHUD showError:@"出错了！红包个数设置错误" toView:self.view];
            
            return;
        }
    }
    
    // 判断有无二等奖
    if ([self.twoMoneyTextField.text intValue]==0||[self.twoAmountTextField.text intValue]==0) {
        if ([self.allAmountTextField.text intValue]!=oneAmount+twoAmount+threeAmount) {
            //            [MBProgressHUD showError:@"出错了！红包个数设置错误" toView:self.view];
            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"派发总数与红包设置不匹配" ];
            [alertView showTarget:self.navigationController];
            return;
        }
        
    }
    
    NSMutableDictionary *headerDic=[[NSMutableDictionary alloc]init];
    headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
    headerDic[@"IDENTITY"] =@"PRODUCER";
    
    
    NSMutableDictionary *programDic=[[NSMutableDictionary alloc]init];
    
    programDic[@"adv_id"] =self.adv_id;
    
    //一等
    programDic[@"prize_top_num"]     =[NSString stringWithFormat:@"%d",oneAmount];
    programDic[@"prize_top_per_money"] =[NSString stringWithFormat:@"%d",oneMoney];
    
    
    //二等
    programDic[@"prize_second_num"] =[NSString stringWithFormat:@"%d",twoAmount];
    
    if (self.twoMoneyTextField.text.length==0) {
        programDic[@"prize_second_per_money"] =@"0";
    }else{
        programDic[@"prize_second_per_money"] =[NSString stringWithFormat:@"%d",twoMoney];
    }
    
    
    //三等
    programDic[@"prize_third_num"]   =[NSString stringWithFormat:@"%d",threeAmount];
    
    if (self.threeMoneyTextField.text.length==0) {
        programDic[@"prize_third_per_money"] =@"0";
    }else{
        programDic[@"prize_third_per_money"] =[NSString stringWithFormat:@"%d",threeMoney];
    }
    // 总的红包个数
    
    programDic[@"prize_total_num"] =self.allAmountTextField.text;
    
    
    [GLOBLHttp Method:POST withTransmitHeader:headerDic withApiProgram:nil withBodyProgram:programDic withPathApi:PostSenderAdvertisementBonus completed:^(id data, NSString *stringData) {
//        NSLog(@"%@",stringData);
        
    [[NSNotificationCenter defaultCenter] postNotificationName:BackAdvert object:@"支付失败"];
    } failed:^(RAError *error) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:error.errorDetail ];
        [alertView showTarget:self.navigationController];
        
    }];
    
    
}
-(void)saveDraftTime{
    if (scrollStartDate==nil) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"未添加开始时间" ];
        [alertView showTarget:self.navigationController];
        
        return;
    }
    
    if (scrollEndDate==nil) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"未添加结束时间" ];
        [alertView showTarget:self.navigationController];
        
        return;
    }
    
    
    NSString *dateStr1=[NSDate stringFromDate:scrollStartDate withDateFormatter:@"yyyy-MM-dd HH:00"];
    
    NSString *dateStr2=[NSDate stringFromDate:scrollEndDate withDateFormatter:@"yyyy-MM-dd HH:00"];
    
    NSString *timeSp1 = [NSDate intervalTimeWithTimeString:dateStr1 withDateFormatter:nil ]; //时间戳的值
    
    NSString *timeSp2 = [NSDate intervalTimeWithTimeString:dateStr2 withDateFormatter:nil ]; //时间戳的值
    
    NSMutableDictionary *headerDic=[[NSMutableDictionary alloc]init];
    headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
    headerDic[@"IDENTITY"] =@"PRODUCER";
    
    
    NSMutableDictionary *programDic=[[NSMutableDictionary alloc]init];
    
    programDic[@"begin_time"]  =timeSp1;
    programDic[@"end_time"]    =timeSp2;
    programDic[@"adv_id"]      =self.adv_id;
    
    [GLOBLHttp Method:PUT withTransmitHeader:headerDic withApiProgram:nil withBodyProgram:programDic withPathApi:PublishAdDetail completed:^(id data, NSString *stringData) {
        
        if (self.allAmountTextField.text.length!=0||self.oneMoneyTextField.text.length!=0||self.oneAmountTextField.text.length!=0||self.twoMoneyTextField.text.length!=0||self.twoAmountTextField.text.length!=0||self.threeMoneyTextField.text.length!=0||self.threeAmountTextField.text.length!=0) {
            
            [self saveDraftPAcket];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:BackAdvert object:@"支付失败"];
        }
        
    } failed:^(RAError *error) {
        
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:error.errorDetail ];
        [alertView showTarget:self.navigationController];
        
        
    }];

    
}
//申请提交
- (IBAction)commitAction:(id)sender {
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (![reach isReachable]) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"请检查网络设置"];
        [alertView showTarget:self];
        return;
        
    }
    
    if ([self.latStr isEqualToString:@"0"]||[self.lngStr isEqualToString:@"0"]) {
        [self getLoactionDoubleStr];
        return;
    }
    if (self.backAddressArray.count==0) {
//        [MBProgressHUD showError:@"请选择目标范围" toView:self.view];
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"未添加投放目标" ];
        [alertView showTarget:self.navigationController];

        return;
    }
    [self updateTime];
}
#pragma 提交时间
-(void)updateTime{
  
    if (scrollStartDate==nil) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"未添加开始时间" ];
        [alertView showTarget:self.navigationController];

        return;
    }
    
    if (scrollEndDate==nil) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"未添加结束时间" ];
        [alertView showTarget:self.navigationController];
        
        return;
    }
    
    
    NSString *dateStr1=[NSDate stringFromDate:scrollStartDate withDateFormatter:@"yyyy-MM-dd HH:00"];
    
     NSString *dateStr2=[NSDate stringFromDate:scrollEndDate withDateFormatter:@"yyyy-MM-dd HH:00"];
    
    NSString *timeSp1 = [NSDate intervalTimeWithTimeString:dateStr1 withDateFormatter:nil ]; //时间戳的值
    
    NSString *timeSp2 = [NSDate intervalTimeWithTimeString:dateStr2 withDateFormatter:nil ]; //时间戳的值
    
    NSMutableDictionary *headerDic=[[NSMutableDictionary alloc]init];
    headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
    headerDic[@"IDENTITY"] =@"PRODUCER";
    
    
    NSMutableDictionary *programDic=[[NSMutableDictionary alloc]init];
    
    programDic[@"begin_time"]  =timeSp1;
    programDic[@"end_time"]    =timeSp2;
    programDic[@"adv_id"]      =self.adv_id;
    
    
    [MBProgressHUD showMessag:@"" toView:self.view];
    [GLOBLHttp Method:PUT withTransmitHeader:headerDic withApiProgram:nil withBodyProgram:programDic withPathApi:PublishAdDetail completed:^(id data, NSString *stringData) {
  
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self postPAcket];//调用红包设置接口
        
        
        NSLog(@"%@",stringData);
    } failed:^(RAError *error) {
      
    [MBProgressHUD hideHUDForView:self.view animated:YES];

        NSLog(@"广告更新失败哈哈哈哈哈哈 ");
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:error.errorDetail ];
        [alertView showTarget:self.navigationController];

        
    }];

}
#pragma 提交红包设置请求接口
-(void)postPAcket{
    
    if (self.allAmountTextField.text.length==0) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"未添加派发总数" ];
        [alertView showTarget:self.navigationController];
         [MBProgressHUD hideHUDForView:self.view animated:YES];

        return;
    }
    
    double oneMoney1    =[self.oneMoneyTextField.text     doubleValue]*100;
    
    NSString *str1=[NSString stringWithFormat:@"%f",oneMoney1];
    NSArray *array = [str1 componentsSeparatedByString:@"."]; //从字符A中分隔成2个元素的数组
//    NSLog(@"+++++++++++%@",array[0]);
    int oneMoney =[array[0] intValue];
    
    double twoMoney2    =[self.twoMoneyTextField.text     doubleValue]*100;
    NSString *str2=[NSString stringWithFormat:@"%f",twoMoney2];
    NSArray *array2 = [str2 componentsSeparatedByString:@"."]; //从字符A中分隔成2个元素的数组

    int  twoMoney=[array2[0] intValue];
    
    double threeMoney3  =[self.threeMoneyTextField.text   doubleValue]*100;
    
    NSString *str3=[NSString stringWithFormat:@"%f",threeMoney3];
    NSArray *array3 = [str3 componentsSeparatedByString:@"."]; //从字符A中分隔成2个元素的数组
    
    int  threeMoney=[array3[0] intValue];
    int oneAmount     =[self.oneAmountTextField.text     intValue ];
    int twoAmount     =[self.twoAmountTextField.text     intValue];
    int threeAmount   =[self.threeAmountTextField.text   intValue];
    
    int allAmount     =[self.allAmountTextField.text    intValue];
    
    if (allAmount<oneAmount+twoAmount+threeAmount) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"派发总数与红包设置不匹配" ];
        [alertView showTarget:self.navigationController];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }
    
    if ([self.oneMoneyTextField.text intValue]<1) {
        
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"单个红包不低于1元" ];
        [alertView showTarget:self.navigationController];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }
    if (self.twoMoneyTextField.text.length!=0&&[self.twoMoneyTextField.text intValue]<1) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"单个红包不低于1元" ];
        [alertView showTarget:self.navigationController];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }
    
    if (self.threeMoneyTextField.text.length!=0&&[self.threeMoneyTextField.text intValue]<1) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"单个红包不低于1元" ];
        [alertView showTarget:self.navigationController];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }
    
    
    if (twoMoney!=0) {
        if (oneMoney <=twoMoney) {
            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"一等红包应大于二等红包" ];
            [alertView showTarget:self.navigationController];
             [MBProgressHUD hideHUDForView:self.view animated:YES];
            return;
        }
    }

    
    if (twoMoney==0&&threeMoney!=0) {
            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"二等红包应大于三等红包" ];
            [alertView showTarget:self.navigationController];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
            return;
     }
    
    if (threeMoney!=0 ) {
        if (twoMoney<=threeMoney) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"二等红包应大于三等红包" ];
        [alertView showTarget:self.navigationController];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
         return;
      }
    }
    
    if ((oneMoney!=0&&oneAmount==0)||(oneMoney==0&&oneAmount!=0)||(twoMoney!=0&&twoAmount==0)||(twoAmount==0&&twoMoney!=0)||(threeMoney!=0&&threeAmount==0)||(threeAmount==0&&threeMoney!=0)) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"派发总数与红包设置不匹配" ];
        [alertView showTarget:self.navigationController];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }
    
    //判断无三等奖
    if ([self.threeMoneyTextField.text intValue]==0||[self.threeAmountTextField.text intValue]==0) {
        if ([self.allAmountTextField.text intValue]!=oneAmount+twoAmount+threeAmount) {
            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"派发总数与红包设置不匹配" ];
            [alertView showTarget:self.navigationController];
      [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            return;
        }
    }
    
    // 判断有无二等奖
    if ([self.twoMoneyTextField.text intValue]==0||[self.twoAmountTextField.text intValue]==0) {
        if ([self.allAmountTextField.text intValue]!=oneAmount+twoAmount+threeAmount) {
//            [MBProgressHUD showError:@"出错了！红包个数设置错误" toView:self.view];
            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"派发总数与红包设置不匹配" ];
            [alertView showTarget:self.navigationController];
             [MBProgressHUD hideHUDForView:self.view animated:YES];
            return;
        }
        
    }
   
    NSMutableDictionary *headerDic=[[NSMutableDictionary alloc]init];
    headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
    headerDic[@"IDENTITY"] =@"PRODUCER";
    
    
    NSMutableDictionary *programDic=[[NSMutableDictionary alloc]init];
    
    programDic[@"adv_id"] =self.adv_id;
    
    //一等
    programDic[@"prize_top_num"]     =[NSString stringWithFormat:@"%d",oneAmount];
    programDic[@"prize_top_per_money"] =[NSString stringWithFormat:@"%d",oneMoney];
    
    
    //二等
    programDic[@"prize_second_num"] =[NSString stringWithFormat:@"%d",twoAmount];
    
    if (self.twoMoneyTextField.text.length==0) {
        programDic[@"prize_second_per_money"] =@"0";
    }else{
        programDic[@"prize_second_per_money"] =[NSString stringWithFormat:@"%d",twoMoney];
    }
    
    
    //三等
    programDic[@"prize_third_num"]   =[NSString stringWithFormat:@"%d",threeAmount];
    
    if (self.threeMoneyTextField.text.length==0) {
        programDic[@"prize_third_per_money"] =@"0";
    }else{
        programDic[@"prize_third_per_money"] =[NSString stringWithFormat:@"%d",threeMoney];
    }
    // 总的红包个数
    
    
//    NSLog(@"%@",programDic);
    
    programDic[@"prize_total_num"] =self.allAmountTextField.text;
    [GLOBLHttp Method:POST withTransmitHeader:headerDic withApiProgram:nil withBodyProgram:programDic withPathApi:PostSenderAdvertisementBonus completed:^(id data, NSString *stringData) {
        
        NSLog(@"%@",data);
        
        [self SecondPOstCommit];// 提交接口
        
        NSLog(@"%@",stringData);
    } failed:^(RAError *error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error.code==60000035) {
          CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"未认证！" message:@"请打开“我的”->“个人中心”去完成实名认证"];
            [alertView showTarget:self.navigationController];
 
            
        }else{
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:error.errorDetail ];
        [alertView showTarget:self.navigationController];
            
        }
        
    }];
    
}
#pragma 提交接口
-(void)SecondPOstCommit{
    if ([self.lngStr isEqualToString:@"1"]||[self.latStr isEqualToString:@"1"]) {
        
        [self getLoactionDoubleStr];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
        
        
    }
    
    NSMutableDictionary *headerDic=[[NSMutableDictionary alloc]init];
    headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
    headerDic[@"IDENTITY"] =@"PRODUCER";
    NSMutableDictionary *programDic=[[NSMutableDictionary alloc]init];
    programDic[@"status"]    =@"submit";
    programDic[@"adv_id"]    =self.adv_id;
    programDic[@"lng"]       =self.lngStr;
    programDic[@"lat"]       =self.latStr;
    
    HttpRequest *request = [[HttpRequest alloc] init];
    request.isVlaueKey = YES;
    [request Method:POST withTransmitHeader:headerDic withApiProgram:nil withBodyProgram:programDic withPathApi:CommitAdvertisementStatus completed:^(id data, NSString *stringData) {
//        NSLog(@"%@",data);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *dic=data;
        NSString *moneyStr=[NSString stringWithFormat:@"%@" ,dic[@"data"][@"info"][@"bonus_total_amount"]];
        
        PayMoneyViewController *VC=[[PayMoneyViewController alloc]init];
        VC.adv_id=self.adv_id;
        VC.moneyStr=moneyStr;
        VC.shareImageURL=self.imgUrl;
        VC.shareSuccesssTitle=self.advertTitle;
        [self.navigationController pushViewController:VC animated:YES];
        
    } failed:^(RAError *error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error.code==60000035) {
            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"未认证！" message:@"请打开“我的”->“个人中心”去完成实名认证"];
            [alertView showTarget:self.navigationController];
            
            
        }else{
            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:error.errorDetail ];
            [alertView showTarget:self.navigationController];
            
        }
    }];
    
}
#pragma 计算剩余红包个数
- ( void )textFieldDidEndEditing:( UITextField *)textField

{
    [self zero:self.allAmountTextField one:self.oneAmountTextField two:self.twoAmountTextField three:self.threeAmountTextField ];
}

-(void)zero:(UITextField *)allamountTextField one:(UITextField *)oneAmountTextField two:(UITextField *)twoAmountField three :(UITextField *)threeAmountField  {
    
    int allAmount=[allamountTextField.text  intValue];
    int oneAmount=[oneAmountTextField.text  intValue];
    int twoAmount=[twoAmountField.text      intValue ];
    int threeAmount=[threeAmountField.text   intValue];
    
    int overPlusValue=allAmount -oneAmount-twoAmount-threeAmount;
    
    if (threeAmount==0||overPlusValue<0) {
        self.overPlusLabel.text=@"0";

    }else{
    self.overPlusLabel.text=[NSString stringWithFormat:@"%d",overPlusValue];
    }
}
#pragma 进入地图
- (IBAction)goToMapView:(id)sender {
    MapRangeViewController*VC=[[MapRangeViewController alloc]init];
    VC.adv_id=self.adv_id;
    VC.arrayBlock=^(NSMutableArray *addressArray){
        NSArray *arr=[addressArray copy];
        [self.backAddressArray removeAllObjects];
        [self.backAddressArray addObjectsFromArray:arr];
        
        if (self.backAddressArray.count==0) {
            self.rangCountLabel.text=@"点击这里即可投放三个目标";
        }else if (self.backAddressArray.count==1){
            self.rangCountLabel.text=@"您已投放一个目标";
        }else if (self.backAddressArray.count==2){
            self.rangCountLabel.text=@"您已投放两个目标";
        }else if (self.backAddressArray.count==3){
            self.rangCountLabel.text=@"您已投放三个目标";
        }
    };
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)getLoactionDoubleStr{
    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        
        CustomAlertView *alertView=[[CustomAlertView alloc]initWithTitle:@"请到手机设置中开启定位服务" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"设置"];
        alertView.delegate=self;
        
        [alertView showTarget:self.navigationController];
        
        return;
    }
    
    MapLocation *locationManager = [MapLocation sharedInstance];
    locationManager.isGeocoder = NO;
    
    [locationManager startGetLocation:^(CLLocationCoordinate2D currentCoordinate, double userLatitude, double userLongitude, NSString *city) {
        
         self.latStr = [NSString stringWithFormat:@"%f",userLatitude];
        
         self.lngStr=[NSString stringWithFormat:@"%f",userLongitude];
        
    } failureBlock:^(NSString *errorMsg, NSUInteger errorCode) {

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
