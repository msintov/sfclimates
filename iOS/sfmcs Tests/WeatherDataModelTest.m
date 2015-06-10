//
//  WeatherDataModelTest.m
//  sfmcs
//
//  Created by Gary Grossman on 1/17/15.
//
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "WeatherDataModel.h"

@interface WeatherDataModelTest : XCTestCase
{
    WeatherDataModel *_weatherDataModel;
}

@end

@implementation WeatherDataModelTest

- (void)setUp
{
    [super setUp];

    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSDictionary *weatherDict = [self loadJsonFixtureWithName:@"current-observations"];
    _weatherDataModel = [[WeatherDataModel alloc] initWithJSON:weatherDict];
}

- (NSDictionary *)loadJsonFixtureWithName:(NSString *)name
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *filePath = [bundle pathForResource:name ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:filePath];
    NSError *error = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    if (error) {
        [NSException raise:@"Invalid Json file!" format:@"Error when parsing json data!"];
    }
    
    return jsonDictionary;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNeighborhoods
{
    XCTAssertEqual([[_weatherDataModel neighborhoods] count], 17);
    
    Neighborhood *neighborhood = [_weatherDataModel neighborhoodByName:@"Bayview"];
    XCTAssertTrue([[neighborhood name] isEqualToString:@"Bayview"]);
    XCTAssertEqual([neighborhood rect].origin.x, 263.0);
    XCTAssertEqual([neighborhood rect].origin.y, 360.0);
    XCTAssertEqual([neighborhood rect].size.width, 32.0);
    XCTAssertEqual([neighborhood rect].size.height, 24.0);
}

- (void)testObservation
{
    Neighborhood *neighborhood = [_weatherDataModel neighborhoodByName:@"Bayview"];
    Observation *observation = [neighborhood observation];
    
    XCTAssertEqual([observation wind], 0.0);
    XCTAssertEqual([observation windDirection], 273.0);
    XCTAssertEqual([observation temperature], 57.0);
    XCTAssertTrue([[observation condition] isEqualToString:@"Mostly Cloudy"]);    
}

- (void)testIsNight
{
    XCTAssertTrue([_weatherDataModel isNight]);
}

@end
