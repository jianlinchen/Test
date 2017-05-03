//
//  AdvertArriveCell.h
//  RedArtifact
//
//  Created by xiaoma on 16/9/8.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvertArriveCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;
@property (weak, nonatomic) IBOutlet UILabel *user_nickeLabel;
@property (weak, nonatomic) IBOutlet UILabel *user_telLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
