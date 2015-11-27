//
//  SKSpriteNode+mathAdditions.m
//  SquareShooter
//
//  Created by Daniel Grönlund on 2015-11-27.
//  Copyright © 2015 Daniel Grönlund. All rights reserved.
//

#import "SKSpriteNode+mathAdditions.h"

@implementation SKSpriteNode (mathAdditions)

#pragma mark - math

- (CGFloat)pointPairToBearingDegrees:(CGPoint)startingPoint secondPoint:(CGPoint) endingPoint
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y); // get origin point to origin by subtracting end from start
    float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
    float bearingDegrees = bearingRadians * (180.0 / M_PI); // convert to degrees
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)); // correct discontinuity
    return bearingDegrees;
}

- (CGPoint) getVectorFromAngle: (float) angle AndMagnitude: (float) magnitude
{
    float x = magnitude * cos(angle);
    float y = magnitude * sin(angle);
    CGPoint point = CGPointMake(x, y);
    NSLog(@"Made a CGPoint of X: %f and Y: %f.", point.x, point.y);
    return point;
}

@end
