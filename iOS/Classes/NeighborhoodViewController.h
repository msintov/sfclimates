//
//  NeighborhoodViewController.h
//  sfmcs
//
//  Created by Michelle Sintov on 9/6/11.
//  Copyright 2015 Baker Beach Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherDataModel.h"
#import "ConditionImages.h"


@interface NeighborhoodViewController : UIViewController <UITableViewDataSource>
{
}

@property (nonatomic, retain) WeatherDataModel *weatherDataModel;
@property (nonatomic, retain) NSString *neighborhoodName;
@property (nonatomic, retain) Observation *observation;
@property (nonatomic, retain) NSArray *arrayOfForecastsForNeighborhood;

@property(nonatomic, retain) IBOutlet UILabel*           neighborhoodNameLabel;
@property(nonatomic, retain) IBOutlet UIImageView*       neighborhoodBackgroundImageView;
@property(nonatomic, retain) IBOutlet UILabel*           currentWind;
@property(nonatomic, retain) IBOutlet UIImageView*       currentWindDirection;
@property(nonatomic, retain) IBOutlet UIImageView*       currentConditionImage;
@property(nonatomic, retain) IBOutlet UILabel*           currentTemp;
@property(nonatomic, retain) IBOutlet UILabel*           currentConditionDescription;

@property(nonatomic, retain) IBOutlet UITableView*       forecastTableView;
@property(nonatomic, assign) IBOutlet UITableViewCell*   forecastTableViewCell;

@end
