    //
//  CityViewController.m
//  sfmcs
//
//  Created by Michelle Sintov on 9/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CityViewController.h"
#import "NeighborhoodViewController.h"

#define ZOOM_STEP 1.5

@interface CityViewController()
- (CGContextRef) newARGBBitmapContextFromImage:(CGImageRef)inImage;
- (NSString*) getPixelColorAtPointAsHexString:(CGPoint)point;
- (void)handleSingleTap:(UITapGestureRecognizer*)sender;

@property (nonatomic, readonly) NSDictionary *colorToNeighborhoodHitTestDict;
@end

@implementation CityViewController

@synthesize lastUpdated;
@synthesize settingsDelegate;
@synthesize weatherDataModel;
@synthesize cityMapImageView;
@synthesize tempBayview;
@synthesize tempCastro;
@synthesize tempColeValley;
@synthesize tempFinancialDistrict;
@synthesize tempGlenPark;
@synthesize tempHayesValley;
@synthesize tempInnerRichmond;
@synthesize tempLakeMerced;
@synthesize tempMission;
@synthesize tempNoeValley;
@synthesize tempNorthBeach;
@synthesize tempOuterRichmond;
@synthesize tempOuterSunset;
@synthesize tempPotreroHill;
@synthesize tempPresidio;
@synthesize tempSOMA;
@synthesize tempTwinPeaks;
@synthesize tempWestPortal;
@synthesize condBayview;
@synthesize condCastro;
@synthesize condColeValley;
@synthesize condFinancialDistrict;
@synthesize condGlenPark;
@synthesize condHayesValley;
@synthesize condInnerRichmond;
@synthesize condLakeMerced;
@synthesize condMission;
@synthesize condNoeValley;
@synthesize condNorthBeach;
@synthesize condOuterRichmond;
@synthesize condOuterSunset;
@synthesize condPotreroHill;
@synthesize condPresidio;
@synthesize condSOMA;
@synthesize condTwinPeaks;
@synthesize condWestPortal;

@synthesize refreshButton;

- (void)dealloc {
    self.weatherDataModel = nil;
    self.settingsDelegate = nil;
    
	[colorToNeighborhoodHitTestDict release];
    
	[super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Add info button
    UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight]; 
    [infoButton addTarget:self.settingsDelegate action:@selector(showSettings) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:infoButton] autorelease];
    
    // Add single tap gesture
	UITapGestureRecognizer *tapgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
	[self.view addGestureRecognizer:tapgr];
	[tapgr release];
    
    nameToCondViewDict = [[NSDictionary dictionaryWithObjectsAndKeys:
                           self.condBayview, bayviewNSString,
                           self.condCastro, castroNSString,
                           self.condColeValley, coleValleyNSString,
                           self.condFinancialDistrict, financialDistrictNSString,
                           self.condGlenPark, glenParkNSString,
                           self.condHayesValley, hayesValleyNSString,
                           self.condInnerRichmond, innerRichmondNSString,
                           self.condLakeMerced, lakeMercedNSString,
                           self.condMission, missionNSString,
                           self.condNoeValley, noeValleyNSString,
                           self.condNorthBeach, northBeachNSString,
                           self.condOuterRichmond, outerRichmondNSString,
                           self.condOuterSunset, outerSunsetNSString,
                           self.condPotreroHill, potreroHillNSString,
                           self.condPresidio, presidioNSString,
                           self.condSOMA, somaNSString,
                           self.condTwinPeaks, twinPeaksNSString,
                           self.condWestPortal, westPortalNSString, nil] retain];
                          
    nameToTempViewDict = [[NSDictionary dictionaryWithObjectsAndKeys:
                           self.tempBayview, bayviewNSString,
                           self.tempCastro, castroNSString,
                           self.tempColeValley, coleValleyNSString,
                           self.tempFinancialDistrict, financialDistrictNSString,
                           self.tempGlenPark, glenParkNSString,
                           self.tempHayesValley, hayesValleyNSString,
                           self.tempInnerRichmond, innerRichmondNSString,
                           self.tempLakeMerced, lakeMercedNSString,
                           self.tempMission, missionNSString,
                           self.tempNoeValley, noeValleyNSString,
                           self.tempNorthBeach, northBeachNSString,
                           self.tempOuterRichmond, outerRichmondNSString,
                           self.tempOuterSunset, outerSunsetNSString,
                           self.tempPotreroHill, potreroHillNSString,
                           self.tempPresidio, presidioNSString,
                           self.tempSOMA, somaNSString,
                           self.tempTwinPeaks, twinPeaksNSString,
                           self.tempWestPortal, westPortalNSString, nil] retain];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self drawNewData];

    [super viewWillAppear:animated];
}

- (void)viewDidUnload {
    
    [super viewDidUnload];

    self.lastUpdated = nil;
    self.cityMapImageView = nil;
    
    self.tempBayview = nil;
    self.tempCastro = nil;
    self.tempColeValley = nil;
    self.tempFinancialDistrict = nil;
    self.tempGlenPark = nil;
    self.tempHayesValley = nil;
    self.tempInnerRichmond = nil;
    self.tempLakeMerced = nil;
    self.tempMission = nil;
    self.tempNoeValley = nil;
    self.tempNorthBeach = nil;
    self.tempOuterRichmond = nil;
    self.tempOuterSunset = nil;
    self.tempPotreroHill = nil;
    self.tempPresidio = nil;
    self.tempSOMA = nil;
    self.tempTwinPeaks = nil;
    self.tempWestPortal = nil;
    
    self.condBayview = nil;
    self.condCastro = nil;
    self.condColeValley = nil;
    self.condFinancialDistrict = nil;
    self.condGlenPark = nil;
    self.condHayesValley = nil;
    self.condInnerRichmond = nil;
    self.condLakeMerced = nil;
    self.condMission = nil;
    self.condNoeValley = nil;
    self.condNorthBeach = nil;
    self.condOuterRichmond = nil;
    self.condOuterSunset = nil;
    self.condPotreroHill = nil;
    self.condPresidio = nil;
    self.condSOMA = nil;
    self.condTwinPeaks = nil;
    self.condWestPortal = nil;
    
    self.refreshButton = nil;
    
    [nameToTempViewDict release];
    nameToTempViewDict = nil;

    [nameToCondViewDict release];
    nameToCondViewDict = nil;
}

- (void)drawNewData {
    NSDictionary *weatherDict = weatherDataModel.weatherDict;
	if (!weatherDict)
    {
        [cityMapImageView setImage:[UIImage imageNamed:@"cityMapDay"]];
        return;
    }

	BOOL isNight = [[UtilityMethods sharedInstance] isNight:weatherDict];

	NSArray *observationsNSArray = [weatherDict objectForKey:@"observations"];
    
    // Set city map background.
    if (isNight)
    {
        [cityMapImageView setImage:[UIImage imageNamed:@"cityMapNight"]];
    }
    else
    {
        [cityMapImageView setImage:[UIImage imageNamed:@"cityMapDay"]];
    }

    for (NSDictionary *neighborhoodNSDictionary in observationsNSArray)
	{
		NSString *neighborhoodName = [neighborhoodNSDictionary objectForKey:@"name"];

        UILabel *tempLabel = [nameToTempViewDict objectForKey:neighborhoodName];
        if (tempLabel != nil)
        {
            // Get temperature string
            int tempInt = [[neighborhoodNSDictionary objectForKey:@"current_temperature"] intValue];
            NSString *temperatureString = [[UtilityMethods sharedInstance] makeTemperatureString:tempInt showDegree:YES];
            
            tempLabel.text = temperatureString;
        }

		UIImageView* imageView = [nameToCondViewDict objectForKey:neighborhoodName];
        if (imageView != nil)
        {
            // Get condition image
            NSString *conditionString = [neighborhoodNSDictionary objectForKey:@"current_condition"];
            UIImage *conditionImage = [[UtilityMethods sharedInstance] getConditionImage:conditionString withIsNight:isNight withIconSize:smallConditionIcon];
            
            [imageView setImage:conditionImage];
        }
    }
    
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[weatherDict objectForKey:@"timeOfLastUpdate"] doubleValue]];
	lastUpdated.text =  [[UtilityMethods sharedInstance] getFormattedDate:date prependString:@"Updated "];
}

- (void)handleSingleTap:(UITapGestureRecognizer*)sender
{
    if (CGRectContainsPoint([self.navigationController.navigationBar frame], [sender locationInView:self.view])) {
        // gesture occured in navigation bar, so return;
        return;
    }
    
    // If tap point is within the refresh button, refresh the data
    if (CGRectContainsPoint([self.refreshButton frame], [sender locationInView:self.view]))
    {
        [self.weatherDataModel retrieveWeatherDataFromServer];
        return;
    }
    
	if (sender.state == UIGestureRecognizerStateEnded)
	{
		// Get the patchwork map color at the tap location and use it to figure
		// out which neighborhood was selected based on color.
		CGPoint tapPoint = [sender locationInView:self.view];
        
		NSString *colorAsString = [self getPixelColorAtPointAsHexString:tapPoint];
		if (colorAsString == nil) return;
		
		NSString *neighborhoodName = [self.colorToNeighborhoodHitTestDict objectForKey:colorAsString];
		if (!neighborhoodName)
        {
            return;
        }
        
        NeighborhoodViewController *vc = [[[NeighborhoodViewController alloc] init] autorelease];
        
        vc.neighborhoodName = neighborhoodName;
        vc.weatherDataModel = weatherDataModel;
        
        [self.navigationController pushViewController:vc animated:YES];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}
*/

- (NSDictionary *)colorToNeighborhoodHitTestDict
{
	if (!colorToNeighborhoodHitTestDict)
	{
		NSBundle* nsBundle = [NSBundle mainBundle];
		if (nsBundle == nil) return nil;
		
		NSString * plistPath = [nsBundle pathForResource:@"ColorToNeighborhoodHitTest" ofType:@"plist"];
		if (plistPath == nil) return nil;
		
		colorToNeighborhoodHitTestDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
		if (colorToNeighborhoodHitTestDict == nil) return nil;
		
		[colorToNeighborhoodHitTestDict retain];
	}
	return colorToNeighborhoodHitTestDict;
}

- (CGContextRef) newARGBBitmapContextFromImage:(CGImageRef)inImage
{
	CGContextRef    context = NULL;
	CGColorSpaceRef colorSpace;
	int             bitmapBytesPerRow;
	
	// Get image width, height. We'll use the entire image.
	size_t pixelsWide = CGImageGetWidth(inImage);
	size_t pixelsHigh = CGImageGetHeight(inImage);
	
	// Declare the number of bytes per row. Each pixel in the bitmap in this
	// example is represented by 4 bytes; 8 bits each of red, green, blue, and
	// alpha.
	bitmapBytesPerRow = (pixelsWide * 4);
	
	// Use the generic RGB color space.
	colorSpace = CGColorSpaceCreateDeviceRGB();
	if (colorSpace == NULL) return NULL;
	
	// Create the bitmap context. We want pre-multiplied ARGB, 8-bits
	// per component. Regardless of what the source image format is
	// (CMYK, Grayscale, and so on) it will be converted over to the format
	// specified here by CGBitmapContextCreate.
	context = CGBitmapContextCreate (NULL,
									 pixelsWide,
									 pixelsHigh,
									 8,      // bits per component
									 bitmapBytesPerRow,
									 colorSpace,
									 kCGImageAlphaPremultipliedFirst);

	if (context == NULL) DLog(@"Context not created!");
	
	// Make sure and release colorspace before returning
	CGColorSpaceRelease(colorSpace);
	
	return context;
}

- (NSString*) getPixelColorAtPointAsHexString:(CGPoint)point
{
	NSString *colorAsString = nil;
	
	// Get Quartz image data.
	UIImage *patchWorkMap = [UIImage imageNamed:@"patchwork.png"];
	if (!patchWorkMap)
    {
        return nil;
    }
    
    // Scale the tap point to the image size
    CGSize viewSize = [self.view bounds].size;
    CGSize imageBounds = [patchWorkMap size];
    point.x *= imageBounds.width/viewSize.width;
    point.y *= imageBounds.height/viewSize.height;

	//If the image data has been purged because of memory constraints,
	//invoking this method forces that data to be loaded back into memory.
	//Reloading the image data may incur a performance penalty.
	CGImageRef inImage = patchWorkMap.CGImage;
	
	// Create offscreen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel
	CGContextRef cgctx = [self newARGBBitmapContextFromImage:inImage];
	if (cgctx == NULL) { return nil;}
	
    size_t w = CGImageGetWidth(inImage);
	size_t h = CGImageGetHeight(inImage);
	CGRect rect = {{0,0},{w,h}};
	
	// Draw the image to the bitmap context. Once we draw, the memory
	// allocated for the context for rendering will then contain the
	// raw image data in the specified color space.
	CGContextDrawImage(cgctx, rect, inImage);
	
	// Now we can get a pointer to the image data associated with the bitmap context.
    unsigned char *data = (unsigned char*)CGBitmapContextGetData(cgctx);
    if (data != NULL)
    {
		//offset locates the pixel in the data from x,y. 
		//4 for 4 bytes of data per pixel, w is width of one row of data.
		//int offset = 4*((w*round(point.y))+round(point.x));
		int offset = ((w*round(point.y))+round(point.x));
        unsigned char *pixelPtr = data+offset*4;        
		colorAsString = [NSString stringWithFormat:@"%02X%02X%02X", pixelPtr[1], pixelPtr[2], pixelPtr[3]];
		//DLog(@"%@", colorAsString);
	}
	
	CGContextRelease(cgctx);
	
	return colorAsString;
}

@end
