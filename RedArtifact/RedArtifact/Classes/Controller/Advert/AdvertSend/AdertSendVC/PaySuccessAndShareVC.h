//
//  PaySuccessAndShareVC.h
//  RedArtifact
//
//  Created by LiLu on 16/10/9.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaySuccessAndShareVC : UIViewController<UITabBarDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSString *orSucessStr;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

- (IBAction)shareAction:(id)sender;
- (IBAction)backMyAdvertAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *backMyButton;
@property (weak, nonatomic) IBOutlet UITableView *paySuceessTableView;
@property (strong, nonatomic) IBOutlet UIView *paySucessHeader;
@property (weak, nonatomic) IBOutlet UIImageView *orSuccessImageView;
@property (weak, nonatomic) IBOutlet UILabel *orSucessLabel;

//付款金额
@property (nonatomic, copy) NSString *sharePrice;
//分享图片URL
@property (nonatomic, copy) NSString *shareImageURL;

@property (nonatomic,strong) NSString *shareSuccesssVcTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;

@end
