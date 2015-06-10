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

@interface WeatherDataModel : NSObject {
 @private
    BOOL _downloadInProgress;
    NSString *pathToWeatherDataPlist;
}

@property (nonatomic, retain) NSDate *timeOfLastUpdate;
@property (nonatomic, retain) NSDate *timeOfNextPull;
@property (nonatomic) BOOL loaded;

- (void)downloadWeatherDataWithCompletionHandler:(void (^)(NSError *))completionHandler;
- (NSArray*)neighborhoods;
- (NSArray*)observations;
- (Observation*)observationForNeighborhood:(NSString*)name;
- (NSArray*)forecastsForNeighborhood:(NSString*)name;
- (BOOL)isNight;

@end
