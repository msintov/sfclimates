//
//  NSDictionary+JSONHelpers.m
//  sfmcs
//
//  Copyright 2015 Baker Beach Software, LLC. All rights reserved.
//

#import "NSDictionary+JSONHelpers.h"

@implementation NSDictionary (JSONHelpers)

- (double)doubleForKey:(NSString*)key
{
    id obj = [self objectForKey:key];
    return obj != nil ? [obj doubleValue] : NAN;
}

- (int)integerForKey:(NSString*)key
{
    id obj = [self objectForKey:key];
    return obj != nil ? [obj intValue] : -1;
}

- (NSString*)stringForKey:(NSString*)key
{
    id obj = [self objectForKey:key];
    if (obj != nil)
    {
        return [obj isKindOfClass:[NSString class]] ? obj : [obj description];
    }
    else
    {
        return nil;
    }
}

- (NSArray*)arrayForKey:(NSString*)key
{
    id obj = [self objectForKey:key];
    if (obj != nil && [obj isKindOfClass:[NSArray class]])
    {
        return obj;
    }
    else
    {
        return nil;
    }
}

- (NSDictionary*)dictionaryForKey:(NSString*)key;
{
    id obj = [self objectForKey:key];
    if (obj != nil && [obj isKindOfClass:[NSDictionary class]])
    {
        return obj;
    }
    else
    {
        return nil;
    }
}

- (NSDate*)dateForKey:(NSString*)key
{
    id obj = [self objectForKey:key];
    if (obj != nil)
    {
        return [NSDate dateWithTimeIntervalSince1970:[obj doubleValue]];
    }
    else
    {
        return nil;
    }
}

@end
