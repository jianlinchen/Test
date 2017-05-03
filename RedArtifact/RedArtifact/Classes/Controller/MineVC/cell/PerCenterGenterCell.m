//
//  PerCenterGenterCell.m
//  RedArtifact
//
//  Created by LiLu on 16/9/13.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "PerCenterGenterCell.h"

@implementation PerCenterGenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization codeFEA000
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)manAction:(id)sender {
    if (self.genderBack) {
        self.genderBack(@"1");
    }
     [self.manButton setTitleColor:RGBHex(0xFEA000) forState:UIControlStateNormal];
     [self.manButton setImage:[UIImage imageNamed:@"my_person_man"] forState:UIControlStateNormal];
    
    [self.wommonButton setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
    [self.wommonButton setImage:[UIImage imageNamed:@"my_person_wommon"] forState:UIControlStateNormal];
    
    
}

- (IBAction)wommonAction:(id)sender {
    if (self.genderBack) {
        self.genderBack(@"2");
    }
    [self.wommonButton setTitleColor:RGBHex(0xFEA000) forState:UIControlStateNormal];
    [self.wommonButton setImage:[UIImage imageNamed:@"my_person_man"] forState:UIControlStateNormal];
    
    [self.manButton setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
    [self.manButton setImage:[UIImage imageNamed:@"my_person_wommon"] forState:UIControlStateNormal];
  

}
-(void)getGender:(NSString *)genderStr{
    if ([genderStr isEqualToString:@"2"]) {
        [self.wommonButton setTitleColor:RGBHex(0xFEA000) forState:UIControlStateNormal];
        [self.wommonButton setImage:[UIImage imageNamed:@"my_person_man"] forState:UIControlStateNormal];
        
        [self.manButton setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
        [self.manButton setImage:[UIImage imageNamed:@"my_person_wommon"] forState:UIControlStateNormal];
    }else{
        
        [self.manButton setTitleColor:RGBHex(0xFEA000) forState:UIControlStateNormal];
        [self.manButton setImage:[UIImage imageNamed:@"my_person_man"] forState:UIControlStateNormal];
        
        [self.wommonButton setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
        [self.wommonButton setImage:[UIImage imageNamed:@"my_person_wommon"] forState:UIControlStateNormal];
        
    }
    
    
}
@end
