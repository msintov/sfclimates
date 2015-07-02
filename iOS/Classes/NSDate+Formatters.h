//
//  NSDate+Formatters.h
//  sfmcs
//
//  Copyright 2015 Baker Beach Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Formatters)

- (NSString*)weekdayString;
- (NSString*)formatDateWithPrefix:(NSString*)prefix;

@end
