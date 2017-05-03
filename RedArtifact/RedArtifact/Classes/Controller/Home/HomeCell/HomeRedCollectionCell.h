//
//  HomeRedCollectionCell.h
//  RedArtifact
//
//  Created by xiaoma on 16/8/25.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeRedCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *red_titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *background_imgView;
@end
