//
//  HomeTimerCell.h
//  RedArtifact
//
//  Created by xiaoma on 16/8/15.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JOINSuperbonusBlock)(BOOL isClick);

@interface HomeTimerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *day1Label;
@property (weak, nonatomic) IBOutlet UIButton *day2Label;
@property (weak, nonatomic) IBOutlet UIButton *hour1Label;
@property (weak, nonatomic) IBOutlet UIButton *hour2Label;
@property (weak, nonatomic) IBOutlet UIButton *minite1Label;
@property (weak, nonatomic) IBOutlet UIButton *minite2Label;
@property (weak, nonatomic) IBOutlet UIButton *second1Label;
@property (weak, nonatomic) IBOutlet UIButton *second2Label;

@property (weak, nonatomic) IBOutlet UILabel *bonus_moneyLabel;

@property (nonatomic, strong) JOINSuperbonusBlock joinblock;
@property (weak, nonatomic) IBOutlet UILabel *superbonus_titleLabel;

- (void)initWithServerCurrentTime:(NSString *)currentTime withSuperbonusBeginTime:(NSString *)beginTime withSuperbonusEndTime:(NSString *)endTime;

@end
