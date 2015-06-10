//
//  sfmcsAppDelegate.h
//  sfmcs
//
//  Created by Michelle Sintov on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherDataModel.h"
#import "WeatherDataLoader.h"
#import "CityViewController.h"
#import "SegmentsController.h"

@interface sfmcsAppDelegate : NSObject <UIApplicationDelegate>
{
    WeatherDataLoader *_weatherDataLoader;
	WeatherDataModel  *_weatherDataModel;
	NSTimer           *_networkRequestTimer;
	int                _numConsecutiveNetworkRequestFailures;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) SegmentsController *segmentsController;
@property (nonatomic, retain) UISegmentedControl *segmentedControl;

@end
 