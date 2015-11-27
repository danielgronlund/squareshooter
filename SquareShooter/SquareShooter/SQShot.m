//
//  SQShot.m
//  SquareShooter
//
//  Created by Daniel Grönlund on 2015-11-27.
//  Copyright © 2015 Daniel Grönlund. All rights reserved.
//

#import "SQShot.h"

#import "SKSpriteNode+mathAdditions.h"



@implementation SQShot

- (instancetype)initWithRotation:(float)rotation andSpeed:(float)speed
{
    self = [super initWithColor:[SKColor redColor] size:CGSizeMake(20, 5)];
    if (self){
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.zRotation = rotation;
        self.initialAngle = rotation;
        self.speed = speed;
        CGPoint v = [self getVectorFromAngle:self.zRotation AndMagnitude:self.speed];
        self.initialDirection = CGVectorMake(v.x, v.y);
        self.speedFallOff = 0.98;
        self.physicsBody.collisionBitMask = 10;
    }
    return self;
}

- (void)updatePhysics
{
    CGPoint v = [self getVectorFromAngle:self.initialAngle AndMagnitude:self.speed];
    self.initialDirection = CGVectorMake(v.x, v.y);
    self.physicsBody.velocity = self.initialDirection;
   // self.speed = self.speed * self.speedFallOff;
}

- (void)destroy
{
    [self removeFromParent];
}

@end
