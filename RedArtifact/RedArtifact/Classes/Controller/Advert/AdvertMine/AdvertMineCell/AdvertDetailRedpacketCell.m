//
//  AdvertDetailRedpacketCell.m
//  RedArtifact
//
//  Created by xiaoma on 16/9/1.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "AdvertDetailRedpacketCell.h"

@implementation AdvertDetailRedpacketCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}
- (void)initRedpacketData:(RARedpacket *)redpacket {
    if (redpacket) {
        self.prize_top_numLabel.text = redpacket.prize_top_num;
        self.prize_top_per_moneyyLabel.text = [NSString setNumLabelWithStr:redpacket.prize_top_per_money];
        self.prize_second_numLabel.text = redpacket.prize_second_num;
        self.prize_second_per_moneyLabel.text = [NSString setNumLabelWithStr:redpacket.prize_second_per_money];
        self.prize_third_numLabel.text = redpacket.prize_third_num;
        self.prize_third_per_moneyLabel.text = [NSString setNumLabelWithStr:redpacket.prize_third_per_money];
        self.prize_consolation_numLabel.text = redpacket.prize_consolation_num;
//        self.prize_consolation_per_moneyLabel.text = [NSString setNumLabelWithStr:redpacket.prize_consolation_per_money];
        self.prize_consolation_per_moneyLabel.text = @"随机生成";
        self.prize_total_numLabel.text = [NSString stringWithFormat:@"派发人数: %@人",redpacket.prize_total_num];
        self.prize_total_moneyLabel.text = [NSString stringWithFormat:@"¥%@",[NSString setNumLabelWithStr:redpacket.prize_total_money]];
        self.prize_server_moneyLabel.text = [NSString stringWithFormat:@"¥%@",[NSString setNumLabelWithStr:redpacket.prize_service_money]];
    }
    
    
    
}



@end
