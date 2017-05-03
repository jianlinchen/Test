//
//  NSDictionary+RADictionary.h
//  RedArtifact
//
//  Created by xiaoma on 16/8/11.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (RADictionary)

/*
 * json转字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
