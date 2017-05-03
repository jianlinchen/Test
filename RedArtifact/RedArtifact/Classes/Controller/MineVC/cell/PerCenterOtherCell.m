//
//  PerCenterOtherCell.m
//  RedArtifact
//
//  Created by LiLu on 16/9/13.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "PerCenterOtherCell.h"

@implementation PerCenterOtherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)getBirthday:(NSString *)birthdayStr{
    if ([birthdayStr isEqualToString:@"0"]) {
        self.rightLabel.text=@"未添加生日";
    }else{
        
          NSString *birStr= [NSDate dateWithTimeIntervalString:birthdayStr withDateFormatter:@"yyyy-MM-dd"];
        self.rightLabel.text=birStr;
    }
    
}
-(void)getCertification:(NSString *)certificationStr{
    if ([certificationStr isEqualToString:@"2"]) {
        self.rightLabel.text=@"已认证";
    }else if([certificationStr isEqualToString:@"0"]) {
        self.rightLabel.text=@"未认证";
    }else if([certificationStr isEqualToString:@"1"]) {
        self.rightLabel.text=@"审核中";
    }else if([certificationStr isEqualToString:@"3"]) {
        self.rightLabel.text=@"认证失败";
    }


}
@end
