//
//  UtilityMethods.h
//  sfmcs
//
//  Created by Michelle Sintov on 10/5/11.
//  Copyright 2015 Baker Beach Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

enum {
    smallConditionIcon,
    mediumConditionIcon,
    largeConditionIcon
} typedef ConditionIconSize;

@interface ConditionImages : NSObject
{
	NSDictionary *_conditionImageMappingDict;
}

+ (ConditionImages*)sharedInstance;
- (UIImage*)getConditionImage:(NSString*)conditionString withIsNight:(BOOL)isNight withIconSize:(ConditionIconSize)conditionIconSize;

@end
