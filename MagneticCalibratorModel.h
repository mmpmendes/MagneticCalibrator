//
//  MagneticModel.h
//  Teslameter
//
//  Created by GNSSLab on 13/08/12.
//
//

#import <Foundation/Foundation.h>

@interface MagneticCalibratorModel : NSObject

@property double intensitySum;
@property double xSum;
@property double ySum;
@property double zSum;
@property (strong, nonatomic) NSMutableArray *x;
@property (strong, nonatomic) NSMutableArray *y;
@property (strong, nonatomic) NSMutableArray *z;
@property (strong, nonatomic) NSMutableArray *intensity;

@property (strong, nonatomic) NSMutableArray *arrayToPrintIntensity;
@property (strong, nonatomic) NSMutableArray *arrayToPrintIntensitySTD;
@property (strong, nonatomic) NSMutableArray *arrayToPrintX;
@property (strong, nonatomic) NSMutableArray *arrayToPrintY;
@property (strong, nonatomic) NSMutableArray *arrayToPrintZ;
@property (strong, nonatomic) NSMutableArray *arrayToPrintXSTD;
@property (strong, nonatomic) NSMutableArray *arrayToPrintYSTD;
@property (strong, nonatomic) NSMutableArray *arrayToPrintZSTD;

// Sets a new measure and return the intensity
-(double)newIntensityX: (double)x
                     Y:(double)y
                     Z:(double)z;

// Cache the current set of measures to a structure of some kind
// save the mean norm, the max and min norm
// save the mean x, the max x and min x
// save the mean y, the max y and min y
// save the mean z, the max z and min z
-(void)print;

// Saves all cached info in a txt file
-(void)print2file;
@end
