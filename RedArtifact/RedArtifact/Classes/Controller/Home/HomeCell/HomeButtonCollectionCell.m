//
//  HomeButtonCollectionCell.m
//  RedArtifact
//
//  Created by xiaoma on 16/8/24.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "HomeButtonCollectionCell.h"

@implementation HomeButtonCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.appImgView.layer.masksToBounds = YES;
    self.appImgView.layer.cornerRadius = 8;
    
}

@end
