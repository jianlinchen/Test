//
//  NSString+AES.m
//  RedArtifact
//
//  Created by LiLu on 16/8/12.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "NSString+AES.h"

@implementation NSString (AES)
//加密
- (NSString *) AES256_Encrypt:(NSString *)key{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    //对数据进行加密
    NSData *result = [data AES256_Encrypt:key];
    
    NSString *base64Encoded = [result base64EncodedStringWithOptions:0];
    
    // Print the Base64 encoded string
    NSLog(@"Encoded: %@", base64Encoded);
    
    
    
    //转换为2进制字符串
    if (result && result.length > 0) {
        
        Byte *datas = (Byte*)[result bytes];
        NSMutableString *output = [NSMutableString stringWithCapacity:result.length * 2];
        for(int i = 0; i < result.length; i++){
            [output appendFormat:@"%02x", datas[i]];
        }
        return output;
    }
    return nil;
}

//解密
- (NSString *) AES256_Decrypt:(NSString *)key{
    //转换为2进制Data
    NSMutableData *data = [NSMutableData dataWithCapacity:self.length / 2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [self length] / 2; i++) {
        byte_chars[0] = [self characterAtIndex:i*2];
        byte_chars[1] = [self characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    //对数据进行解密
    NSData* result = [data AES256_Decrypt:key];
    if (result && result.length > 0) {
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
    return nil;
}


- (NSString *)base64EncodedString;
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)base64DecodedString
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}
/**
 
 "    APP的数据安全已经牵动着我们开发者的心，
      简单的MD5/Base64等已经难以满足当下的数据安全标准，
      AES与Base64的混合加密与解密已经成为主流"
 *   下文是调用加解密的案例，作为参考调用。Pointed out by JianLin
 // Do any additional setup after loading the view, typically from a nib.
 //字符串加密   
 NSString *key = @"12345678";//Key是和后台约定的key哦，不然无法解密....
 NSString *secret = @"aes Bison base64";
 
 
 NSLog(@"字符串加密---%@",[secret AES256_Encrypt:key]);
 
 //字符串解密    
 NSLog(@"字符串解密---%@",[[secret AES256_Encrypt:key] AES256_Decrypt:key]);
 
 
 //NSData加密+base64
 NSData *plain = [secret dataUsingEncoding:NSUTF8StringEncoding];
 
 NSData *cipher = [plain AES256_Encrypt:key];
 
 NSLog(@"NSData加密+base64++++%@",[cipher newStringInBase64FromData]);
 
 
 //解密
 plain = [cipher AES256_Decrypt:key];
 
 NSLog(@"NSData解密+base64++++%@", [[NSString alloc] initWithData:plain encoding:NSUTF8StringEncoding]);
 
 */



@end
