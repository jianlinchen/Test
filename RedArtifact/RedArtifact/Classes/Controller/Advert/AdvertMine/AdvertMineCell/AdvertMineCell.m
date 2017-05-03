//
//  AdvertMineCell.m
//  RedArtifact
//
//  Created by xiaoma on 16/8/29.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "AdvertMineCell.h"

@implementation AdvertMineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.logoImgView.layer.masksToBounds = YES;
    self.logoImgView.layer.cornerRadius = 2;
    self.logoImgView.layer.borderWidth = 1.0;
    self.logoImgView.layer.borderColor = [UIColor colorWithHex:0xeeeeee].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
