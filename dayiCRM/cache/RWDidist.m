//
//  RWDidist.m
//  RW
//
//  Created by fang honghao on 12-3-1.
//  Copyright (c) 2012年 roadrover. All rights reserved.
//

#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>
#import "RWDidist.h"
#import "RWHomeCache.h"

static NSMutableString *str_tmp = nil;
@implementation RWDidist

+ (NSString *)hmacsha1:(NSString *)text key:(NSString *)secret andDictionary:(NSMutableDictionary *)dic
{
    NSString *token = [NSString stringWithFormat:@"|^%@^|",secret];
	NSArray *keys = [dic allKeys];	
	NSMutableString *str = [NSMutableString string];
	str_tmp = [NSMutableString string];
	[str_tmp appendString:[NSString stringWithFormat:@"&a_t=%@",text]];
	[str_tmp appendString:[NSString stringWithFormat:@"&token=%@",[dic objectForKey:@"token"]]];

	for (NSString *key in keys)
	{
	    if (![key isEqualToString:@"token"])
		{
			[str appendString:[NSString stringWithFormat:@"%@=%@|",key, [dic objectForKey:key]]];
			[str_tmp appendString:[NSString stringWithFormat:@"&%@=%@",key,[dic objectForKey:key]]];
		}
	}
	
	NSString *data = nil;
	if ([str length] != 0)
	{
		data = [NSString stringWithFormat:@"a_t=%@|%@",text,str];
	}
	
	else 
	{
		data = [NSString stringWithFormat:@"a_t=%@|",text];

	}
	
    NSData *secretData = [token dataUsingEncoding:NSUTF8StringEncoding];
    NSData *clearTextData = [data dataUsingEncoding:NSUTF8StringEncoding];
	
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
	CCHmac(kCCHmacAlgSHA1, [secretData bytes], [secretData length], [clearTextData bytes], [clearTextData length], result);
	
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", result[i]];
    }
	
	[str_tmp appendString:[NSString stringWithFormat:@"&sign=%@",output]];

    return  output;
}

+ (NSString *)getCurrentTimeString
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * curTime = [formater stringFromDate:date];
    return  curTime;
}


+ (NSString *)getCurrentTime
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * curTime = [formater stringFromDate:date];
    NSDate *theDate=[formater dateFromString:curTime];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formater setTimeZone:timeZone];
    NSTimeInterval a =[theDate timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%0.0f",a];
    return  timeString;
}

+ (NSString *)getTomorrowTime
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * curTime = [formater stringFromDate:date];
    NSDate *theDate=[formater dateFromString:curTime];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formater setTimeZone:timeZone];
    NSTimeInterval a =[theDate timeIntervalSince1970]*1000 + 24*60*60;
    NSString *timeString = [NSString stringWithFormat:@"%0.0f",a];
    return  timeString;
}

+ (NSString *)getStringFromDate:(NSDate *)date
{
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSString * curTime = [formater stringFromDate:date];
    return  curTime;
}

+ (NSString *)getDateStringFromDate:(NSDate *)date
{
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSString * curTime = [formater stringFromDate:date];
    NSDate *theDate=[formater dateFromString:curTime];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formater setTimeZone:timeZone];
    NSTimeInterval a =[theDate timeIntervalSince1970]*1000;
    NSString *dateString = [NSString stringWithFormat:@"%0.0f",a];
    return  dateString;
}

+ (NSDate *)getCurrentDate
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    return  date;
}

+ (NSDate *)getTomorrowDate
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:24*60*60];
    return  date;
}

+ (NSString *)getTodayTime
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM"];
    NSString * curTime = [formater stringFromDate:date];
    NSDate *theDate=[formater dateFromString:curTime];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formater setTimeZone:timeZone];
    NSTimeInterval a =[theDate timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%0.0f",a];
    return  timeString;
}


+ (NSMutableString *)getStr
{
	return str_tmp;
}

+ (NSString *)getWeekFromDate:(NSDate *)date
{
    NSCalendar *c = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now=[NSDate date];
    comps = [c components:unitFlags fromDate:date];
    NSUInteger week = [comps weekday];
    NSString *weekStr;
    switch (week)
    {
        case 1:
            weekStr = @"周日";
            break;
        case 2:
            weekStr = @"周一";
            break;
        case 3:
            weekStr = @"周二";
            break;
        case 4:
            weekStr = @"周三";
            break;
        case 5:
            weekStr = @"周四";
            break;
        case 6:
            weekStr = @"周五";
            break;
        case 7:
            weekStr = @"周六";
            break;
        default:
            break;
    }
    
    return weekStr;
}

+(NSDate*) convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}

+ (NSDate *)dateFromString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];

    return destDate;
}

+ (BOOL)compareData:(NSDate *)date toData:(NSDate *)toDate
{
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setFormatterBehavior:NSDateFormatterBehaviorDefault];
    [date_formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *post_date = [date_formatter stringFromDate:date];
    NSString *now_date = [date_formatter stringFromDate:toDate];
    NSDate *date1 = [date_formatter dateFromString:post_date];
    NSDate *date2 = [date_formatter dateFromString:now_date];
    
    NSTimeInterval time1 = [date1 timeIntervalSince1970];
    NSTimeInterval time2 = [date2 timeIntervalSince1970];
    
    int days = abs(time2 - time1)/(24*60*60);
    
    if (days == 0)
    {
        return 0;
    }
    else
    {
        return 1;
    }
    

}

+ (NSDate *)getDateFromString:(NSString *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ 00:00:00",date]];
    return d;
}

+ (NSString *)getCityCodeWithName:(NSString *)name
{
    NSString *code;
	NSArray *arr = [RWHomeCache readFromFile:@"cityCode"];
    
    for (NSDictionary *dic in arr)
    {
        if ([[dic objectForKey:@"city"] isEqualToString:name]) {
            code = [dic objectForKey:@"key"];
            break;
        }
    }
    
    return code;
}

+ (NSString *)getAirPortCodeWithName:(NSString *)name
{
    NSString *code;
	NSArray *arr = [RWHomeCache readFromFile:@"airportCode"];
    
    for (NSDictionary *dic in arr)
    {
        if ([[dic objectForKey:@"airport"] isEqualToString:name]) {
            code = [dic objectForKey:@"airport_key"];
            break;
        }
    }
    
    return code;
}

+(void)writeToPlist:(NSString *)key :(NSString *)value
{
    NSArray *patharray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path =  [patharray objectAtIndex:0];
    NSString *filepath=[path stringByAppendingPathComponent:@"ConfigList.plist"];
    NSFileManager *fileManager  = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath: filepath])
    {
        [fileManager createFileAtPath: filepath contents:nil attributes:nil];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:filepath];
    if([dic objectForKey:key])
    {
        [dic removeObjectForKey:key];
    }
    [dic setObject:value forKey:key];
    [dic writeToFile:filepath atomically:YES];
}

+(NSString *)readFromPlistByKey:(NSString *)key
{
    NSArray *patharray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path =  [patharray objectAtIndex:0];
    NSString *filepath=[path stringByAppendingPathComponent:@"ConfigList.plist"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:filepath];
    return [dic objectForKey:key];
}

+(void)removeFromPlist:(NSString *)key
{
    NSArray *patharray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path =  [patharray objectAtIndex:0];
    NSString *filepath=[path stringByAppendingPathComponent:@"ConfigList.plist"];
    NSFileManager *fileManager  = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath: filepath])
    {
        [fileManager createFileAtPath: filepath contents:nil attributes:nil];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:filepath];
    if([dic objectForKey:key])
    {
        [dic removeObjectForKey:key];
    }
    [dic writeToFile:filepath atomically:YES];
}
@end
