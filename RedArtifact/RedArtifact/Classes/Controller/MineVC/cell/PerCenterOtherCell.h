//
//  PerCenterOtherCell.h
//  RedArtifact
//
//  Created by LiLu on 16/9/13.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PerCenterOtherCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
-(void)getBirthday:(NSString *)birthdayStr;
-(void)getCertification:(NSString *)certificationStr;
@property (weak, nonatomic) IBOutlet UIImageView *hidenImageView;

@end
