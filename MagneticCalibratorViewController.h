//
//  MagneticCalibratorViewController.h
//  MagneticCalibrator
//
//  Created by GNSSLab on 13/08/12.
//  Copyright (c) 2012 GNSSLab. All rights reserved.
//

#import "MagneticCalibratorAppDelegate.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MagneticCalibratorModel.h"

@class GraphView;

@interface MagneticCalibratorViewController : UIViewController <CLLocationManagerDelegate>{
    GraphView *graphView;
}
@property (weak, nonatomic) IBOutlet UILabel *magnitudeField;
@property (weak, nonatomic) IBOutlet UILabel *xLabel;
@property (weak, nonatomic) IBOutlet UILabel *yLabel;
@property (weak, nonatomic) IBOutlet UILabel *zLabel;
@property (strong, nonatomic) IBOutlet GraphView *graphView;
@property (strong, nonatomic) MagneticCalibratorModel *model;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property int measureN;

- (IBAction)start;
- (IBAction)print;

@end
