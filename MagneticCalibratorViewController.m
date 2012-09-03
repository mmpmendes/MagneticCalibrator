//
//  MagneticCalibratorViewController.m
//  MagneticCalibrator
//
//  Created by GNSSLab on 13/08/12.
//  Copyright (c) 2012 GNSSLab. All rights reserved.
//

#import "MagneticCalibratorViewController.h"
#import "GraphView.h"

const int MEASURES_NUMBER = 400;

@implementation MagneticCalibratorViewController
@synthesize magnitudeField = _magnitudeField;
@synthesize xLabel = _xLabel;
@synthesize yLabel = _yLabel;
@synthesize zLabel = _zLabel;
@synthesize graphView = _graphView;
@synthesize model = _model;
@synthesize locationManager = _locationManager;
@synthesize measureN = _measureN;

-(MagneticCalibratorModel *)model{
    if(_model == nil) _model = [[MagneticCalibratorModel alloc] init];
    return _model;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setMagnitudeField:nil];
    [self setXLabel:nil];
    [self setYLabel:nil];
    [self setZLabel:nil];
    [self setGraphView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    } else {
        return NO;
    }
}

// This delegate method is invoked when the location managed encounters an error condition.
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        // This error indicates that the user has denied the application's request to use location services.
        [manager stopUpdatingHeading];
    } else if ([error code] == kCLErrorHeadingFailure) {
        // This error indicates that the heading could not be determined, most likely because of strong magnetic interference.
        UIAlertView *magneticInterference = [[UIAlertView alloc] initWithTitle:@"Fail!" message:@"There is great magnetic interference." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [magneticInterference show];
    }
}

// This delegate method is invoked when the location manager has heading data.
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)heading {
    // Update the labels with the raw x, y, and z values.
	[self.xLabel setText:[NSString stringWithFormat:@"%.1f", heading.x]];
	[self.yLabel setText:[NSString stringWithFormat:@"%.1f", heading.y]];
	[self.zLabel setText:[NSString stringWithFormat:@"%.1f", heading.z]];
    
	CGFloat magnitude = [self.model newIntensityX:heading.x Y:heading.y Z:heading.z];
    [self.magnitudeField setText:[NSString stringWithFormat:@"%.1f", magnitude]];
    
    
	self.measureN++;
    
    if (self.measureN % MEASURES_NUMBER == 0) {
        [self stop];
    }
    
    
	// Update the graph with the new magnetic reading.
	[self.graphView updateHistoryWithX:heading.x y:heading.y z:heading.z];
}

- (IBAction)start {
    
    // check if the hardware has a compass
    if ([CLLocationManager headingAvailable] == NO) {
        // No compass is available. This application cannot function without a compass,
        // so a dialog will be displayed and no magnetic data will be measured.
        self.locationManager = nil;
        UIAlertView *noCompassAlert = [[UIAlertView alloc] initWithTitle:@"No Compass!" message:@"This device does not have the ability to measure magnetic fields." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [noCompassAlert show];
    } else {
        // heading service configuration
        self.locationManager.headingFilter = kCLHeadingFilterNone;
        
        // setup delegate callbacks
        if (self.locationManager.delegate==NULL) {
            self.locationManager.delegate = self;
        }
        
        // start the compass
        [self.locationManager startUpdatingHeading];
    }
    
}

-(void)stop{
    [self.locationManager stopUpdatingHeading];
    [self.model print];
}

- (IBAction)print {
    [self.model print2file];
}
@end
