//
//  UtilityMethods.h
//  sfmcs
//
//  Created by Michelle Sintov on 10/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

enum {
    smallConditionIcon,
    mediumConditionIcon,
    largeConditionIcon
} typedef ConditionIconSize;

// This protocol is implemented by the CityViewController and the NeighborhoodViewController
// to call setNeedsDisplay on their respective views. When new data arrives, sfmcsAppDelegate
// is contacted by the model, and sfmcsAppDelegate tells the visible view controller to update
// by calling drawNewData.
//
// This protocol could live somewhere else but this location was handy.
@protocol RequestRedrawDelegate
-(void) drawNewData;
@end

@protocol ShowSettings
-(void) showSettings;
@end

@interface UtilityMethods : NSObject {
	NSDictionary *conditionImageMappingDict;
    NSDateFormatter *dateFormatterForDate;
    NSDateFormatter *dateFormatterForDay;
    BOOL celsiusMode;
}

+ (UtilityMethods*)sharedInstance;
- (UIImage*)getConditionImage:(NSString*)conditionString withIsNight:(BOOL)isNight withIconSize:(ConditionIconSize)conditionIconSize;
- (NSString*)getFormattedDate:(NSDate*)myDate prependString:(NSString*)prependStringValue;
- (NSString*)getDay:(NSDate*)myDate;
- (NSString*)makeTemperatureString:(int)temperatureInt showDegree:(BOOL)showDegree;
- (BOOL)isCelsiusMode;
- (void)setCelsiusMode:(BOOL)newCelsiusMode;

@end
