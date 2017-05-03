//
//  PayMoneyViewController.h
//  RedArtifact
//
//  Created by LiLu on 16/9/5.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayMoneyViewController : UIViewController
@property (nonatomic,strong) NSString *adv_id;
//支付金额
@property (nonatomic,strong) NSString *moneyStr;
//分享图片URL
@property (nonatomic, strong) NSString *shareImageURL;

// 分享成功的照片
@property (nonatomic, strong) NSString *shareSuccesssTitle;

@property (weak, nonatomic) IBOutlet UIImageView *rightAliPayImageView;

@property (weak, nonatomic) IBOutlet UIImageView *rightWeiXinImageView;
- (IBAction)cirfimPayAction:(id)sender;

- (IBAction)aliPAyAction:(id)sender;
- (IBAction)WeiXinPayAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *moenyLabel;
@property (weak, nonatomic) IBOutlet UIButton *cirButton;

@end
