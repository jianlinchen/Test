//
//  RedPacketSetViewController.h
//  RedArtifact
//
//  Created by LiLu on 16/8/30.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^BackAdId) (NSString *advId,NSString *startStr,NSString *endStr);

@interface RedPacketSetViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UITextFieldDelegate,AlertViewSureDelegate>

@property (nonatomic,strong) NSString *imgUrl;
/// 广告标题
@property (nonatomic,strong) NSString *advertTitle;

@property (copy,nonatomic) BackAdId BackId;
@property (weak, nonatomic) IBOutlet UILabel *rangCountLabel;

@property (nonatomic,assign) BOOL haveValue;
@property (nonatomic,strong) NSString *adv_id;//广告ID;

@property (nonatomic,strong) NSString *passStartTimeStr;//;

@property (nonatomic,strong) NSString *passEndtTimeStr;//;

@property (weak, nonatomic) IBOutlet UITableView *redPacketTableView;

@property (strong, nonatomic) IBOutlet UIView *redPacketTableHeaderView;
- (IBAction)startTimeAction:(id)sender;
- (IBAction)endTimeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *startTimeButton;

@property (weak, nonatomic) IBOutlet UIButton *endTimeButton;
- (IBAction)cancelAction:(id)sender;
- (IBAction)cirfimAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *popupView;
- (IBAction)readAction:(id)sender;
- (IBAction)saveDraft:(id)sender;
- (IBAction)commitAction:(id)sender;
- (IBAction)goToMapView:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *oneAmountTextField;
@property (weak, nonatomic) IBOutlet UITextField *oneMoneyTextField;

@property (weak, nonatomic) IBOutlet UITextField *twoAmountTextField;

@property (weak, nonatomic) IBOutlet UITextField *twoMoneyTextField;
@property (weak, nonatomic) IBOutlet UITextField *threeAmountTextField;
@property (weak, nonatomic) IBOutlet UITextField *threeMoneyTextField;
@property (weak, nonatomic) IBOutlet UILabel *overPlusLabel;
@property (weak, nonatomic) IBOutlet UITextField *allAmountTextField;

@end
