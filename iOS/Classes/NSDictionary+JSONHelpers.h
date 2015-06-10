//
//  NSDictionary+JSONHelpers.h
//  sfmcs
//
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSONHelpers)

- (NSString*)stringForKey:(NSString*)key;
- (int)integerForKey:(NSString*)key;
- (double)doubleForKey:(NSString*)key;
- (NSArray*)arrayForKey:(NSString*)key;
- (NSDictionary*)dictionaryForKey:(NSString*)key;
- (NSDate*)dateForKey:(NSString*)key;

@end
