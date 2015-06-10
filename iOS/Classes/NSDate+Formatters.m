//
//  NSDate+Formatters.m
//  sfmcs
//
//
//

#import "NSDate+Formatters.h"

NSDateFormatter *weekdayDateFormatter = nil;
NSDateFormatter *dateFormatter        = nil;

@implementation NSDate (Formatters)

- (NSString*)weekdayString
{
    if (!weekdayDateFormatter)
    {
        weekdayDateFormatter = [[NSDateFormatter alloc] init];
        [weekdayDateFormatter setDateFormat:@"EEEE"];
    }
    return [weekdayDateFormatter stringFromDate:self];
}

- (NSString*)formatDateWithPrefix:(NSString*)prefix
{
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    }

    NSString *dateString = [NSString string];
    
    @try
    {
        if (prefix)
        {
            dateString = [dateString stringByAppendingString:prefix];
        }
        dateString = [dateString stringByAppendingString:[dateFormatter stringFromDate:self]];
    }
    @catch (NSException *exception)
    {
        DLog(@"in getFormattedDate, stringByAppendingString: Caught %@: %@", [exception name], [exception reason]);
    }
    
    return dateString;
}

@end
