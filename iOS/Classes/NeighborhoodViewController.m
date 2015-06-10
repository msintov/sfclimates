//
//  NeighborhoodViewController.m
//  sfmcs
//
//  Created by Michelle Sintov on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NeighborhoodViewController.h"
#import "NSDate+Formatters.h"
#import "NSString+Temperature.h"
#import "Constants.h"

@implementation NeighborhoodViewController
{
    id<NSObject> _modelObserver;
}

- (void)refreshInstanceData
{
    Neighborhood *neighborhood = [_weatherDataModel neighborhoodByName:_neighborhoodName];
    _observation = [neighborhood observation];

    NSArray *forecasts = [neighborhood forecasts];
    
    NSRange rangeOfForecastDays;
    rangeOfForecastDays.location = 0;
    rangeOfForecastDays.length = [forecasts count];
    
    // Bandaid: the server could have old data where the first entry is for yesterday,
    // but we want the first entry in arrayOfForecastsForNeighborhood to be today.
    // We bump out by one day max.
    //
    // Retrieve the weekday name from the json.
    Forecast *forecast = [forecasts objectAtIndex:0];
    NSDate *date = [forecast date];
    NSString *weekdayJSON = [date weekdayString];
    
    // Compute the current weekday name according to the device time.
    NSString *weekdayDevice = [[NSDate date] weekdayString];
    
    // Bump the range up by one day if server data is indeed old.
    if ([weekdayJSON localizedCaseInsensitiveCompare:weekdayDevice] != NSOrderedSame)
    {
        rangeOfForecastDays.location = rangeOfForecastDays.location + 1;
        rangeOfForecastDays.length -= 1;
    }
    
    // Don't display more than 7 days of forecast
    if (rangeOfForecastDays.length > 7)
    {
        rangeOfForecastDays.length = 7;
    }

    @try {
        self.arrayOfForecastsForNeighborhood = [forecasts subarrayWithRange:rangeOfForecastDays];
    }
    @catch (NSException *exception) {
        DLog(@"In calling subarrayWithRange on arrayOfForecastsForNeighborhood: Caught %@: %@", [exception name], [exception reason]);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = _neighborhoodName;

    [_forecastTableView setAllowsSelection:NO];
    _forecastTableView.dataSource = self;

    [self drawNewData];
    
    _modelObserver = [[NSNotificationCenter defaultCenter] addObserverForName:ModelChangedNotificationName
                                                                       object:nil queue:nil
                                                                   usingBlock:^(NSNotification *note) {
                                                                       _weatherDataModel = [[note userInfo] objectForKey:@"model"];
                                                                       [self drawNewData];
                                                                   }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [[NSNotificationCenter defaultCenter] removeObserver:_modelObserver];

    self.forecastTableView = nil;
    self.neighborhoodBackgroundImageView = nil;
    self.neighborhoodNameLabel = nil;
    self.currentWind = nil;
    self.currentWindDirection = nil;
    self.currentConditionImage = nil;
    self.currentTemp = nil;
    self.currentConditionDescription = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}
*/

- (UIImage*)getNeighborhoodIcon:(NSString*)fullNeighborhoodName
{
    @try {
        NSString *modifiedNeighborhoodName = @"neighborhood";
        modifiedNeighborhoodName = [modifiedNeighborhoodName stringByAppendingString:[fullNeighborhoodName stringByReplacingOccurrencesOfString:@" " withString:@""]];
        modifiedNeighborhoodName = [modifiedNeighborhoodName stringByAppendingString:@"Icon"];
        
        return [UIImage imageNamed:modifiedNeighborhoodName];
    }
    @catch (NSException *exception) {
        return nil;
    }
}

- (void)drawNewData
{
    [self refreshInstanceData];

	if (!self.observation || !self.arrayOfForecastsForNeighborhood)
    {
        return;
    }

    [_forecastTableView reloadData];

    // Draw neighborhood name and icon at the top.
    self.neighborhoodNameLabel.text = self.neighborhoodName;

	// Draw current temp text
    int currentTempInt = (int)[self.observation temperature];
	self.currentTemp.text = [NSString formatTemperature:currentTempInt showDegree:NO];
    
    // Draw wind mph text
    int currentWindInt = (int)[self.observation wind];
    self.currentWind.text = [NSString stringWithFormat:@"%d", currentWindInt];
    
    // Rotate the according to wind direction (degrees) 0==North 90==East 180==South 270==West...
    // consider hiding the pointer on the ring if currentWindDirectionInt == 0 
    int currentWindDirectionInt = (int)[self.observation windDirection];
    if (currentWindInt != 0)
    {
        _currentWindDirection.autoresizingMask = UIViewAutoresizingNone;
        _currentWindDirection.transform = CGAffineTransformMakeRotation(currentWindDirectionInt*(M_PI/180));
    }
    else
    {
        _currentWindDirection.hidden = YES;
    }   

	// Draw description of current condition
    NSString *currentConditionString = [self.observation condition];
	self.currentConditionDescription.text = currentConditionString;

	BOOL isNight = [_weatherDataModel isNight];

    // Set background for neighborhood current conditions.
    if (isNight)
    {
        [self.neighborhoodBackgroundImageView setImage:[UIImage imageNamed:@"neighborhoodBackgroundNight"]];
    }
    else
    {
        [self.neighborhoodBackgroundImageView setImage:[UIImage imageNamed:@"neighborhoodBackgroundDay"]];        
    }

	// Draw image of current conditions
	[_currentConditionImage setImage:[[ConditionImages sharedInstance] getConditionImage:currentConditionString withIsNight:isNight withIconSize:largeConditionIcon]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayOfForecastsForNeighborhood count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Forecast";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"NeighborhoodForecastCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"NeighborhoodTableViewCell" owner:self options:nil];
        
        // See documentation as to why we load cells from Nibs this way:
        // http://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/TableView_iPhone/TableViewCells/TableViewCells.html#//apple_ref/doc/uid/TP40007451-CH7-SW20
        cell = _forecastTableViewCell;
        self.forecastTableViewCell = nil;
    }
    
    Forecast *forecast = [self.arrayOfForecastsForNeighborhood objectAtIndex:[indexPath row]];

    // TAG 1: Weekday name
    //
    // Get epoch from the json and convert to day of the week (e.g., "Thursday")
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    if (indexPath.row == 0)
    {
        label.text = @"Today";
    }
    else
    {
        label.text = [[forecast date] weekdayString];
    }
    
    // TAG 2: Condition text
    label = (UILabel *)[cell viewWithTag:2];
    label.text = [forecast condition];

    // Add propability of precipitation, if it exists.
    int forecastPopInt = (int)[forecast precipitation];
    if (forecastPopInt > 0)
    {
        @try {
            label.text = [label.text stringByAppendingString:@", "];
            label.text = [label.text stringByAppendingString:[NSString stringWithFormat:@"%d", forecastPopInt]];
            label.text = [label.text stringByAppendingString:@"%"];
        }
        @catch (NSException *exception) {
            DLog(@"Exception thrown in stringByAppendingString in NeighborhoodViewController");
        }
    }
    
    // TAG 3: Condition icon
    //show the night icon for the forecast if we are viewing night UI
    //
    // If the chance of precipitation is < 40%, show the cloudy icon instead of the rain icon.
    NSString *scratchForecastConditionNSString = [forecast condition];
    if (forecastPopInt > 0 && forecastPopInt < 40)
    {
        scratchForecastConditionNSString = @"cloudy";
    }
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:3];
    if (indexPath.row == 0)
    {
        BOOL isNight = [_weatherDataModel isNight];
        [imageView setImage:[[ConditionImages sharedInstance] getConditionImage:scratchForecastConditionNSString withIsNight:isNight withIconSize:mediumConditionIcon]];
    }
    else
    {
        [imageView setImage:[[ConditionImages sharedInstance] getConditionImage:scratchForecastConditionNSString withIsNight:NO withIconSize:mediumConditionIcon]];
    }

    // TAG 4: High temperature
    label = (UILabel *)[cell viewWithTag:4];
    label.text = [NSString formatTemperature:(int)[forecast highTemperature] showDegree:YES];

    // TAG 5: Low temperature
    label = (UILabel *)[cell viewWithTag:5];
    label.text = [NSString formatTemperature:(int)[forecast lowTemperature] showDegree:YES];

    return cell;
}

@end
