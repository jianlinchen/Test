//
//  RankCell.m
//  RedArtifact
//
//  Created by xiaoma on 16/9/14.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "RankCell.h"

@implementation RankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _logoImgView.layer.masksToBounds = YES;
    _logoImgView.layer.cornerRadius = 20;
    _logoImgView.layer.borderColor = [UIColor colorWithHex:0x999999].CGColor;
    _logoImgView.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
