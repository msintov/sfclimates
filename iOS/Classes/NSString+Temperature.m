//
//  NSString+Temperature.m
//  sfmcs
//
//
//

#import "NSString+Temperature.h"
#import "Preferences.h"

@implementation NSString (Temperature)

// Given an int (e.g., 80), returns a temperature NSString (e.g., 80<degree symbol>)
+ (NSString*)formatTemperature:(int)temperatureInt showDegree:(BOOL)showDegree
{
    NSString *temperatureString = [NSString string];
    
    if ([[Preferences sharedPreferences] celsiusMode])
    {
        temperatureInt = (int) ((temperatureInt - 32.0) * 5.0 / 9.0 + 0.5);
    }
    
    @try
    {
        temperatureString = [temperatureString stringByAppendingString:[NSString stringWithFormat:@"%d", temperatureInt]];
        
        if (showDegree)
        {
            temperatureString = [temperatureString stringByAppendingString:[NSString stringWithUTF8String:"\xC2\xB0"]];
        }
    }
    @catch (NSException *exception)
    {
        DLog(@"makeTemperatureString: Caught %@: %@", [exception name], [exception reason]);
    }
    return temperatureString;
}


@end
