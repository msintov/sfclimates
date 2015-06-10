//
//  WeatherDataModel.h
//  sfmcs
//
//  Created by Michelle Sintov on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Neighborhood.h"

@interface WeatherDataModel : NSObject {
 @private
    BOOL _downloadInProgress;
    NSString *pathToWeatherDataPlist;
}

@property (nonatomic, retain) NSDictionary *weatherDict;

- (void)downloadWeatherDataWithCompletionHandler:(void (^)(NSError *))completionHandler;
- (NSDate*)timeOfLastUpdate;
- (NSArray*)neighborhoods;

@end
