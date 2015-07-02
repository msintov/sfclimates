//
//  WeatherDataLoader.h
//  sfmcs
//
//  Copyright 2015 Baker Beach Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherDataModel.h"

@interface WeatherDataLoader : NSObject
{
    NSString     *_pathToWeatherDataPlist;
    NSURLSession *_urlSession;
}

@property (nonatomic, readonly) BOOL downloadInProgress;

- (WeatherDataModel*)loadCachedWeatherData;
- (void)downloadWeatherDataWithCompletionHandler:(void (^)(NSError *, WeatherDataModel*))completionHandler;

@end
