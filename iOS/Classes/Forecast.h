//
//  Forecast.h
//  sfmcs
//
//  Copyright 2015 Baker Beach Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Forecast : NSObject

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *name;
@property (nonatomic)         double highTemperature;
@property (nonatomic)         double lowTemperature;
@property (nonatomic)         double precipitation;
@property (nonatomic, retain) NSString *condition;

- (id)initWithJSON:(NSDictionary*)jsonRecord;

@end
