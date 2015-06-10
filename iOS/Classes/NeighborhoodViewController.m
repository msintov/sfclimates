//
//  NeighborhoodViewController.m
//  sfmcs
//
//  Created by Michelle Sintov on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NeighborhoodViewController.h"
#import "NSDate+Formatters.h"

@implementation NeighborhoodViewController

@synthesize weatherDataModel;
@synthesize neighborhoodBackgroundImageView;
@synthesize neighborhoodName;
@synthesize neighborhoodNameLabel;
@synthesize currentWind;
@synthesize currentWindDirection;
@synthesize currentConditionImage;
@synthesize currentTemp;
@synthesize currentConditionDescription;
@synthesize forecastTableView;
@synthesize forecastTableViewCell;
@synthesize observation;
@synthesize arrayOfForecastsForNeighborhood;

- (void)refreshInstanceData
{
    NSDictionary *weatherDict = weatherDataModel.weatherDict;
	if (!weatherDict) return;

    self.observation = [weatherDataModel observationForNeighborhood:neighborhoodName];

	// FIXME: make this not a linear scan for neighborhoodName.
	NSArray *forecastsNSArray = [weatherDict objectForKey:@"forecasts"];
	for (NSArray *neighborhoodNSArray in forecastsNSArray)
	{
        // Get the first element in the array, which is a dict.
        // Does that dict have the neighborhoodName we're looking for?
        // If yes, break.
        //
        // First array element in arrayOfForecastsForNeighborhood is today's forecast (or older, if server is serving old data).
        NSDictionary *dict = [neighborhoodNSArray objectAtIndex:0];
		if ([neighborhoodName compare:[dict objectForKey:@"name"]] == NSOrderedSame)
		{
            NSRange rangeOfForecastDays;
            rangeOfForecastDays.location = 0;
            rangeOfForecastDays.length = [neighborhoodNSArray count];
            
            // Bandaid: the server could have old data where the first entry is for yesterday,
            // but we want the first entry in arrayOfForecastsForNeighborhood to be today.
            // We bump out by one day max.
            //
            // Retrieve the weekday name from the json.
            NSDictionary *forecastDict = [neighborhoodNSArray objectAtIndex:0];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[forecastDict objectForKey:@"epoch"] doubleValue]];
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
                self.arrayOfForecastsForNeighborhood = [neighborhoodNSArray subarrayWithRange:rangeOfForecastDays];
            }
            @catch (NSException *exception) {
                DLog(@"In calling subarrayWithRange on arrayOfForecastsForNeighborhood: Caught %@: %@", [exception name], [exception reason]);
            }

			break;
		}
	}
	return;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	self.navigationItem.title = @"Currently";
    
    [forecastTableView setAllowsSelection:NO];
    forecastTableView.dataSource = self;

    [self drawNewData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
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

- (void)drawNewData {
    [self refreshInstanceData];

	if (!self.observation || !self.arrayOfForecastsForNeighborhood)
    {
        return;
    }

    [forecastTableView reloadData];

    // Draw neighborhood name and icon at the top.
    self.neighborhoodNameLabel.text = self.neighborhoodName;

	// Draw current temp text
    int currentTempInt = (int)[self.observation temperature];
	self.currentTemp.text = [[UtilityMethods sharedInstance] makeTemperatureString:currentTempInt showDegree:NO];
    
    // Draw wind mph text
    int currentWindInt = (int)[self.observation wind];
    self.currentWind.text = [NSString stringWithFormat:@"%d", currentWindInt];
    
    // Rotate the according to wind direction (degrees) 0==North 90==East 180==South 270==West...
    // consider hiding the pointer on the ring if currentWindDirectionInt == 0 
    int currentWindDirectionInt = (int)[self.observation windDirection];
    if (currentWindInt != 0)
    {
        currentWindDirection.autoresizingMask = UIViewAutoresizingNone;
        currentWindDirection.transform = CGAffineTransformMakeRotation(currentWindDirectionInt*(M_PI/180));
    }
    else
    {
        currentWindDirection.hidden = YES;
    }   

	// Draw description of current condition
    NSString *currentConditionString = [self.observation condition];
	self.currentConditionDescription.text = currentConditionString;

	BOOL isNight = [weatherDataModel isNight];

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
	[currentConditionImage setImage:[[UtilityMethods sharedInstance] getConditionImage:currentConditionString withIsNight:isNight withIconSize:largeConditionIcon]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayOfForecastsForNeighborhood count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Forecast";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"NeighborhoodForecastCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"NeighborhoodTableViewCell" owner:self options:nil];
        
        // See documentation as to why we load cells from Nibs this way:
        // http://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/TableView_iPhone/TableViewCells/TableViewCells.html#//apple_ref/doc/uid/TP40007451-CH7-SW20
        cell = forecastTableViewCell;
        self.forecastTableViewCell = nil;
    }
    
    NSDictionary *forecastDict = [self.arrayOfForecastsForNeighborhood objectAtIndex:[indexPath row]];

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
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[forecastDict objectForKey:@"epoch"] doubleValue]];
        label.text = [date weekdayString];
    }
    
    // TAG 2: Condition text
    label = (UILabel *)[cell viewWithTag:2];
    label.text = [forecastDict objectForKey:@"forecast_condition"];

    // Add propability of precipitation, if it exists.
    int forecastPopInt = [[forecastDict objectForKey:@"forecast_pop"] intValue];
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
    NSString *scratchForecastConditionNSString = [forecastDict objectForKey:@"forecast_condition"];
    if (forecastPopInt > 0 && forecastPopInt < 40)
    {
        scratchForecastConditionNSString = @"cloudy";
    }
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:3];
    if (indexPath.row == 0)
    {
        BOOL isNight = [weatherDataModel isNight];
        [imageView setImage:[[UtilityMethods sharedInstance] getConditionImage:scratchForecastConditionNSString withIsNight:isNight withIconSize:mediumConditionIcon]];
    }
    else
    {
        [imageView setImage:[[UtilityMethods sharedInstance] getConditionImage:scratchForecastConditionNSString withIsNight:NO withIconSize:mediumConditionIcon]];
    }

    // TAG 4: High temperature
    label = (UILabel *)[cell viewWithTag:4];
    label.text = [[UtilityMethods sharedInstance] makeTemperatureString:[[forecastDict objectForKey:@"forecast_high_temperature"] intValue] showDegree:YES];

    // TAG 5: Low temperature
    label = (UILabel *)[cell viewWithTag:5];
    label.text = [[UtilityMethods sharedInstance] makeTemperatureString:[[forecastDict objectForKey:@"forecast_low_temperature"] intValue]  showDegree:YES];

    return cell;
}

@end
