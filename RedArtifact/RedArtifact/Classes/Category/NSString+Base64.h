//
//  NSString+Base64.h
//  RedArtifact
//
//  Created by LiLu on 16/8/23.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base64)
+ (NSString*)encodeBase64String:(NSString*)input;

+ (NSString*)decodeBase64String:(NSString*)input;

+ (NSString*)encodeBase64Data:(NSData*)data;

+ (NSString*)decodeBase64Data:(NSData*)data;


@end
