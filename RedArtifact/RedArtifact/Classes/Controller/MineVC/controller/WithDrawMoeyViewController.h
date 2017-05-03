//
//  WithDrawMoeyViewController.h
//  RedArtifact
//
//  Created by LiLu on 16/9/18.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "RAUserInfo.h"
@interface WithDrawMoeyViewController : BaseViewController
@property (nonatomic,strong) RAUserInfo * withDrawUserInfo;// 认证状态
@property (weak, nonatomic) IBOutlet UILabel *myBlanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *AliPayButton;
- (IBAction)AliPayAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *WeiPayButton;
- (IBAction)WeiPayAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;

@end
