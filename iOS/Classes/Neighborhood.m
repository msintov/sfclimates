//
//  Neighborhood.m
//  sfmcs
//
//  Created by Gary Grossman on 1/17/15.
//
//

#import <Foundation/Foundation.h>
#import "Neighborhood.h"

@implementation Neighborhood

@synthesize name, rect;

- (id)initWithName:(NSString*)newName rect:(CGRect)newRect
{
    if (self = [super init])
    {
        name  = newName;
        rect  = newRect;
    }
    return self;
}

@end