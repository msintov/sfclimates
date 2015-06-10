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

@protocol ShowSettings
-(void) showSettings;
@end

@interface UtilityMethods : NSObject {
	NSDictionary *conditionImageMappingDict;
    NSDateFormatter *dateFormatterForDate;
    BOOL celsiusMode;
}

+ (UtilityMethods*)sharedInstance;
- (UIImage*)getConditionImage:(NSString*)conditionString withIsNight:(BOOL)isNight withIconSize:(ConditionIconSize)conditionIconSize;
- (NSString*)makeTemperatureString:(int)temperatureInt showDegree:(BOOL)showDegree;
- (BOOL)isCelsiusMode;
- (void)setCelsiusMode:(BOOL)newCelsiusMode;

@end
