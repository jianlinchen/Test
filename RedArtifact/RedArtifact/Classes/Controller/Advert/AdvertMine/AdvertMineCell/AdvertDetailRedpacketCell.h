//
//  AdvertDetailRedpacketCell.h
//  RedArtifact
//
//  Created by xiaoma on 16/9/1.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RARedpacket.h"

@interface AdvertDetailRedpacketCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *prize_top_numLabel;
@property (weak, nonatomic) IBOutlet UILabel *prize_top_per_moneyyLabel;
@property (weak, nonatomic) IBOutlet UILabel *prize_second_numLabel;
@property (weak, nonatomic) IBOutlet UILabel *prize_second_per_moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *prize_third_numLabel;
@property (weak, nonatomic) IBOutlet UILabel *prize_third_per_moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *prize_consolation_numLabel;
@property (weak, nonatomic) IBOutlet UILabel *prize_consolation_per_moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *prize_total_numLabel;
@property (weak, nonatomic) IBOutlet UILabel *prize_total_moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *prize_server_moneyLabel;

- (void)initRedpacketData:(RARedpacket *)redpacket;
@end
