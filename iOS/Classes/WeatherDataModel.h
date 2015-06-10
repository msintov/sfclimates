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

extern NSString *ModelChangedNotificationName;

@interface WeatherDataModel : NSObject

@property (nonatomic, retain) NSDate *timeOfLastUpdate;
@property (nonatomic, retain) NSDate *timeOfNextPull;

- (id)initWithJSON:(NSDictionary*)weatherDict;
- (NSArray*)neighborhoods;
- (Neighborhood*)neighborhoodByName:(NSString*)name;
- (BOOL)isNight;

@end
