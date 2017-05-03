//
//  NSDate+RADate.m
//  RedArtifact
//
//  Created by xiaoma on 16/8/11.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "NSDate+RADate.h"
#import "NSDateFormatter+RADateFormatter.h"

@implementation NSDate (RADate)
/*
 * 时间戳转时间
 */
+ (NSString *)dateWithTimeIntervalString:(NSString *)timeString withDateFormatter:(NSString *)dateFormatterStr;
 {
    //格式化时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (!dateFormatterStr) {
        formatter = [NSDateFormatter defaultDateFormatter];
    } else {
        [formatter setDateFormat:dateFormatterStr];
    }
    
    //毫秒值转化为秒
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
}

/*
 * 时间转时间戳
 */
+ (NSString *)intervalTimeWithTimeString:(NSString *)timeString withDateFormatter:(NSString *)dateFormatterStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (!dateFormatterStr) {
        formatter = [NSDateFormatter defaultDateFormatter];
    } else {
        [formatter setDateFormat:dateFormatterStr];
    }
    
    NSDate *date = [formatter dateFromString:timeString];
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    NSString *intervalString = [NSString stringWithFormat:@"%.0f",timeInterval];
    return intervalString;
}

/*
 * 获取当前时间时间戳
 */
+ (NSString *)getCurrentDateInterval {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *intervalString = [NSString stringWithFormat:@"%.0f",timeInterval];
    return intervalString;
}

/*
 * 字符串转时间
 */
+ (NSDate *)dateFromString:(NSString *)dateStr withDateFormatter:(NSString *)dateFormatterStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (!dateFormatterStr) {
        dateFormatter = [NSDateFormatter defaultDateFormatter];
    } else {
        [dateFormatter setDateFormat:dateFormatterStr];
    }
    
    NSDate *anyDate =[dateFormatter dateFromString:dateStr];
    
    return anyDate;
}

/*
 * 时间转字符串
 */
+ (NSString *)stringFromDate:(NSDate *)date withDateFormatter:(NSString *)dateFormatterStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (!dateFormatterStr) {
        dateFormatter = [NSDateFormatter defaultDateFormatter];
    } else {
        [dateFormatter setDateFormat:dateFormatterStr];
    }
    
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

/*
 * 距离当前的时间间隔描述
 */
- (NSString *)timeIntervalDescription {
    NSTimeInterval timeInterval = -[self timeIntervalSinceNow];
    if (timeInterval < 60) {
        return NSLocalizedString(@"1分钟内", @"");
    } else if (timeInterval < 3600) {
        return [NSString stringWithFormat:NSLocalizedString(@"%.f分钟前", @""), timeInterval / 60];
    } else if (timeInterval < 86400) {
        return [NSString stringWithFormat:NSLocalizedString(@"%.f小时前", @""), timeInterval / 3600];
    } else if (timeInterval < 2592000) {//30天内
        return [NSString stringWithFormat:NSLocalizedString(@"%.f天前", @""), timeInterval / 86400];
    } else if (timeInterval < 31536000) {//30天至1年内
        NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterWithFormat:NSLocalizedString(@"M月d日", @"")];
        return [dateFormatter stringFromDate:self];
    } else {
        return [NSString stringWithFormat:NSLocalizedString(@"%.f年前", @""), timeInterval / 31536000];
    }
}

/*
 * 计算时间间隔
 */
- (NSInteger) minutesAfterDate: (NSDate *) aDate;
{
    NSTimeInterval ti = -[self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_MINUTE);
}

/*
 * 计算与当前时间的时间间隔
 */
- (NSInteger) minutesAfterCurrentDate {
    NSTimeInterval ti = -[self timeIntervalSinceDate:[NSDate date]];
    return (NSInteger) (ti / D_MINUTE);
}

/*
 * UTC与GMT时间格式转换
 */
- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate {
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

/*
 * 计算时间戳间隔
 */
+ (NSInteger)timeIntervalWithTime:(NSInteger)timeInterval {
    NSInteger comparetime = timeInterval - [[NSDate date] timeIntervalSince1970];
    return comparetime;
}
+ (int)judgeSpace:(NSDate *)senDate andNowDate:(NSDate *)nowDate {
    
    //计算时间间隔（单位是秒）
    NSTimeInterval timeStr = [senDate timeIntervalSinceDate:nowDate];
    
    int seconds=[[NSString stringWithFormat:@"%f",timeStr]intValue];
    
    return seconds;
    
}
@end
