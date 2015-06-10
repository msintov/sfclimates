//
//  Neighborhood.m
//  sfmcs
//
//  Created by Gary Grossman on 1/17/15.
//
//

#import <Foundation/Foundation.h>
#import "Neighborhood.h"

@implementation Neighborhood

- (id)initWithName:(NSString*)name
              rect:(CGRect)rect
       observation:(Observation*)observation
         forecasts:(NSArray*)forecasts
{
    if (self = [super init])
    {
        _name        = name;
        _rect        = rect;
        _observation = observation;
        _forecasts   = forecasts;
    }
    return self;
}

@end