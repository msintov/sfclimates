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

@synthesize pathToWeatherDataPlist, weatherDataConnectionDelegate, weatherDict;

- (void)dealloc {
	[pathToWeatherDataPlist release];
    self.weatherDict = nil;
    
    [super dealloc];
}

- (id)init {
    self = [super init];

	self.weatherDict = [NSDictionary dictionaryWithContentsOfFile:[self pathToWeatherDataPlist]];
    
	if (!self.weatherDict) {
		DLog(@"Got nil weather dict. Either cached plist does not yet exist(such as upon first app launch), could not be opened, contents could not be parsed into an array, or other failure.");
	}    
    
    return self;
}

- (NSString*)pathToWeatherDataPlist
{
	if (!pathToWeatherDataPlist)
	{
		// Retrive ~/Documents directory
		NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		pathToWeatherDataPlist = [rootPath stringByAppendingPathComponent:@"WeatherData.plist"];
		[pathToWeatherDataPlist retain];
	}	
	return pathToWeatherDataPlist;
}

- (void)releaseNetworkInstanceVariables
{
	[myConnection release]; myConnection = nil;
	[receivedData release]; receivedData = nil;
}

- (void)retrieveWeatherDataFromServer
{
	// Check to ensure we don't already have a connection in progress.
	// Note that this function has a race condition between where
	// myConnection is checked and where it is set, so if we ever call
	// this on a thread, need some locking in here.
	if (myConnection) return;

	// Create the request with 20 second timeout.
	// IMPORTANT: Must replace the url with a valid url pointing to properly formatted JSON. Contact Michelle Sintov for more details.
	NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.url.com/current-observations.json"]
											   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
										   timeoutInterval:20.0];

	UIApplication *app = [UIApplication sharedApplication]; 
	app.networkActivityIndicatorVisible = YES; 

	// create the connection with the request and start loading the data
	myConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (myConnection) {
		receivedData = [[NSMutableData data] retain];
	} else {
		DLog(@"NSURLConnection could not be initialized in retrieveWeatherDataFromServer");
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	// This method is called when the server has determined that it
	// has enough information to create the NSURLResponse.
	//
	// It can be called multiple times, for example in the case of a
	// redirect, so each time we reset the data.
	[receivedData setLength:0];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	UIApplication *app = [UIApplication sharedApplication]; 
	app.networkActivityIndicatorVisible = NO; 

	NSString *stringFromServer = [[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding] autorelease];
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
    
	[self.weatherDataConnectionDelegate weatherDataConnectionDidFinishLoading];
	[self releaseNetworkInstanceVariables];
	
	return;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	UIApplication *app = [UIApplication sharedApplication]; 
	app.networkActivityIndicatorVisible = NO; 
	
	[self.weatherDataConnectionDelegate weatherDataConnectionDidFail];
	[self releaseNetworkInstanceVariables];

	DLog(@"Connection failed in didFailWithError. Error - %@", [error localizedDescription]);
}

@end
