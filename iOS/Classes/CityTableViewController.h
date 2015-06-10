//
//  CityTableViewController.h
//  sfmcs
//
//  Created by Michelle Sintov on 2/16/12.
//  Copyright (c) 2012 Baker Beach Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherDataModel.h"
#import "ConditionImages.h"

@interface CityTableViewController : UITableViewController

@property(nonatomic,retain) WeatherDataModel*           weatherDataModel;
@property(atomic,retain) NSDictionary*                  sections;
@property(nonatomic, retain) IBOutlet UITableView*      cityTableView;
@property(nonatomic, assign) IBOutlet UITableViewCell*  cityTableViewCell;

@end
