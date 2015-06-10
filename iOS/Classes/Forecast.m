//
//  Forecast.m
//  sfmcs
//
//
//

#import "Forecast.h"
#import "NSDictionary+JSONHelpers.h"

@implementation Forecast

- (id)initWithJSON:(NSDictionary*)jsonRecord
{
    if (self = [super init])
    {
        _date = [jsonRecord dateForKey:@"epoch"];
        _name = [jsonRecord stringForKey:@"name"];
        _highTemperature = [jsonRecord doubleForKey:@"forecast_high_temperature"];
        _lowTemperature = [jsonRecord doubleForKey:@"forecast_low_temperature"];
        _precipitation = [jsonRecord doubleForKey:@"forecast_pop"];
        _condition = [jsonRecord stringForKey:@"forecast_condition"];
    }
    return self;
}

@end
