//
//  WeatherDataModel.m
//  sfmcs
//
//  Created by Michelle Sintov on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WeatherDataModel.h"
#import "JSON.h"
#import "NSDictionary+JSONHelpers.h"

@interface WeatherDataModel()
@property (nonatomic, readonly, retain) NSString *pathToWeatherDataPlist;
@end

@implementation WeatherDataModel
{
    NSURLSession *_urlSession;
    NSMutableArray *_neighborhoods;
    NSMutableDictionary *_observations;
    NSMutableDictionary *_forecasts;
    int _sunriseInSecondsSinceMidnight;
    int _sunsetInSecondsSinceMidnight;
}

- (id)init
{
    if (self = [super init])
    {
        _neighborhoods = [[NSMutableArray alloc] init];
        _observations  = [[NSMutableDictionary alloc] init];
        _forecasts     = [[NSMutableDictionary alloc] init];

        NSDictionary *weatherDict = [NSDictionary dictionaryWithContentsOfFile:[self pathToWeatherDataPlist]];
        
        if (!weatherDict) {
            DLog(@"Got nil weather dict. Either cached plist does not yet exist(such as upon first app launch), could not be opened, contents could not be parsed into an array, or other failure.");
        }
        else
        {
            [self parseWeatherData:weatherDict];
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
                                                
                                                NSDictionary *weatherDict = [stringFromServer JSONValue];
                                                if (!weatherDict) return;
                                                
                                                [self parseWeatherData:weatherDict];
                                                
                                                // Persist data to .plist file.
                                                if (![weatherDict writeToFile:[self pathToWeatherDataPlist] atomically:YES])
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

- (void)parseWeatherData:(NSDictionary*)weatherDict
{
    _timeOfLastUpdate = [weatherDict dateForKey:@"timeOfLastUpdate"];
    _timeOfNextPull   = [weatherDict dateForKey:@"timeOfNextPull"];

    _sunriseInSecondsSinceMidnight = [weatherDict integerForKey:@"sunrise"];
    _sunsetInSecondsSinceMidnight = [weatherDict integerForKey:@"sunset"];

    _neighborhoods = [[NSMutableArray alloc] init];
    for (NSDictionary *jsonRecord in [weatherDict arrayForKey:@"neighborhoods"])
    {
        NSString *name = [jsonRecord stringForKey:@"name"];
        
        CGRect rect = CGRectMake([jsonRecord doubleForKey:@"x"],
                                 [jsonRecord doubleForKey:@"y"],
                                 [jsonRecord doubleForKey:@"width"],
                                 [jsonRecord doubleForKey:@"height"]);
        
        [_neighborhoods addObject:[[Neighborhood alloc] initWithName:name rect:rect]];
    }

    _observations = [[NSMutableDictionary alloc] init];
    
    for (NSDictionary *jsonRecord in [weatherDict arrayForKey:@"observations"])
    {
        Observation *observation = [[Observation alloc] initWithJSON:jsonRecord];
        [_observations setObject:observation forKey:[observation name]];
    }

    _forecasts = [[NSMutableDictionary alloc] init];
    for (NSArray *jsonSubArray in [weatherDict arrayForKey:@"forecasts"])
    {
        for (NSDictionary *jsonRecord in jsonSubArray)
        {
            Forecast *forecast = [[Forecast alloc] initWithJSON:jsonRecord];
            NSMutableArray *forecastsArray = [_forecasts objectForKey:[forecast name]];
            if (!forecastsArray)
            {
                forecastsArray = [[NSMutableArray alloc] init];
                [_forecasts setObject:forecastsArray forKey:[forecast name]];
            }
            [forecastsArray addObject:forecast];
        }
    }
    
    _loaded = YES;
}

- (NSArray*)neighborhoods
{
    return _neighborhoods;
}

- (NSArray*)observations
{
    return [_observations allValues];
}

- (Observation*)observationForNeighborhood:(NSString*)name
{
    return [_observations objectForKey:name];
}

- (NSArray*)forecastsForNeighborhood:(NSString*)name
{
    return [_forecasts objectForKey:name];
}

-(BOOL)isNight
{
    // Determine the number of seconds since midnight of the current day according to the time on the phone.
    BOOL isNight = NO;
    
    NSTimeZone* pacificTimeZone = [NSTimeZone timeZoneWithName:@"America/Los_Angeles"];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:pacificTimeZone];
    
    NSDateComponents *components = [calendar components:kCFCalendarUnitSecond|kCFCalendarUnitHour|kCFCalendarUnitMinute fromDate:[NSDate date]];
    if (components)
    {
        NSInteger seconds = [components second];
        NSInteger hours = [components hour];
        NSInteger minutes = [components minute];
        
        NSInteger currentSecondsSinceMidnight = ((hours*60)+minutes)*60 + seconds;
        isNight = (currentSecondsSinceMidnight < _sunriseInSecondsSinceMidnight ||
                   currentSecondsSinceMidnight > _sunsetInSecondsSinceMidnight);
    }
    return isNight;
}

@end

