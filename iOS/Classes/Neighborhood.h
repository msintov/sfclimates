//
//  Neighborhood.h
//  sfmcs
//
//  Created by Gary Grossman on 1/17/15.
//
//

#ifndef sfmcs_Neighborhood_h
#define sfmcs_Neighborhood_h

#import <Foundation/Foundation.h>

@interface Neighborhood : NSObject
{
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic) CGRect rect;

- (id)initWithName:(NSString*)name rect:(CGRect)rect;

@end

#endif
