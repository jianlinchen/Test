//
//  UIBarButtonItem+RABarButtonItem.h
//  RedArtifact
//
//  Created by xiaoma on 16/8/11.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (RABarButtonItem)

/*
 * 设置barbutton 图片格式
 */
+ (UIBarButtonItem *)addBarButtonItemWithImage:(NSString *)imageName
                                highlightImage:(NSString *)highlightImageName
                                        target:(id)target
                                        action:(SEL)action;

/*
 * 设置barbutton 文字形式
 */
+ (UIBarButtonItem *)addBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

@end
