//
//  SegmentsController.m
//  sfmcs
//
//  Created by Michelle Sintov on 2/16/12.
//  Copyright (c) 2012 Baker Beach Software. All rights reserved.
//

#import "SegmentsController.h"

@interface SegmentsController ()
@property (nonatomic, retain, readwrite) NSArray                *viewControllers;
@property (nonatomic, retain, readwrite) UINavigationController *navigationController;
@end

@implementation SegmentsController

@synthesize viewControllers, navigationController;

- (id)initWithNavigationController:(UINavigationController *)aNavigationController viewControllers:(NSArray *)theViewControllers {
    if (self = [super init]) {
        self.navigationController = aNavigationController;
        self.viewControllers = theViewControllers;
    }
    return self;
}

- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)aSegmentedControl {
    NSUInteger index = aSegmentedControl.selectedSegmentIndex;
    UIViewController * incomingViewController = [self.viewControllers objectAtIndex:index];
    
    NSArray * theViewControllers = [NSArray arrayWithObject:incomingViewController];
    [self.navigationController setViewControllers:theViewControllers animated:NO];
    
    incomingViewController.navigationItem.titleView = aSegmentedControl;
}

- (void)dealloc {
    self.viewControllers = nil;
    self.navigationController = nil;
}

@end