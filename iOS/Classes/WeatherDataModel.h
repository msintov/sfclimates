//
//  WeatherDataModel.h
//  sfmcs
//
//  Created by Michelle Sintov on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WeatherDataConnectionDelegate
- (void)weatherDataConnectionDidFinishLoading;
- (void)weatherDataConnectionDidFail;
@end

@interface WeatherDataModel : NSObject {
 @private
    BOOL _downloadInProgress;
    NSString *pathToWeatherDataPlist;
}

@property (nonatomic, assign) id <WeatherDataConnectionDelegate> weatherDataConnectionDelegate;
@property (nonatomic, retain) NSDictionary *weatherDict;

- (void)downloadWeatherDataWithCompletionHandler:(void (^)(NSError *))completionHandler;

@end
