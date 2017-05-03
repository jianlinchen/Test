//
//  RedpacketStoreinfoCell.m
//  RedArtifact
//
//  Created by xiaoma on 16/9/13.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "RedpacketStoreinfoCell.h"

@implementation RedpacketStoreinfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)reportAction:(id)sender {
    if (self.reportBlock) {
        _reportBlock(YES);
    }
}

- (IBAction)shareAction:(id)sender {
    if (self.shareBlock) {
        _shareBlock(YES);
    }
}

@end
