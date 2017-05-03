//
//  UILabel+RALable.m
//  RedArtifact
//
//  Created by xiaoma on 16/8/11.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "UILabel+RALable.h"

@implementation UILabel (RALable)
/*
 * 计算labeltext的size
 */
+ (CGSize)RALabelSizeForText:(NSString *)text font:(CGFloat)fontSize width:(CGFloat)width {
    UIFont * font = font(fontSize);
    NSDictionary * dict =[[NSDictionary alloc]initWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGRect  rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    CGSize size = CGSizeMake(rect.size.width, rect.size.height);
    return size;
}

/*
 * 设置行间距
 */
+ (NSMutableAttributedString *)RALabelAttributedString:(NSString *)text lineSpacing:(CGFloat)spacing {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:spacing];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    return attributedString;
}

@end
