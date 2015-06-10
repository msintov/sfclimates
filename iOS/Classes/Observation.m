//
//  Observation.m
//  sfmcs
//
//  Created by Gary Grossman on 1/17/15.
//
//

#import "Observation.h"

@implementation Observation

@synthesize name, condition;

- (id)initWithJSON:(NSDictionary *)jsonRecord
{
    if (self = [super init])
    {
        name = [jsonRecord objectForKey:@"name"];
        _temperature = [[jsonRecord objectForKey:@"current_temperature"] doubleValue];
        _wind = [[jsonRecord objectForKey:@"current_wind"] doubleValue];
        _windDirection = [[jsonRecord objectForKey:@"current_wind_direction"] doubleValue];
        condition = [jsonRecord objectForKey:@"current_condition"];
    }
    return self;
}


@end
