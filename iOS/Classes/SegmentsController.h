//
//  SegmentsController.h
//  sfmcs
//
//  Created by Michelle Sintov on 2/16/12.
//  Copyright (c) 2012 Baker Beach Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SegmentsController : NSObject

@property (nonatomic, retain, readonly) NSArray                *viewControllers;
@property (nonatomic, retain, readonly) UINavigationController *navigationController;

- (id)initWithNavigationController:(UINavigationController *)aNavigationController viewControllers:(NSArray *)viewControllers;

- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)aSegmentedControl;

@end
