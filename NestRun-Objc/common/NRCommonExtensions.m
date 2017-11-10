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
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+(NSDate *)getDateFromDateString :(NSString *)dateString 
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

@end
