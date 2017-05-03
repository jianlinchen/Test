//
//  PaySuccessAndShareVC.m
//  RedArtifact
//
//  Created by LiLu on 16/10/9.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "PaySuccessAndShareVC.h"
#import "PaySucessTableCell.h"
#import "Server.h"
#import "RAShare.h"

@interface PaySuccessAndShareVC ()

@end

@implementation PaySuccessAndShareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"支付结果";
    self.paySuceessTableView.bounces=NO;
    self.paySuceessTableView.tableHeaderView=self.paySucessHeader;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:self action:nil];
    self.backMyButton.layer.cornerRadius = 22;
    self.backMyButton.layer.masksToBounds = YES;
    
    self.shareButton.layer.masksToBounds=YES;
    self.shareButton.layer.cornerRadius=8.0f; //设置为图片宽度的一半出来为圆形
    self.shareButton.layer.borderWidth=1.0f; //边框宽度
    self.shareButton.layer.borderColor=[RGBHex(0xdb413c) CGColor];//边框颜色
    [self judgeSucessOrFaliure];
}

-(void)judgeSucessOrFaliure{
    
    if ([self.orSucessStr isEqualToString:@"支付失败"]) {
        self.orSuccessImageView.image=[UIImage imageNamed:@"send_pay_faliure"];
        self.orSucessLabel.text=@"支付失败";
        self.shareButton.hidden=YES;
        [self.backMyButton setTitle:@"重新支付" forState:UIControlStateNormal];
        self.backMyButton.backgroundColor=RGBHex(0x999999);
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    self.navigationItem.hidesBackButton = NO;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (kScreenWidth==320) {
        self.topLayout.constant=100;
    }

    self.navigationItem.hidesBackButton = YES;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"PaySucessTableCell";
    PaySucessTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaySucessTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    return cell;
    
}
- (IBAction)shareAction:(id)sender {
    
    Server *server = [Server shareInstance];
    if (server.promotion_share_info[@"content"]==nil) {
        [Tools getServerKeyConfig];
        return;
    }
    NSString *mbMonStr=[NSString setNumLabelWithStr:self.sharePrice];
    NSString *shareText   = @"分享内容";
    NSString *tempStr = server.description_on_pay_success;
    shareText = [tempStr stringByReplacingOccurrencesOfString:@"{BONUS_MONEY}" withString:mbMonStr];
    if (self.shareImageURL.length > 0) {
        
        [RAShare presentSnsIconSheetView:self shareTitle:self.shareSuccesssVcTitle shareText:shareText shareImage:self.shareImageURL shareLinkURL:server.share_link delegate:nil];
        
    } else {
        [RAShare presentSnsIconSheetView:self shareTitle:server.redpacket_share_title shareText:shareText shareImage:nil shareLinkURL:server.share_link delegate:nil];
    }
}
- (IBAction)backMyAdvertAction:(id)sender {
    if ([self.orSucessStr isEqualToString:@"支付失败"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:BackAdvert object:@"支付成功"];
    }
}
@end
