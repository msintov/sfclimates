//
//  UtilityMethods.m
//  sfmcs
//
//  Created by Michelle Sintov on 10/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UtilityMethods.h"

NSString *bayviewNSString = @"Bayview";
NSString *castroNSString = @"Castro";
NSString *coleValleyNSString = @"Cole Valley";
NSString *financialDistrictNSString = @"Financial District";
NSString *glenParkNSString = @"Glen Park";
NSString *hayesValleyNSString = @"Hayes Valley";
NSString *innerRichmondNSString = @"Inner Richmond";
NSString *lakeMercedNSString = @"Lake Merced";
NSString *missionNSString = @"Mission";
NSString *noeValleyNSString = @"Noe Valley";
NSString *northBeachNSString = @"North Beach";
NSString *outerRichmondNSString = @"Outer Richmond";
NSString *outerSunsetNSString = @"Outer Sunset";
NSString *potreroHillNSString = @"Potrero Hill";
NSString *presidioNSString = @"Presidio";
NSString *somaNSString = @"SOMA";
NSString *twinPeaksNSString = @"Twin Peaks";
NSString *westPortalNSString = @"West Portal";

static NSString *const USER_DEFAULT_TEMP_UNITS = @"temperatureUnits";

@interface UtilityMethods()
@property (nonatomic, readonly) NSDictionary *conditionImageMappingDict;
@end

@implementation UtilityMethods

#pragma mark -
#pragma mark Singleton implementation methods

static UtilityMethods *sharedUtilityMethodsInstance = nil;

+ (UtilityMethods*)sharedInstance
{
    if (sharedUtilityMethodsInstance == nil) {
        sharedUtilityMethodsInstance = [[super allocWithZone:NULL] init];
    }
    return sharedUtilityMethodsInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedInstance] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

- (void)setAppDefaults
{
    NSDictionary *userDefaultsDefaults = [NSDictionary dictionaryWithObjectsAndKeys: 
                                          @"F", USER_DEFAULT_TEMP_UNITS, nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsDefaults];
}

- (void)retrieveUserDefaults
{
    NSString *temperatureUnits = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_TEMP_UNITS];
    if (temperatureUnits != nil)
    {
        celsiusMode = [temperatureUnits isEqual:@"C"];            
    }
}

- (id)init
{
    self = [super init];

    if (self)
    {
        [self setAppDefaults];
        
        [self retrieveUserDefaults];
    }
    
    return self;
}


#pragma mark -
#pragma mark Utility Methods

// We don't currently provide any image for any derivative of the following conditions:
// [Light/Heavy] Smoke
// [Light/Heavy] Volcanic Ash
// [Light/Heavy] Widespread Dust
// [Light/Heavy] Sand
// [Light/Heavy] Haze
// [Light/Heavy] Dust Whirls
// [Light/Heavy] Sandstorm
// [Light/Heavy] Low Drifting Snow
// [Light/Heavy] Low Drifting Widespread Dust
// [Light/Heavy] Low Drifting Sand
// [Light/Heavy] Blowing Snow
// [Light/Heavy] Blowing Widespread Dust
// [Light/Heavy] Blowing Sand
//
// getConditionImage can return nil.
- (UIImage*)getConditionImage:(NSString*)conditionString withIsNight:(BOOL)isNight withIconSize:(ConditionIconSize)conditionIconSize
{
	conditionString = [conditionString lowercaseString];
	
	if (self.conditionImageMappingDict == nil) return nil;
	
	NSString *conditionImageName = [self.conditionImageMappingDict objectForKey:conditionString];
	if (!conditionImageName)
	{
		if (!isNight)
		{
			conditionString = [conditionString stringByAppendingString:@" day"];
		}
		else
		{
			conditionString = [conditionString stringByAppendingString:@" night"];
		}
		conditionImageName = [self.conditionImageMappingDict objectForKey:conditionString];
		
		if (!conditionImageName) return nil;
	}

    switch (conditionIconSize) {
        case mediumConditionIcon:
            conditionImageName = [conditionImageName stringByAppendingString:@"_med"];
            break;
            
        case largeConditionIcon:
            conditionImageName = [conditionImageName stringByAppendingString:@"_lg"];
            break;            
            
        default:
            break;
    }

	return [UIImage imageNamed:conditionImageName];
}

- (BOOL)isNight:(NSDictionary*)weatherDict
{
	// Determine the number of seconds since midnight of the current day according to the time on the phone.
	int sunriseInSecondsSinceMidnight = [[weatherDict objectForKey:@"sunrise"] intValue];
	int sunsetInSecondsSinceMidnight = [[weatherDict objectForKey:@"sunset"] intValue];

	BOOL isNight = NO;
    
    NSTimeZone* pacificTimeZone = [NSTimeZone timeZoneWithName:@"America/Los_Angeles"];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:pacificTimeZone];
    
	NSDateComponents *components = [calendar components:kCFCalendarUnitSecond|kCFCalendarUnitHour|kCFCalendarUnitMinute fromDate:[NSDate date]];
	if (components)
	{
		NSInteger seconds = [components second];
		NSInteger hours = [components hour];
		NSInteger minutes = [components minute];
		
		int currentSecondsSinceMidnight = ((hours*60)+minutes)*60 + seconds;
		if (currentSecondsSinceMidnight < sunriseInSecondsSinceMidnight || currentSecondsSinceMidnight > sunsetInSecondsSinceMidnight) isNight = YES;
	}
	return isNight;
}

- (NSString*)getFormattedDate:(NSDate*)myDate prependString:(NSString*)prependStringValue
{
    if (!dateFormatterForDate)
    {
        dateFormatterForDate = [[NSDateFormatter alloc] init];
        [dateFormatterForDate setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatterForDate setTimeStyle:NSDateFormatterShortStyle];
    }

	NSString *dateString = [NSString string];

	@try {
		if (prependStringValue)
			dateString = [dateString stringByAppendingString:prependStringValue];
		
		dateString = [dateString stringByAppendingString:[dateFormatterForDate stringFromDate:myDate]];
	}
	@catch (NSException *exception) {
		DLog(@"in getFormattedDate, stringByAppendingString: Caught %@: %@", [exception name], [exception reason]);
	}

	return dateString;
}

- (NSString*)getDay:(NSDate*)myDate
{
    if (!dateFormatterForDay)
    {
        dateFormatterForDay= [[NSDateFormatter alloc] init];
        [dateFormatterForDay setDateFormat:@"EEEE"];
    }
    
    NSString *dayString = [dateFormatterForDay stringFromDate:myDate];

    return dayString;
}

- (NSDictionary*)conditionImageMappingDict
{
	if (!conditionImageMappingDict)
	{
		// Create NSDictionary mapping Wunderground conditions with icon file names.
		NSBundle *nsBundle = [NSBundle mainBundle];
		if (nsBundle == nil) return nil;
		
		NSString * plistPath = [[NSBundle mainBundle] pathForResource:@"ConditionImageMapping" ofType:@"plist"];
		if (plistPath == nil) return nil;
		
		conditionImageMappingDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
		if (conditionImageMappingDict == nil) return nil;
		
		[conditionImageMappingDict retain];
	}
	return conditionImageMappingDict;
}

- (BOOL)isCelsiusMode
{
    return celsiusMode;
}

- (void)setCelsiusMode:(BOOL)newCelsiusMode
{
    celsiusMode = newCelsiusMode;
    
    NSString *temperatureUnits = newCelsiusMode ? @"C" : @"F";
    [[NSUserDefaults standardUserDefaults] setValue:temperatureUnits forKey:USER_DEFAULT_TEMP_UNITS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// Given an int (e.g., 80), returns a temperature NSString (e.g., 80<degree symbol>)
- (NSString*)makeTemperatureString:(int)temperatureInt showDegree:(BOOL)showDegree
{
	NSString *temperatureString = [NSString string];

    if ([self isCelsiusMode])
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


- (void)dealloc {
    [dateFormatterForDate release];
    [dateFormatterForDay release];
	[conditionImageMappingDict release];
	[super dealloc];
}

@end
