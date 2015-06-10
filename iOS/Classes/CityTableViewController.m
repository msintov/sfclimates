//
//  CityTableViewController.m
//  sfmcs
//
//  Created by Michelle Sintov on 2/16/12.
//  Copyright (c) 2012 Baker Beach Software. All rights reserved.
//

#import "CityTableViewController.h"
#import "NeighborhoodViewController.h"

@implementation CityTableViewController

@synthesize weatherDataModel;
@synthesize sections;
@synthesize cityTableViewCell;
@synthesize settingsDelegate;

/*- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Add info button
    UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight]; 
    [infoButton addTarget:self.settingsDelegate action:@selector(showSettings) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self drawNewData];

    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)createTableSections:(NSDictionary*)weatherDict
{
	NSArray *observationsNSArray = [weatherDict objectForKey:@"observations"];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    for (NSDictionary *neighborhoodNSDictionary in observationsNSArray)
    {
        NSString *neighborhoodName = [neighborhoodNSDictionary objectForKey:@"name"];
        if (!neighborhoodName)
        {
            continue;
        }
        NSString *firstLetter = [neighborhoodName substringToIndex:1];

        NSMutableArray *letterArray = [dictionary objectForKey:firstLetter];
        if (!letterArray)
        {
            letterArray = [[NSMutableArray alloc] init];
            [dictionary setObject:letterArray forKey:firstLetter];
        }
        [letterArray addObject:neighborhoodNSDictionary];
    }
    
    self.sections = dictionary;
}

- (void)drawNewData
{
    NSDictionary *weatherDict = weatherDataModel.weatherDict;
	if (!weatherDict) return;

	isNight = [[UtilityMethods sharedInstance] isNight:weatherDict];
    
    [self createTableSections:weatherDict];

    [self.view performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.sections allKeys] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CityCurrentConditionCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"CityTableViewCell" owner:self options:nil];
        cell = cityTableViewCell;
        self.cityTableViewCell = nil;
    }

    NSDictionary *neighborhoodDict = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];

    UILabel *label = (UILabel *)[cell viewWithTag:1];
	label.text = [neighborhoodDict objectForKey:@"name"];
    
    label = (UILabel *)[cell viewWithTag:2];
    label.text = [neighborhoodDict objectForKey:@"current_condition"];

    UIImageView *imageView = (UIImageView *)[cell viewWithTag:3];
    [imageView setImage:[[UtilityMethods sharedInstance] getConditionImage:[neighborhoodDict objectForKey:@"current_condition"] withIsNight:isNight withIconSize:mediumConditionIcon]];

    label = (UILabel *)[cell viewWithTag:4];
    label.text = [[UtilityMethods sharedInstance] makeTemperatureString:[[neighborhoodDict objectForKey:@"current_temperature"] intValue] showDegree:YES];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *neighborhoodDict = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];

    NeighborhoodViewController *vc = [[NeighborhoodViewController alloc] init];
     
    vc.neighborhoodName = [neighborhoodDict objectForKey:@"name"];
    vc.weatherDataModel = self.weatherDataModel;
 
    [self.navigationController pushViewController:vc animated:YES];
}

@end
