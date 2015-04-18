//
//  DateConvert.m
//  快递大师
//
//  Created by amber on 15/3/9.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "DateConvertManager.h"

@implementation DateConvertManager

/**
 *  将时间转为昨天今天
 *
 *  @param date 要转换的NSDate
 *
 *  @return 字符串
 */
-(NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    NSString * dateCompare = [dateString substringWithRange:NSMakeRange(0,10)];
    
    //NSLog(@"today:%@",todayString);
    //NSLog(@"dateString:%@",dateCompare);
    
    if ([dateCompare isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateCompare isEqualToString:yesterdayString])
    {
        return @"昨天";
    }else if ([dateCompare isEqualToString:tomorrowString])
    {
        return @"明天";
    }
    else
    {
        NSString *str = [dateCompare substringWithRange:NSMakeRange(5, 5)];
        return   str;
    }
}

/**
 *  将字符串转为NSDate
 *
 *  @param uiDate 要转的字符串
 *
 *  @return NSDate
 */
- (NSDate*) convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:uiDate];
    return date;
}

/**
 *  将字符串转为NSDate
 *
 *  @return 时间格式
 */
+(NSDateFormatter*) dateFormatter
{
    static NSDateFormatter* _dateFormatter = NULL;
    
    if(_dateFormatter==nil)
    {
        _dateFormatter = [[NSDateFormatter alloc]init];
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [_dateFormatter setTimeZone:timeZone];
    }
    return _dateFormatter;
}

@end
