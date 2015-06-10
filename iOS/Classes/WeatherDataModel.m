//
//  WeatherDataModel.m
//  sfmcs
//
//  Created by Michelle Sintov on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WeatherDataModel.h"
#import "JSON.h"
#import "NSDictionary+JSONHelpers.h"

NSString *ModelChangedNotificationName = @"com.bakerbeachsoftware.sfclimates.modelChanged";

@implementation WeatherDataModel
{
    NSMutableArray *_neighborhoods;
    NSMutableDictionary *_observations;
    NSMutableDictionary *_forecasts;
    int _sunriseInSecondsSinceMidnight;
    int _sunsetInSecondsSinceMidnight;
}

- (id)init
{
    if (self = [super init])
    {
        _neighborhoods = [[NSMutableArray alloc] init];
        _observations  = [[NSMutableDictionary alloc] init];
        _forecasts     = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (id)initWithJSON:(NSDictionary*)weatherDict
{
    if (self = [super init])
    {
        _timeOfLastUpdate = [weatherDict dateForKey:@"timeOfLastUpdate"];
        _timeOfNextPull   = [weatherDict dateForKey:@"timeOfNextPull"];

        _sunriseInSecondsSinceMidnight = [weatherDict integerForKey:@"sunrise"];
        _sunsetInSecondsSinceMidnight = [weatherDict integerForKey:@"sunset"];

        _neighborhoods = [[NSMutableArray alloc] init];
        for (NSDictionary *jsonRecord in [weatherDict arrayForKey:@"neighborhoods"])
        {
            NSString *name = [jsonRecord stringForKey:@"name"];
            
            CGRect rect = CGRectMake([jsonRecord doubleForKey:@"x"],
                                     [jsonRecord doubleForKey:@"y"],
                                     [jsonRecord doubleForKey:@"width"],
                                     [jsonRecord doubleForKey:@"height"]);
            
            [_neighborhoods addObject:[[Neighborhood alloc] initWithName:name rect:rect]];
        }

        _observations = [[NSMutableDictionary alloc] init];
        
        for (NSDictionary *jsonRecord in [weatherDict arrayForKey:@"observations"])
        {
            Observation *observation = [[Observation alloc] initWithJSON:jsonRecord];
            [_observations setObject:observation forKey:[observation name]];
        }

        _forecasts = [[NSMutableDictionary alloc] init];
        for (NSArray *jsonSubArray in [weatherDict arrayForKey:@"forecasts"])
        {
            for (NSDictionary *jsonRecord in jsonSubArray)
            {
                Forecast *forecast = [[Forecast alloc] initWithJSON:jsonRecord];
                NSMutableArray *forecastsArray = [_forecasts objectForKey:[forecast name]];
                if (!forecastsArray)
                {
                    forecastsArray = [[NSMutableArray alloc] init];
                    [_forecasts setObject:forecastsArray forKey:[forecast name]];
                }
                [forecastsArray addObject:forecast];
            }
        }
        
        _loaded = YES;
    }
    return self;
}

- (NSArray*)neighborhoods
{
    return _neighborhoods;
}

- (NSArray*)observations
{
    return [_observations allValues];
}

- (Observation*)observationForNeighborhood:(NSString*)name
{
    return [_observations objectForKey:name];
}

- (NSArray*)forecastsForNeighborhood:(NSString*)name
{
    return [_forecasts objectForKey:name];
}

-(BOOL)isNight
{
    // Determine the number of seconds since midnight of the current day according to the time on the phone.
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
        
        NSInteger currentSecondsSinceMidnight = ((hours*60)+minutes)*60 + seconds;
        isNight = (currentSecondsSinceMidnight < _sunriseInSecondsSinceMidnight ||
                   currentSecondsSinceMidnight > _sunsetInSecondsSinceMidnight);
    }
    return isNight;
}

@end

