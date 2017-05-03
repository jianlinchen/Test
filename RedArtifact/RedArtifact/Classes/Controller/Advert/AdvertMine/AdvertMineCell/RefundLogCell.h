//
//  RefundLogCell.h
//  RedArtifact
//
//  Created by xiaoma on 16/9/7.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefundLogCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *log_status_imgVIew;

@property (weak, nonatomic) IBOutlet UILabel *log_timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *log_detailLabel;

@end
