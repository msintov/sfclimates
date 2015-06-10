//
//  SettingsViewController.m
//  sfmcs
//
//  Created by Michelle Sintov on 2/21/12.
//  Copyright (c) 2012 Baker Beach Software. All rights reserved.
//

#import "SettingsViewController.h"
#import "ConditionImages.h"
#import "Preferences.h"

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.navigationItem.title = @"About";
    
    @try {
        // Construct the build number for display
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        self.buildNumberLabel.text = [NSString stringWithFormat:@"Build %@.%@", version, build];
	}
	@catch (NSException *exception) {
		DLog(@"In constructing build number for SettingsViewController: Caught %@: %@", [exception name], [exception reason]);
	}
    
    BOOL celsius = [[Preferences sharedPreferences] celsiusMode];
    [self.degreesControl setSelectedSegmentIndex:celsius ? 1 : 0];
}

- (void)viewDidUnload
{
    self.buildNumberLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)drawNewData {
    // do nothing
}

- (IBAction)degreesChanged:(id)sender
{
    NSInteger index = [self.degreesControl selectedSegmentIndex];
    [[Preferences sharedPreferences] setCelsiusMode:(index == 1)];
}

/*
 - (void)didReceiveMemoryWarning
 {
 // Releases the view if it doesn't have a superview.
 [super didReceiveMemoryWarning];
 
 // Release any cached data, images, etc that aren't in use.
 }
 */

@end
