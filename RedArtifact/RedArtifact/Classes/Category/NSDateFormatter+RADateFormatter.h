//
//  NSDateFormatter+RADateFormatter.h
//  RedArtifact
//
//  Created by xiaoma on 16/8/11.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (RADateFormatter)

+ (id)dateFormatter;

+ (id)dateFormatterWithFormat:(NSString *)dateFormat;

+ (id)defaultDateFormatter;

@end
