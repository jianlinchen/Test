//
//  UIButton+RAButton.m
//  RedArtifact
//
//  Created by xiaoma on 16/8/11.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "UIButton+RAButton.h"

@implementation UIButton (RAButton)

+ (UIButton *)addButtonWithTitle:(NSString *)title
                      titleColor:(UIColor *)titleColor
                     buttonColor:(UIColor *)buttonColor
                          target:(id)target
                          action:(SEL)action {
    UIButton *button = [[UIButton alloc] init];
    if (titleColor) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (buttonColor) {
        [button setBackgroundColor:buttonColor];
    }
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font        = [UIFont systemFontOfSize:16.0];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *)addButtonWithImage:(NSString *)imageName
                  highlightImage:(NSString *)highlightImageName
                          target:(id)target
                          action:(SEL)action {
    UIButton *button = [[UIButton alloc] init];
    UIImage *image   = [UIImage imageNamed:imageName];
    button.titleLabel.font        = [UIFont systemFontOfSize:16.0];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    if (highlightImageName != nil) {
        [button setBackgroundImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
@end
