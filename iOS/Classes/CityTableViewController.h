//
//  CityTableViewController.h
//  sfmcs
//
//  Created by Michelle Sintov on 2/16/12.
//  Copyright (c) 2012 Baker Beach Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherDataModel.h"
#import "UtilityMethods.h"

@interface CityTableViewController : UITableViewController <RequestRedrawDelegate>
{
    BOOL isNight;
}

@property(nonatomic,retain) WeatherDataModel*           weatherDataModel;
@property(atomic,retain) NSDictionary*                  sections;
@property(nonatomic, assign) IBOutlet UITableViewCell*  cityTableViewCell;
@property(nonatomic, retain) id<ShowSettings>           settingsDelegate;

@end
