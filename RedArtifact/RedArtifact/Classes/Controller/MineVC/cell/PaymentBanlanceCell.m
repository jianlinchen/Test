//
//  PaymentBanlanceCell.m
//  RedArtifact
//
//  Created by LiLu on 16/9/18.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "PaymentBanlanceCell.h"

@implementation PaymentBanlanceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)get:(RABlanceBarGain *)bargainModel{
    NSString *btnStr= [NSDate dateWithTimeIntervalString:bargainModel.create_time withDateFormatter:nil];
    self.timeLabel.text=btnStr;
    self.nameLabel.text=bargainModel.source_str;
    
    NSString *monStr=[NSString setNumLabelWithStr:bargainModel.amount];
    if ([bargainModel.type isEqualToString:@"income"]) {
        
        self.moneyLabel.text=[NSString stringWithFormat:@"+%@",monStr];
    }else{
        self.moneyLabel.text=[NSString stringWithFormat:@"-%@",monStr];
        self.moneyLabel.textColor=RGBHex(0xdb413c);
    }
    
    
}
@end
