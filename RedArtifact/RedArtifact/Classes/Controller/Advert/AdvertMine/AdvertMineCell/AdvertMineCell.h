//
//  AdvertMineCell.h
//  RedArtifact
//
//  Created by xiaoma on 16/8/29.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvertMineCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusLabelConstraint;

@property (weak, nonatomic) IBOutlet UIButton *statusButton;

@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;

@property (weak, nonatomic) IBOutlet UILabel *advert_titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *advert_timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *advert_companyLabel;

@property (weak, nonatomic) IBOutlet UILabel *redpacket_amountLabel;

@end
