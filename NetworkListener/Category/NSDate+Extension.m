//
//  NSDate+Extension.m
//  Listener
//
//  Created by yellow on 2019/4/18.
//  Copyright © 2019 yellow. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

- (NSString*)stringByFormatter:(NSString*)formatter
{
    return [self stringByFormatter:formatter timeZone:[NSTimeZone localTimeZone]];
}

- (NSString*)stringByFormatter:(NSString*)formatter timeZone:(NSTimeZone *)timeZone
{
    NSString *dateString;
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:formatter];
    dateString = [dateFormatter stringFromDate:self];
    return dateString;
}

@end
