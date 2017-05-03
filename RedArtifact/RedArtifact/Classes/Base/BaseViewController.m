//
//  BaseViewController.m
//  RedArtifact
//
//  Created by LiLu on 16/7/25.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "BaseViewController.h"
#import "UIViewExt.h"

@interface BaseViewController(){
      UIView *noDataView;
}
@end
@implementation BaseViewController
- (void)showNoDataViewWithString:(NSString *)str andImage:(UIImage *)image{
    noDataView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth, KScreenHeight)];
    noDataView.backgroundColor = [UIColor whiteColor];
    [noDataView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(againRequest)]];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, kScreenWidth, 21)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHex:0x666666];
    if(str == nil){
        label.text = @"";
    }else{
        label.text = str;
    }
    label.font = [UIFont systemFontOfSize:15.0f];
    [noDataView addSubview:label];
    
    [self.view addSubview:noDataView];
    [self.view bringSubviewToFront:noDataView];
}
- (void)removeNoDataView{
  
    [noDataView removeFromSuperview];
}
-(void)againRequest{
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 设置header
    // 隐藏时间
    self.header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
//    self.header.stateLabel.hidden = YES;
}

- (void)loadNewData{
    
}
-(void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showUnauthorizedView:(NSString *)str andImage:(UIImage *)image andBool:(BOOL)isEnable{
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KScreenHeight-64)];
    bgView.backgroundColor=RGBHex(0xeeeeee);
    [self.view addSubview:bgView];
    
    //图片显示
    UIImageView *centerImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 120, 180, 180)];
    centerImage.center=CGPointMake(kScreenWidth/2, 120);
    centerImage.image=[UIImage imageNamed:@"my_Unauthorized"];
    centerImage.contentMode=UIViewContentModeCenter;
    [bgView addSubview:centerImage];
    
    
    // 上面文字显示
    UILabel *topLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-40, 30)];
    topLabel.center=CGPointMake(kScreenWidth/2,centerImage.bottom+20);
    topLabel.text=@"实名认证才可以提现哦";
    topLabel.textColor=RGBHex(0x999999);
    topLabel.textAlignment=NSTextAlignmentCenter;
    [bgView addSubview:topLabel];
    
    
    UILabel *bottomLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-40, 30)];
    bottomLabel.center=CGPointMake(kScreenWidth/2,topLabel.bottom+20);
    bottomLabel.text=@"快去实名认证吧";
    bottomLabel.textColor=RGBHex(0x999999);

    bottomLabel.textAlignment=NSTextAlignmentCenter;

    
    [bgView addSubview:bottomLabel];
    
    
    
    // button 按钮
    
    UIButton *goButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-120, 44)];
    goButton.center=CGPointMake(kScreenWidth/2,bottomLabel.bottom+45);
    [goButton setTitle:@"实名认证" forState: UIControlStateNormal];

    
    
    [goButton setTitleColor:RGBHex(0xdb413c) forState:UIControlStateNormal];
  
    
    goButton.layer.masksToBounds=YES;
    goButton.layer.cornerRadius=8.0f; //设置为图片宽度的一半出来为圆形
    goButton.layer.borderWidth=1.0f; //边框宽度
    goButton.layer.borderColor=[RGBHex(0x999999) CGColor];//
    
    
    if (isEnable==YES) {
        [goButton addTarget:self action:@selector(goVC) forControlEvents:UIControlEventTouchUpInside];
        }
    [bgView addSubview:goButton];
    
}
-(void)goVC
{
    
}

@end
