//
//  PerCenterNiChenCell.h
//  RedArtifact
//
//  Created by LiLu on 16/9/13.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^Textfieldback) (NSString *obj); //方法为typedef
@interface PerCenterNiChenCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *niChenTextField;
@property (copy,nonatomic) Textfieldback textFieldBack;
-(void)post:(NSString *)niChenStr;
@end
