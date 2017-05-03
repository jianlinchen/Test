//
//  DetailWithDrawViewController.h
//  RedArtifact
//
//  Created by LiLu on 16/9/18.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApiManager.h"
@interface DetailWithDrawViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,WXApiManagerDelegate,UITextFieldDelegate>

@property (nonatomic,strong) NSString *moneyStr;//可提取金额

@property (weak, nonatomic) IBOutlet UILabel *declareLabel;

@property (nonatomic,strong) NSString *openId;
@property (nonatomic,strong) NSString *cantrayStr;
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (strong, nonatomic) IBOutlet UIView *detailHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *weipayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *weipayAccountLabel;

@property (weak, nonatomic) IBOutlet UILabel *weiPaymoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *weipayCantaryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weiPayCantrayImageView;

@property (weak, nonatomic) IBOutlet UILabel *weipayGrayLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
- (IBAction)commitAction:(id)sender;


@end
