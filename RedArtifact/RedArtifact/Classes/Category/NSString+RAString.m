//
//  NSString+RAString.m
//  RedArtifact
//
//  Created by xiaoma on 16/8/11.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "NSString+RAString.h"

@implementation NSString (RAString)

/*
 * 验证邮箱
 */
- (BOOL)validateEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

/*
 * 身份证号
 */
- (BOOL)validateIdentityCard {
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:self];
}

/*
 * 去掉字符串的空格
 */
- (NSString *)trimmingStr {
    NSString *temStr = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *trimStr = [temStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    return trimStr;
}

/*
 * 字典转json字符串
 */
+ (NSString *)jsonStrWithDictionary:(NSDictionary *)dic {
    
    NSError *parseError = nil;
    
    /** NSJSONWritingPrettyPrinted = 0：没换位符，1:有换位符 */
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/*
 *  计算字符串size
 */
- (CGSize)sizeOfStringFont:(UIFont *)font width:(CGFloat)width {
    CGRect aframe = [self boundingRectWithSize:CGSizeMake(width, 0)
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:@{
                                                   NSFontAttributeName : font
                                                   } context:nil];
    return aframe.size;
}

/*
 *  处理字符串格式
 */
+ (NSString *)setNumLabelWithStr:(NSString *)moneyStr {
    NSString *temStr = nil;
    if (moneyStr.length < 2) {
        NSString *pp0=[NSString stringWithFormat:@"0.0%@",moneyStr];
        temStr = pp0;
    } else if (moneyStr.length == 2) {
        NSString *pp0=[NSString stringWithFormat:@"0.%@",moneyStr];
        temStr = pp0;
    } else {
        NSString *ppStr1=[moneyStr substringToIndex:moneyStr.length-2];
        
        NSString *ppStr2=[moneyStr substringFromIndex:moneyStr.length-2];
        
        NSString *ppStr3=[NSString stringWithFormat:@".%@",ppStr2];
        
        NSString  * string = nil;
        string = [ppStr1 stringByAppendingString:ppStr3];
        //        if ([ppStr2 floatValue] > 0.00) {
        //            string = [ppStr1 stringByAppendingString:ppStr3];
        //        } else {
        //            string = ppStr1;
        //        }
        
        temStr = string;
    }
    
    return temStr;
}
//转化为base64;
+ (NSString *)base64StringFromText:(NSString *)text {
    
    
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *base64String = [data base64EncodedStringWithOptions:0];
    
    
    
    return base64String;
    
}
@end
