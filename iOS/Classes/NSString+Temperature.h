//
//  NSString+Temperature.h
//  sfmcs
//
//  Copyright 2015 Baker Beach Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Temperature)

+ (NSString*)formatTemperature:(int)temperature showDegree:(BOOL)showDegree;

@end
