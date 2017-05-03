//
//  PersonCenterViewController.h
//  RedArtifact
//
//  Created by LiLu on 16/9/13.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RAUserInfo.h"
@interface PersonCenterViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,AlertViewSureDelegate>

@property (weak, nonatomic) IBOutlet UITableView *personCenterTableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic,strong) RAUserInfo *nowUserInfo;
- (IBAction)cancelAction:(id)sender;
- (IBAction)cirfimAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *aboveDataView;
@property (weak, nonatomic) IBOutlet UIDatePicker *birthdayDataPicker;
@property (weak, nonatomic) IBOutlet UIImageView *userinfoImageView;

@end
