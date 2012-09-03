//
//  MagneticModel.m
//  Teslameter
//
//  Created by GNSSLab on 13/08/12.
//
//

#import "MagneticCalibratorModel.h"

@interface MagneticCalibratorModel(){
    double intensitySum;
    double xSum;
    double ySum;
    double zSum;    
}
@end

@implementation MagneticCalibratorModel

@synthesize arrayToPrintIntensity = _arrayToPrintIntensity;
@synthesize arrayToPrintIntensitySTD = _arrayToPrintIntensitySTD;
@synthesize arrayToPrintX = _arrayToPrintX;
@synthesize arrayToPrintXSTD = _arrayToPrintXSTD;
@synthesize arrayToPrintY = _arrayToPrintY;
@synthesize arrayToPrintYSTD = _arrayToPrintYSTD;
@synthesize arrayToPrintZ = _arrayToPrintZ;
@synthesize arrayToPrintZSTD = _arrayToPrintZSTD;

@synthesize x = _x;
@synthesize y = _y;
@synthesize z = _z;
@synthesize intensity = _intensity;

@synthesize intensitySum = _intensitySum;
@synthesize xSum = _xSum;
@synthesize ySum = _ySum;
@synthesize zSum = _zSum;

//GETTERS OR INITIALIZERS
-(NSMutableArray*)intensity{
    if (_intensity == nil) _intensity = [[NSMutableArray alloc] init];
    return _intensity;
}
-(NSMutableArray*)x{
    if (_x == nil) _x = [[NSMutableArray alloc] init];
    return _x;
}
-(NSMutableArray*)y{
    if (_y == nil) _y = [[NSMutableArray alloc] init];
    return _y;
}
-(NSMutableArray*)z{
    if (_z == nil) _z = [[NSMutableArray alloc] init];
    return _z;
}
-(NSMutableArray*)arrayToPrintIntensity{
    if (_arrayToPrintIntensity == nil) _arrayToPrintIntensity = [[NSMutableArray alloc] init];
    return _arrayToPrintIntensity;
}
-(NSMutableArray*)arrayToPrintIntensitySTD{
    if (_arrayToPrintIntensitySTD == nil) _arrayToPrintIntensitySTD = [[NSMutableArray alloc] init];
    return _arrayToPrintIntensitySTD;
}
-(NSMutableArray*)arrayToPrintX{
    if (_arrayToPrintX == nil) _arrayToPrintX = [[NSMutableArray alloc] init];
    return _arrayToPrintX;
}
-(NSMutableArray*)arrayToPrintXSTD{
    if (_arrayToPrintXSTD == nil) _arrayToPrintXSTD = [[NSMutableArray alloc] init];
    return _arrayToPrintXSTD;
}
-(NSMutableArray*)arrayToPrintY{
    if (_arrayToPrintY == nil) _arrayToPrintY = [[NSMutableArray alloc] init];
    return _arrayToPrintY;
}
-(NSMutableArray*)arrayToPrintYSTD{
    if (_arrayToPrintYSTD == nil) _arrayToPrintYSTD = [[NSMutableArray alloc] init];
    return _arrayToPrintYSTD;
}
-(NSMutableArray*)arrayToPrintZ{
    if (_arrayToPrintZ == nil) _arrayToPrintZ = [[NSMutableArray alloc] init];
    return _arrayToPrintZ;
}
-(NSMutableArray*)arrayToPrintZSTD{
    if (_arrayToPrintZSTD == nil) _arrayToPrintZSTD = [[NSMutableArray alloc] init];
    return _arrayToPrintZSTD;
}
/*********************************/
/*UTILITIES*/
-(double)calculateVarianceValue:(double)value
                           Mean:(double)mean{
    return (value-mean)*(value-mean);
}

-(double)standardDeviationVector:(NSMutableArray*)vector
                            Mean:(double)mean{
    double varianceSum = 0;
    for (NSNumber *value in vector) {
        varianceSum = varianceSum + [self calculateVarianceValue:value.doubleValue Mean:mean];
    }
    return sqrt(varianceSum/[vector count]);
}

/*UTILITIES*/


/*SAVE NEW MEASURE*/
-(double)newIntensityX: (double)x
                     Y:(double)y
                     Z:(double)z{
    double intensity = sqrt(x*x+y*y+z*z);
    
    self.intensitySum = self.intensitySum + intensity;
    self.xSum = self.xSum + x;
    self.ySum = self.ySum + y;
    self.zSum = self.zSum + z;
    
    [self.intensity addObject:[NSNumber numberWithDouble:intensity]];
    [self.x addObject:[NSNumber numberWithDouble:x]];
    [self.y addObject:[NSNumber numberWithDouble:y]];
    [self.z addObject:[NSNumber numberWithDouble:z]];

    return intensity;
}

/* Cache current values*/
-(void)print{
    double intensityMean = self.intensitySum/[self.intensity count];
    double xMean = self.xSum/[self.x count];
    double yMean = self.ySum/[self.y count];
    double zMean = self.zSum/[self.z count];
    
    double intensitySTDev = [self standardDeviationVector:self.intensity Mean:intensityMean];
    double xSTDev = [self standardDeviationVector:self.x Mean:xMean];
    double ySTDev = [self standardDeviationVector:self.y Mean:yMean];
    double zSTDev = [self standardDeviationVector:self.z Mean:zMean];

    [self.arrayToPrintIntensity addObject:[NSNumber numberWithDouble:intensityMean]];
    [self.arrayToPrintIntensitySTD addObject:[NSNumber numberWithDouble:intensitySTDev]];
    
    [self.arrayToPrintX addObject:[NSNumber numberWithDouble:xMean]];
    [self.arrayToPrintXSTD addObject:[NSNumber numberWithDouble:xSTDev]];
    
    [self.arrayToPrintY addObject:[NSNumber numberWithDouble:yMean]];
    [self.arrayToPrintYSTD addObject:[NSNumber numberWithDouble:ySTDev]];
    
    [self.arrayToPrintZ addObject:[NSNumber numberWithDouble:zMean]];
    [self.arrayToPrintZSTD addObject:[NSNumber numberWithDouble:zSTDev]];

    self.x = nil;
    self.y = nil;
    self.z = nil;
    self.xSum = 0;
    self.ySum = 0;
    self.zSum = 0;
    self.intensity = nil;
    self.intensitySum = 0;
}



-(void)print2file{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/calibration_file.txt", documentsDirectory];
    NSString *strToPrint = @"Intensity Mean\n";
    for (NSNumber *number in self.arrayToPrintIntensity) {
    
        strToPrint = [strToPrint stringByAppendingString: [NSString stringWithFormat:@"%g,",number.doubleValue]];

    }
    
    strToPrint = [strToPrint stringByAppendingString:@"\nIntensity STD\n"];
    for (NSNumber *number in self.arrayToPrintIntensitySTD) {
        
        strToPrint = [strToPrint stringByAppendingString: [NSString stringWithFormat:@"%g,",number.doubleValue]];
        
    }
    
    strToPrint = [strToPrint stringByAppendingString:@"\nX Mean\n"];
    for (NSNumber *number in self.arrayToPrintX) {
        
        strToPrint = [strToPrint stringByAppendingString: [NSString stringWithFormat:@"%g,",number.doubleValue]];
        
    }
    
    strToPrint = [strToPrint stringByAppendingString:@"\nX STD\n"];
    
    for (NSNumber *number in self.arrayToPrintXSTD) {
        
        strToPrint = [strToPrint stringByAppendingString: [NSString stringWithFormat:@"%g,",number.doubleValue]];
        
    }
    
    strToPrint = [strToPrint stringByAppendingString:@"\nY Mean\n"];
    
    for (NSNumber *number in self.arrayToPrintY) {
        
        strToPrint = [strToPrint stringByAppendingString: [NSString stringWithFormat:@"%g,",number.doubleValue]];
        
    }
    
    strToPrint = [strToPrint stringByAppendingString:@"\nY STD\n"];
    
    for (NSNumber *number in self.arrayToPrintYSTD) {
        
        strToPrint = [strToPrint stringByAppendingString: [NSString stringWithFormat:@"%g,",number.doubleValue]];
        
    }
    
    strToPrint = [strToPrint stringByAppendingString:@"\nZ Mean\n"];
    
    for (NSNumber *number in self.arrayToPrintZ) {
        
        strToPrint = [strToPrint stringByAppendingString: [NSString stringWithFormat:@"%g,",number.doubleValue]];
        
    }
    
    strToPrint = [strToPrint stringByAppendingString:@"\nZ STD\n"];
    
    for (NSNumber *number in self.arrayToPrintZSTD) {
        
        strToPrint = [strToPrint stringByAppendingString: [NSString stringWithFormat:@"%g,",number.doubleValue]];
        
    }
    
    //save content to the documents directory
    [strToPrint writeToFile:fileName
                 atomically:YES
                   encoding:NSStringEncodingConversionAllowLossy
                      error:nil];
}

@end
