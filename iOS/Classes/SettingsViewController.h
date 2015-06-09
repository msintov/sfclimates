//
//  SettingsViewController.h
//  sfmcs
//
//  Created by Michelle Sintov on 2/21/12.
//  Copyright (c) 2012 Baker Beach Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property(nonatomic,retain) IBOutlet UISegmentedControl* degreesControl;
@property(nonatomic,retain) IBOutlet UILabel* buildNumberLabel;

- (IBAction)degreesChanged:(id)sender;

@end
