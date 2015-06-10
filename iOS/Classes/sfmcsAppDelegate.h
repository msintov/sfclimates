//
//  sfmcsAppDelegate.h
//  sfmcs
//
//  Created by Michelle Sintov on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherDataModel.h"
#import "CityViewController.h"
#include "SegmentsController.h"

@interface sfmcsAppDelegate : NSObject <UIApplicationDelegate, ShowSettings> {
	WeatherDataModel *weatherDataModel;
	NSTimer *networkRequestTimer;
	int numConsecutiveNetworkRequestFailures;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) SegmentsController *segmentsController;
@property (nonatomic, retain) UISegmentedControl *segmentedControl;

@end
 