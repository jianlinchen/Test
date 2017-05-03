//
//  NSDateFormatter+RADateFormatter.m
//  RedArtifact
//
//  Created by xiaoma on 16/8/11.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "NSDateFormatter+RADateFormatter.h"

@implementation NSDateFormatter (RADateFormatter)

+ (id)dateFormatter
{
    return [[self alloc] init];
}

+ (id)dateFormatterWithFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[self alloc] init];
    dateFormatter.dateFormat = dateFormat;
    return dateFormatter;
}

+ (id)defaultDateFormatter
{
    return [self dateFormatterWithFormat:@"yyyy-MM-dd HH:mm"];
}

@end
