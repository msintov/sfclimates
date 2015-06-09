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

@interface CityViewController : UIViewController <RequestRedrawDelegate>
{
	NSDictionary *colorToNeighborhoodHitTestDict;
    NSDictionary *nameToTempViewDict;
    NSDictionary *nameToCondViewDict;
}

@property(nonatomic,retain) IBOutlet UILabel*               lastUpdated;
@property(nonatomic, retain) id<ShowSettings>               settingsDelegate;

@property(nonatomic,retain) IBOutlet UIImageView*           cityMapImageView;

@property(nonatomic,retain) IBOutlet UILabel*               tempBayview;
@property(nonatomic,retain) IBOutlet UILabel*               tempCastro;
@property(nonatomic,retain) IBOutlet UILabel*               tempColeValley;
@property(nonatomic,retain) IBOutlet UILabel*               tempFinancialDistrict;
@property(nonatomic,retain) IBOutlet UILabel*               tempGlenPark;
@property(nonatomic,retain) IBOutlet UILabel*               tempHayesValley;
@property(nonatomic,retain) IBOutlet UILabel*               tempInnerRichmond;
@property(nonatomic,retain) IBOutlet UILabel*               tempLakeMerced;
@property(nonatomic,retain) IBOutlet UILabel*               tempMission;
@property(nonatomic,retain) IBOutlet UILabel*               tempNoeValley;
@property(nonatomic,retain) IBOutlet UILabel*               tempNorthBeach;
@property(nonatomic,retain) IBOutlet UILabel*               tempOuterRichmond;
@property(nonatomic,retain) IBOutlet UILabel*               tempOuterSunset;
@property(nonatomic,retain) IBOutlet UILabel*               tempPotreroHill;
@property(nonatomic,retain) IBOutlet UILabel*               tempPresidio;
@property(nonatomic,retain) IBOutlet UILabel*               tempSOMA;
@property(nonatomic,retain) IBOutlet UILabel*               tempTwinPeaks;
@property(nonatomic,retain) IBOutlet UILabel*               tempWestPortal;

@property(nonatomic,retain) IBOutlet UIImageView*           condBayview;
@property(nonatomic,retain) IBOutlet UIImageView*           condCastro;
@property(nonatomic,retain) IBOutlet UIImageView*           condColeValley;
@property(nonatomic,retain) IBOutlet UIImageView*           condFinancialDistrict;
@property(nonatomic,retain) IBOutlet UIImageView*           condGlenPark;
@property(nonatomic,retain) IBOutlet UIImageView*           condHayesValley;
@property(nonatomic,retain) IBOutlet UIImageView*           condInnerRichmond;
@property(nonatomic,retain) IBOutlet UIImageView*           condLakeMerced;
@property(nonatomic,retain) IBOutlet UIImageView*           condMission;
@property(nonatomic,retain) IBOutlet UIImageView*           condNoeValley;
@property(nonatomic,retain) IBOutlet UIImageView*           condNorthBeach;
@property(nonatomic,retain) IBOutlet UIImageView*           condOuterRichmond;
@property(nonatomic,retain) IBOutlet UIImageView*           condOuterSunset;
@property(nonatomic,retain) IBOutlet UIImageView*           condPotreroHill;
@property(nonatomic,retain) IBOutlet UIImageView*           condPresidio;
@property(nonatomic,retain) IBOutlet UIImageView*           condSOMA;
@property(nonatomic,retain) IBOutlet UIImageView*           condTwinPeaks;
@property(nonatomic,retain) IBOutlet UIImageView*           condWestPortal;

@property(nonatomic,retain) IBOutlet UIButton*              refreshButton;

@property(nonatomic,retain) WeatherDataModel*               weatherDataModel;

@end
