//
//  QualificationViewController.h
//  RedArtifact
//
//  Created by LiLu on 16/9/13.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RAUserInfo.h"
@interface QualificationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) RAUserInfo *qualiRAUserInfo;

- (IBAction)personAction:(id)sender;
- (IBAction)companyAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *personButton;

@property (weak, nonatomic) IBOutlet UIButton *companyButton;
@property (strong, nonatomic) IBOutlet UIView *hederView;
@property (weak, nonatomic) IBOutlet UITableView *quanlificationTableView;

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberTextfield;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
- (IBAction)commitAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *mainTopView;
@property (strong, nonatomic) IBOutlet UIView *companyHeaderView;

@property (weak, nonatomic) IBOutlet UITextField *companyNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *companyNumberTextField;

@property (weak, nonatomic) IBOutlet UIImageView *companyTopImageView;


@property (weak, nonatomic) IBOutlet UIImageView *companyBottomImageView;

@property (weak, nonatomic) IBOutlet UIButton *companyCommitButton;

- (IBAction)commitCompanyAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *personOneHidenLabel;
@property (weak, nonatomic) IBOutlet UILabel *personTwoHidenLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyOneHidenLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyTwoHidenLabel;



@end
