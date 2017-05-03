//
//  NSString+AES.h
//  RedArtifact
//
//  Created by LiLu on 16/8/12.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+AES.h"
@interface NSString (AES)
//加密
- (NSString *) AES256_Encrypt:(NSString *)key;

//解密
- (NSString *) AES256_Decrypt:(NSString *)key;

- (NSString *)base64EncodedString;
/**
 *  将Base64编码还原
 */
- (NSString *)base64DecodedString;
@end
