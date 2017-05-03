//
//  NSString+Base64.m
//  RedArtifact
//
//  Created by LiLu on 16/8/23.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "NSString+Base64.h"
#import "GTMBase64.h"
#import "GTMDefines.h"

@implementation NSString (Base64)
+ (NSString*)encodeBase64String:(NSString* )input {
    
    NSData*data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    data = [GTMBase64 encodeData:data];
    
    NSString*base64String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] ;
    
    return base64String;
    
}

+ (NSString*)decodeBase64String:(NSString* )input {
    
    NSData*data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    data = [GTMBase64 decodeData:data];
    
    NSString*base64String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] ;
    
    return base64String;
    
}

+ (NSString*)encodeBase64Data:(NSData*)data {
    
    data = [GTMBase64 encodeData:data];
    
    NSString*base64String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] ;
    
    return base64String;
    
}

+ (NSString*)decodeBase64Data:(NSData*)data {
    
    data = [GTMBase64 decodeData:data];
    
    NSString*base64String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] ;
    
    return base64String;
    
}
@end
