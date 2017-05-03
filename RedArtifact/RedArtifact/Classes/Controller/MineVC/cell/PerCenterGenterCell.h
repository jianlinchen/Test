//
//  PerCenterGenterCell.h
//  RedArtifact
//
//  Created by LiLu on 16/9/13.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^GenderBack) (NSString *obj);
@interface PerCenterGenterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *manButton;
@property (weak, nonatomic) IBOutlet UIButton *wommonButton;
- (IBAction)manAction:(id)sender;
- (IBAction)wommonAction:(id)sender;
@property (copy,nonatomic) GenderBack genderBack;
-(void)getGender:(NSString *)genderStr;
@end
