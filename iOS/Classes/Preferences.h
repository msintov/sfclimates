//
//  Preferences.h
//  sfmcs
//
//
//

#import <Foundation/Foundation.h>

@interface Preferences : NSObject

+ (Preferences*)sharedPreferences;

@property (nonatomic) BOOL celsiusMode;

@end
