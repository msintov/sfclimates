//
//  Neighborhood.h
//  sfmcs
//
//  Created by Gary Grossman on 1/17/15.
//
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
