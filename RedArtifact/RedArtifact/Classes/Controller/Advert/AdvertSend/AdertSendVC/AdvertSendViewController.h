//
//  AdvertSendViewController.h
//  RedArtifact
//
//  Created by LiLu on 16/8/29.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRPlaceholderTextView.h"
#import "RAAdvert.h"
#import "AdvertMineViewController.h"
@interface AdvertSendViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) AdvertMineStatus jianlinsSatus;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, copy) NSString *adv_id;

@property (nonatomic, assign) RAAdvert *advert;

@property (weak, nonatomic) IBOutlet BRPlaceholderTextView *detailTextView;

@property(strong,nonatomic)UITableView *advertSendTableview;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@property (strong, nonatomic) IBOutlet UIView *adverMiddleView;
@property (strong, nonatomic) IBOutlet UIView *adverBottomView;

- (IBAction)nextCreatAdverID:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailHeightLayout;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *webClikNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *webClickUrlTextField;

@property (weak, nonatomic) IBOutlet UIButton *searchAddressButton;
- (IBAction)searchAddressAction:(id)sender;


@end
