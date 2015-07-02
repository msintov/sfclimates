//
//  Preferences.h
//  sfmcs
//
//  Copyright 2015 Baker Beach Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Preferences : NSObject

+ (Preferences*)sharedPreferences;

@property (nonatomic) BOOL celsiusMode;

@end
