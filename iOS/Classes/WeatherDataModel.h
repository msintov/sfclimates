//
//  WeatherDataModel.h
//  sfmcs
//
//  Created by Michelle Sintov on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Neighborhood.h"
#import "Observation.h"
#import "Forecast.h"

@interface WeatherDataModel : NSObject

@property (nonatomic, readonly) NSDate *timeOfLastUpdate;
@property (nonatomic, readonly) NSDate *timeOfNextPull;
@property (nonatomic, readonly) BOOL isNight;

- (id)initWithJSON:(NSDictionary*)weatherDict;
- (NSArray*)neighborhoods;
- (Neighborhood*)neighborhoodByName:(NSString*)name;

@end
