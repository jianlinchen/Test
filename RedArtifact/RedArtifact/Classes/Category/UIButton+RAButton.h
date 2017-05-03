//
//  UIButton+RAButton.h
//  RedArtifact
//
//  Created by xiaoma on 16/8/11.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (RAButton)

+ (UIButton *)addButtonWithTitle:(NSString *)title
                      titleColor:(UIColor *)titleColor
                     buttonColor:(UIColor *)buttonColor
                          target:(id)target
                          action:(SEL)action;

+ (UIButton *)addButtonWithImage:(NSString *)imageName
                  highlightImage:(NSString *)highlightImageName
                          target:(id)target
                          action:(SEL)action;

@end
