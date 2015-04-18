//
//  DateConvert.h
//  快递大师
//
//  Created by amber on 15/3/9.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateConvertManager : NSObject

/**
 *  将时间转为昨天今天
 *
 *  @param date 要转换的NSDate
 *
 *  @return 字符串
 */
-(NSString *)compareDate:(NSDate *)date;

/**
 *  将字符串转为NSDate
 *
 *  @param uiDate 要转的字符串
 *
 *  @return NSDate
 */
- (NSDate*) convertDateFromString:(NSString*)uiDate;

+(NSDateFormatter*) dateFormatter;
@end
