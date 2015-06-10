//
//  CityViewController.h
//  sfmcs
//
//  Created by Michelle Sintov on 9/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherDataModel.h"
#import "UtilityMethods.h"

@interface CityViewController : UIViewController
{
	NSDictionary *colorToNeighborhoodHitTestDict;
    NSMutableDictionary *nameToTempViewDict;
    NSMutableDictionary *nameToCondViewDict;
}

@property(nonatomic,retain) IBOutlet UILabel*               lastUpdated;
@property(nonatomic,retain) id<ShowSettings>                settingsDelegate;
@property(nonatomic,retain) IBOutlet UIImageView*           cityMapImageView;
@property(nonatomic,retain) IBOutlet UIButton*              refreshButton;

@property(nonatomic,retain) WeatherDataModel*               weatherDataModel;

@end
