//
//  QRCodeViewController.m
//  advert_shop
//
//  Created by LiLu on 16/6/18.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "QRCodeViewController.h"
#import "QRCodeGenerator.h"
#import "Server.h"
#import "RAShare.h"
@interface QRCodeViewController (){
    NSString *qrImageurl;
}

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"申请推广";
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.masksToBounds = YES;
    self.personImageView.layer.masksToBounds=YES;
    self.personImageView.layer.cornerRadius=82/2.0f; //设置为图片宽度的一半出来为圆形
    self.personImageView.layer.borderWidth=1.0f; //边框宽度
    self.personImageView.layer.borderColor=[[UIColor whiteColor] CGColor];//边框颜色
    
    User *user = [User sharedInstance];
    [self.personImageView sd_setImageWithURL:[NSURL URLWithString:user.userAvatar ] placeholderImage:[UIImage imageNamed:@"person"]];
//    self.personImageView.layer.cornerRadius=82/2.0f; //设置为图片宽度的一半出来为圆形
//    self.personImageView.layer.borderWidth=1.0f; //边框宽度
//    self.personImageView.layer.borderColor=[[UIColor whiteColor] CGColor];//边框颜色
    self.nameLabel.text=self.nameStr;
    if (![[AppDelegate appDelegate].fmdbStore isTableExists:personCacheTableName]) {
        [[AppDelegate appDelegate].fmdbStore createTableWithName:personCacheTableName withComplete:^(RAError *error) {
            DLog(@"创建%@表成功",personCacheTableName);
        }];
    }


    [self getQrdata];
    [self setupNav];
    
    
    Server *server = [Server shareInstance];
    
//    NSString *shareText   = [NSString stringWithFormat:@"%@", server.promotion_share_info[@"content"]];
    if (server.promotion_share_info[@"content"]==nil) {
         [Tools getServerKeyConfig];
    }
    
    
}
#pragma 设置导航栏
-(void)setupNav
{
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,80,30)];
    [rightButton setTitle:@"分享" forState:UIControlStateNormal];
    [rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    rightButton.titleLabel.font=[UIFont systemFontOfSize :14.0];
    [rightButton addTarget:self action:@selector(clickQR)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    
}
-(void)clickQR{
    
    Server *server = [Server shareInstance];
    
     User *user = [User sharedInstance];
    
    
    NSString *shareText   = [NSString stringWithFormat:@"%@", server.promotion_share_info[@"content"]];
    
    NSString *titleStr=[NSString stringWithFormat:@"HI 朋友，快来加入{%@}的Team",user.nickName];
    qrImageurl=[NSString stringWithFormat:@"%@", server.promotion_share_info[@"image"]];
    
    if (qrImageurl.length > 0) {
        
        [RAShare presentSnsIconSheetView:self shareTitle:titleStr shareText:shareText shareImage:qrImageurl shareLinkURL:server.share_link delegate:nil];
        
    } else {
        [RAShare presentSnsIconSheetView:self shareTitle:server.redpacket_share_title shareText:shareText shareImage:nil shareLinkURL:server.share_link delegate:nil];
    }
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    if (kScreenWidth==320) {
        self.bgLayoutTop.constant=10;
        self.perImageViewTop.constant=10;
    }
    
}
-(void)getQrdata{
     [MBProgressHUD showMessag:@"" toView:self.view];
    NSMutableDictionary *program = [[NSMutableDictionary alloc] init];
    [program setValue:[User sharedInstance].accesstoken forKey:@"ACCESS-TOKEN"];
    [[HttpRequest shareInstance] Method:GET withTransmitHeader:program withApiProgram:nil withBodyProgram:nil withPathApi:GetPromotionMerchant completed:^(id data, NSString *stringData) {
        if (data) {
          
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        
          NSString *qrStr=[NSString stringWithFormat:@"%@" ,data[@"data"][@"promotion_link"]];
            // 可能有错误
            self.qrImageView.image = [QRCodeGenerator qrImageForString:qrStr imageSize: self.view.bounds.size.width];
            
        }
    } failed:^(RAError *error) {

      [MBProgressHUD hideHUDForView:self.view animated:YES];
  

    }];
    
}


@end
