//
//  Preferences.m
//  sfmcs
//
//
//

#import "Preferences.h"

static NSString *const UserDefaultTempUnits = @"temperatureUnits";

static Preferences *preferences = nil;

@implementation Preferences

+ (Preferences*)sharedPreferences
{
    if (preferences == nil)
    {
        preferences = [[Preferences alloc] init];
    }
    return preferences;
}

- (id)init
{
    if (self = [super init])
    {
        [self setAppDefaults];
        [self retrieveUserDefaults];
    }
    
    return self;
}

- (void)setAppDefaults
{
    NSDictionary *userDefaultsDefaults = @{UserDefaultTempUnits: @"F"};
    [[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsDefaults];
}

- (void)retrieveUserDefaults
{
    NSString *temperatureUnits = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultTempUnits];
    if (temperatureUnits != nil)
    {
        _celsiusMode = [temperatureUnits isEqual:@"C"];
    }
}

- (void)setCelsiusMode:(BOOL)celsiusMode
{
    _celsiusMode = celsiusMode;
    
    NSString *temperatureUnits = celsiusMode ? @"C" : @"F";
    [[NSUserDefaults standardUserDefaults] setValue:temperatureUnits forKey:UserDefaultTempUnits];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



@end
