//
//  NRCommonExtensions.h
//  NestRun-Objc
//
//  Created by Dima Choock on 10/11/2017.
//  Copyright © 2017 Dima Choock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(Formatter)

    +(NSString *)getDateStringFromDate :(NSDate *)date; 
    +(NSDate *)getDateFromDateString :(NSString *)dateString;

@end
