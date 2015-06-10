//
//  UtilityMethods.m
//  sfmcs
//
//  Created by Michelle Sintov on 10/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConditionImages.h"

@implementation ConditionImages

static ConditionImages *instance = nil;

+ (ConditionImages*)sharedInstance
{
    if (instance == nil) {
        instance = [[ConditionImages alloc] init];
    }
    return instance;
}

- (id)init
{
    if (self = [super init])
    {
        // Create NSDictionary mapping Wunderground conditions with icon file names.
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ConditionImageMapping" ofType:@"plist"];
        _conditionImageMappingDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    }
    return self;
}

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
	
	if (_conditionImageMappingDict == nil) return nil;
	
	NSString *conditionImageName = [_conditionImageMappingDict objectForKey:conditionString];
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
		conditionImageName = [_conditionImageMappingDict objectForKey:conditionString];
		
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

@end
