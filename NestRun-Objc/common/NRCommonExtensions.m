//
//  NRCommonExtensions.m
//  NestRun-Objc
//
//  Created by Dima Choock on 10/11/2017.
//  Copyright © 2017 Dima Choock. All rights reserved.
//

#import "NRCommonExtensions.h"

@implementation NSDate(Formatter)

+(NSString *)getDateStringFromDate :(NSDate *)date 
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];          //TimeZone(secondsFromGMT:0)
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]; //Locale(identifier: "en_US_POSIX")
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+(NSDate *)getDateFromDateString :(NSString *)dateString 
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];          //TimeZone(secondsFromGMT:0)
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]; //Locale(identifier: "en_US_POSIX")
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

@end
