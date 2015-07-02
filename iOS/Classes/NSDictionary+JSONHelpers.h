//
//  NSDictionary+JSONHelpers.h
//  sfmcs
//
//  Copyright 2015 Baker Beach Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSONHelpers)

- (NSString*)stringForKey:(NSString*)key;
- (int)integerForKey:(NSString*)key;
- (double)doubleForKey:(NSString*)key;
- (NSArray*)arrayForKey:(NSString*)key;
- (NSDictionary*)dictionaryForKey:(NSString*)key;
- (NSDate*)dateForKey:(NSString*)key;

@end
