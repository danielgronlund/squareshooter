//
//  SQShot.h
//  SquareShooter
//
//  Created by Daniel Grönlund on 2015-11-27.
//  Copyright © 2015 Daniel Grönlund. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SQShot : SKSpriteNode
@property (nonatomic) double speed;
@property (nonatomic) double speedFallOff;
@property (nonatomic) CGVector initialDirection;
@property (nonatomic) float initialAngle;
- (instancetype)initWithRotation:(float)rotation andSpeed:(float)speed;
- (void)updatePhysics;
- (void)destroy;
@end
