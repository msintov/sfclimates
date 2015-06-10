//
//  WeatherDataLoader.h
//  sfmcs
//
//
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
