//
//  UIColor+RAColor.m
//  RedArtifact
//
//  Created by xiaoma on 16/8/11.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "UIColor+RAColor.h"

@implementation UIColor (RAColor)
/*
 * 16进制颜色处理
 */
+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue {
    return [UIColor colorWithRed:((float) ((hexValue & 0xFF0000) >> 16)) / 255.0
                           green:((float) ((hexValue & 0xFF00) >> 8)) / 255.0
                            blue:((float) (hexValue & 0xFF)) / 255.0
                           alpha:alphaValue];
}

+ (UIColor *)colorWithHex:(NSInteger)hexValue {
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

@end
