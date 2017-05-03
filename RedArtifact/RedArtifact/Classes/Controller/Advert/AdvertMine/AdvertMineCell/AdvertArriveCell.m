//
//  AdvertArriveCell.m
//  RedArtifact
//
//  Created by xiaoma on 16/9/8.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "AdvertArriveCell.h"

@implementation AdvertArriveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.logoImgView.layer.masksToBounds = YES;
    self.logoImgView.layer.cornerRadius = 20;
    self.logoImgView.layer.borderColor = [UIColor colorWithHex:0x999999].CGColor;
    self.logoImgView.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
