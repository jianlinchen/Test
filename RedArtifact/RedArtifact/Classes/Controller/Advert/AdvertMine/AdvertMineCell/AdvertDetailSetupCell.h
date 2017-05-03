//
//  AdvertDetailSetupCell.h
//  RedArtifact
//
//  Created by xiaoma on 16/9/1.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvertDetailSetupCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *begin_timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *end_timeLabel;
@property (strong, nonatomic) NSMutableArray *addressArrays;
@end
