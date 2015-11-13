//
//  RWDidist.h
//  RW
//
//  Created by fang honghao on 12-3-1.
//  Copyright (c) 2012年 roadrover. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWDidist : NSObject
{

}

+ (NSString *)hmacsha1:(NSString *)text key:(NSString *)secret andDictionary:(NSMutableDictionary *)dic;

+ (NSString *)getCurrentTime;

+ (NSMutableString *)getStr;

+ (NSString *)getTodayTime;

+ (NSString *)getCurrentTimeString;

+ (NSString *)getWeekFromDate:(NSDate *)date;

+ (NSString *)getStringFromDate:(NSDate *)date;

+ (BOOL)compareData:(NSDate *)date toData:(NSDate *)toDate;

+ (NSDate *)getCurrentDate;

+ (NSString *)getTomorrowTime;

+ (NSDate *)getTomorrowDate;

+ (NSString *)getDateStringFromDate:(NSDate *)date;

+ (NSDate *)getDateFromString:(NSString *)date;

+ (NSString *)getCityCodeWithName:(NSString *)name;

+ (NSString *)getAirPortCodeWithName:(NSString *)name;

+(NSDate*) convertDateFromString:(NSString*)uiDate;

+(void)writeToPlist:(NSString *)key :(NSString *)value;

+(NSString *)readFromPlistByKey:(NSString *)key;

+(void)removeFromPlist:(NSString *)key;

@end
