//
//  PaymentBanlanceCell.h
//  RedArtifact
//
//  Created by LiLu on 16/9/18.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RABlanceBarGain.h"
@interface PaymentBanlanceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
-(void)get:(RABlanceBarGain *)bargainModel;
@end
