//
//  QuickLoginViewController.h
//  RedArtifact
//
//  Created by LiLu on 16/8/22.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuickLoginViewController : UIViewController<UITextFieldDelegate,AlertViewSureDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *phoneIconImageView;


@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UIView *veryView;
@property (weak, nonatomic) IBOutlet UITextField *identifyingTextField;

@property (weak, nonatomic) IBOutlet UIButton *identifyingButton;
- (IBAction)dentifyingAction:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)loginAction:(id)sender;

- (IBAction)aggrementAction:(id)sender;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBackgroundLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoTopLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewLayout;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verLayout;
- (IBAction)doBack:(id)sender;


@end
