//
//  NSString+Temperature.h
//  sfmcs
//
//
//

#import <Foundation/Foundation.h>

@interface NSString (Temperature)

+ (NSString*)formatTemperature:(int)temperature showDegree:(BOOL)showDegree;

@end
