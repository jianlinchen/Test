//
//  NSDate+RADate.h
//  RedArtifact
//
//  Created by xiaoma on 16/8/11.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define D_MINUTE	60

@interface NSDate (RADate)

/*
 * 时间戳转时间
 */
+ (NSString *)dateWithTimeIntervalString:(NSString *)timeString withDateFormatter:(NSString *)dateFormatterStr;

/*
 * 时间转时间戳
 */
+ (NSString *)intervalTimeWithTimeString:(NSString *)timeString withDateFormatter:(NSString *)dateFormatterStr;

/*
 * 获取当前时间时间戳
 */
+ (NSString *)getCurrentDateInterval;

/*
 * 字符串转时间
 */
+ (NSDate *)dateFromString:(NSString *)dateStr withDateFormatter:(NSString *)dateFormatterStr;

/*
 * 时间转字符串
 */
+ (NSString *)stringFromDate:(NSDate *)date withDateFormatter:(NSString *)dateFormatterStr;

/*
 * 距离当前的时间间隔描述
 */
- (NSString *)timeIntervalDescription;

/*
 * 计算时间间隔
 */
- (NSInteger)minutesAfterDate:(NSDate *) aDate;

/*
 * 计算与当前时间的时间间隔
 */
- (NSInteger)minutesAfterCurrentDate;

/*
 * UTC与GMT时间格式转换
 */
- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;

/*
 * 计算时间戳间隔
 */
+ (NSInteger)timeIntervalWithTime:(NSInteger)timeInterval;

+ (int)judgeSpace:(NSDate *)senDate andNowDate:(NSDate *)nowDate ;
@end
