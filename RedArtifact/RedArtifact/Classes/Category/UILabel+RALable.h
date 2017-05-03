//
//  UILabel+RALable.h
//  RedArtifact
//
//  Created by xiaoma on 16/8/11.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (RALable)

/*
 * 计算labeltext的size
 */
+ (CGSize)RALabelSizeForText:(NSString *)text font:(CGFloat)fontSize width:(CGFloat)width;

/*
 * 设置行间距
 */
+ (NSMutableAttributedString *)RALabelAttributedString:(NSString *)text lineSpacing:(CGFloat)spacing;

@end
