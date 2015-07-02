//
//  Observation.h
//  sfmcs
//
//  Copyright 2015 Baker Beach Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Observation : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *condition;
@property (nonatomic) double temperature;
@property (nonatomic) double wind;
@property (nonatomic) double windDirection;

- (id)initWithJSON:(NSDictionary*)jsonRecord;

@end
