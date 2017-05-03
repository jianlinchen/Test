//
//  UIBarButtonItem+RABarButtonItem.m
//  RedArtifact
//
//  Created by xiaoma on 16/8/11.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "UIBarButtonItem+RABarButtonItem.h"

@implementation UIBarButtonItem (RABarButtonItem)
/*
 * 设置barbutton 图片格式
 */
+ (UIBarButtonItem *)addBarButtonItemWithImage:(NSString *)imageName
                                highlightImage:(NSString *)highlightImageName
                                        target:(id)target
                                        action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image   = [UIImage imageNamed:imageName];
    button.frame     = CGRectMake(0, 0, image.size.width, image.size.height);
    [button setBackgroundImage:image forState:UIControlStateNormal];
    if (highlightImageName != nil) {
        [button setBackgroundImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIView *btnView = [[UIView alloc] init];
    btnView.frame   = CGRectMake(0, 0, button.frame.size.width, button.frame.size.height);
    [btnView addSubview:button];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btnView];
}

/*
 * 设置barbutton 文字形式
 */
+ (UIBarButtonItem *)addBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    UIButton *btn              = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame                  = CGRectMake(0, 0, [title sizeOfStringFont:font(16.0) width:MAXFLOAT].width, 44);
    [btn setTitle:title forState:UIControlStateNormal];
    btn.userInteractionEnabled = YES;
    btn.titleLabel.font        = [UIFont systemFontOfSize:16.0];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
@end
