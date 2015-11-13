//
//  CrossTimerHelper.m
//  CrossChat
//
//  Created by chaobai on 15/11/6.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossTimerHelper.h"

@implementation CrossTimerHelper

+ (NSDate *)getCurrentDate
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}
@end
