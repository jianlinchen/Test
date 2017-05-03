//
//  PlugCell.h
//  RedArtifact
//
//  Created by xiaoma on 16/10/26.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlugCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *plugImgView;
@property (weak, nonatomic) IBOutlet UILabel *plugNameLabel;
@property (weak, nonatomic) IBOutlet UIView *bottmLineView;

@end
