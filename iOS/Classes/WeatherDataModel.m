//
//  WeatherDataModel.m
//  sfmcs
//
//  Created by Michelle Sintov on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WeatherDataModel.h"
#import "JSON.h"

@interface WeatherDataModel()
@property (nonatomic, readonly, retain) NSString *pathToWeatherDataPlist;
@end

@implementation WeatherDataModel
{
    NSURLSession *_urlSession;
}

@synthesize pathToWeatherDataPlist, weatherDataConnectionDelegate, weatherDict;

- (id)init
{
    if (self = [super init])
    {
        self.weatherDict = [NSDictionary dictionaryWithContentsOfFile:[self pathToWeatherDataPlist]];
        
        if (!self.weatherDict) {
            DLog(@"Got nil weather dict. Either cached plist does not yet exist(such as upon first app launch), could not be opened, contents could not be parsed into an array, or other failure.");
        }
        
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        sessionConfig.timeoutIntervalForRequest  = 20.0;
        sessionConfig.timeoutIntervalForResource = 20.0;
        sessionConfig.HTTPMaximumConnectionsPerHost = 1;

        _urlSession = [NSURLSession sessionWithConfiguration:sessionConfig
                                                    delegate:nil
                                               delegateQueue:nil];
    }

    return self;
}

- (NSString*)pathToWeatherDataPlist
{
	if (!pathToWeatherDataPlist)
	{
		// Retrieve ~/Documents directory
		NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		pathToWeatherDataPlist = [rootPath stringByAppendingPathComponent:@"WeatherData.plist"];
	}
	return pathToWeatherDataPlist;
}

- (void)downloadWeatherDataWithCompletionHandler:(void (^)(NSError *))completionHandler
{
    UIApplication *app = [UIApplication sharedApplication];

    // Check to ensure we don't already have a connection in progress.
	// Note that this function has a race condition between where
	// myConnection is checked and where it is set, so if we ever call
	// this on a thread, need some locking in here.
	if (_downloadInProgress)
    {
        return;
    }

	// Create the request with 20 second timeout.
    // IMPORTANT: Must replace the url with a valid url pointing to properly formatted JSON. Contact Michelle Sintov for more details.
    NSURL *url = [NSURL URLWithString:@"http://www.url.com/current-observations.json"];
    NSURLSessionTask *task = [_urlSession dataTaskWithURL:url
                                        completionHandler:^(NSData *data,
                                                            NSURLResponse *response,
                                                            NSError *error) {
                                            app.networkActivityIndicatorVisible = NO;
                                            _downloadInProgress = NO;
                                            if (error != nil)
                                            {
                                                DLog(@"Connection failed in didFailWithError. Error - %@", [error localizedDescription]);
                                            }
                                            else
                                            {
                                                NSString *stringFromServer = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                if (stringFromServer == nil)
                                                {
                                                    DLog(@"Could not init NSString with network data using initWithData: encoding:.");
                                                    return;
                                                }
                                                
                                                self.weatherDict = [stringFromServer JSONValue];
                                                if (!self.weatherDict) return;
                                                
                                                // Persist data to .plist file.
                                                if (![self.weatherDict writeToFile:[self pathToWeatherDataPlist] atomically:YES])
                                                {
                                                    DLog(@"Failed to write server data to property list. Data from server was: %@", stringFromServer);
                                                    return;
                                                }
                                            }
                                            completionHandler(error);
                                        }];
    _downloadInProgress = YES;
    app.networkActivityIndicatorVisible = YES;
    [task resume];
}

@end
