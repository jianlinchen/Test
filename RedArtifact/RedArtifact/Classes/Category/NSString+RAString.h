//
//  NSString+RAString.h
//  RedArtifact
//
//  Created by xiaoma on 16/8/11.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RAString)

/*
 * 验证邮箱
 */
- (BOOL)validateEmail;

/*
 * 身份证号
 */
- (BOOL)validateIdentityCard;

/*
 * 去掉字符串的空格
 */
- (NSString *)trimmingStr;

/*
 * 字典转json字符串
 */
+ (NSString *)jsonStrWithDictionary:(NSDictionary *)dic;

/*
 *  计算字符串size
 */
- (CGSize)sizeOfStringFont:(UIFont *)font width:(CGFloat)width;

/*
 *  处理字符串格式
 */
+ (NSString *)setNumLabelWithStr:(NSString *)moneyStr;


/*
 *  处理base64
 */
+ (NSString *)base64StringFromText:(NSString *)text;

@end
