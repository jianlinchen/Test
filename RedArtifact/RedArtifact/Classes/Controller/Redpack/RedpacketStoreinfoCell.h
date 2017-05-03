//
//  RedpacketStoreinfoCell.h
//  RedArtifact
//
//  Created by xiaoma on 16/9/13.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RedpacketDetailReportBlock)(BOOL isClick);

typedef void(^RedpacketDetailShareBlock)(BOOL isClick);

@interface RedpacketStoreinfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *advert_titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *advert_companyLabel;

@property (nonatomic, strong) RedpacketDetailReportBlock reportBlock;

@property (nonatomic, strong) RedpacketDetailShareBlock shareBlock;

@end
