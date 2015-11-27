//
//  SKSpriteNode+mathAdditions.h
//  SquareShooter
//
//  Created by Daniel Grönlund on 2015-11-27.
//  Copyright © 2015 Daniel Grönlund. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKSpriteNode (mathAdditions)
- (CGFloat)pointPairToBearingDegrees:(CGPoint)startingPoint secondPoint:(CGPoint) endingPoint;
- (CGPoint) getVectorFromAngle: (float) angle AndMagnitude: (float) magnitude;

@end
