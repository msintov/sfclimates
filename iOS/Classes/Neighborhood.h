//
//  Neighborhood.h
//  sfmcs
//
//
//  Copyright 2015 Baker Beach Software, LLC. All rights reserved.
//

#ifndef sfmcs_Neighborhood_h
#define sfmcs_Neighborhood_h

#import <Foundation/Foundation.h>
#import "Observation.h"

@interface Neighborhood : NSObject
{
}

@property (nonatomic, readonly) NSString *name;
@property (nonatomic) CGRect rect;
@property (nonatomic, readonly) Observation *observation;
@property (nonatomic, readonly) NSArray *forecasts;

- (id)initWithName:(NSString*)name rect:(CGRect)rect observation:(Observation*)observation forecasts:(NSArray*)forecasts;

@end

#endif
