//
//  SQPlayer.m
//  SquareShooter
//
//  Created by Daniel Grönlund on 2015-11-27.
//  Copyright © 2015 Daniel Grönlund. All rights reserved.
//

#import "SQPlayer.h"

#import "SKSpriteNode+mathAdditions.h"

@interface SQPlayer ()
@property (nonatomic, strong) SKSpriteNode *arm;
@end

@implementation SQPlayer

- (instancetype)initWithColor:(UIColor *)color {
    self = [super initWithImageNamed:@"body"];
    if (self) {
        self.physicsBody = [[SKPhysicsBody alloc] init];
        self.physicsBody.dynamic = YES;
        
        _arm = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(50, 10)];
        _arm.zPosition = 10;
        _arm.anchorPoint = CGPointMake(0, .5);
        [self addChild:_arm];
    }
    return self;
}

- (void)updatePhysics
{
    self.physicsBody.velocity = CGVectorMake(self.physicsBody.velocity.dx + self.velocity.dx, self.physicsBody.velocity.dy + self.velocity.dy);
    if (![self.delegate touchIsDown]) self.velocity = CGVectorMake(self.velocity.dx * .90, self.velocity.dy * .90);
    
    if (arc4random() % 30 == 2) {
        [self aimInDirection:CGVectorMake(-5 + arc4random() % 10, -5 + arc4random() % 10)];
    }
}

- (void)aimInDirection:(CGVector)direction
{
    CGPoint dir = (CGPoint) {.x = direction.dx, .y = direction.dy};
    CGFloat angle = [self pointPairToBearingDegrees:CGPointZero secondPoint:dir];
    self.arm.zRotation = angle;

    [self.delegate player:self didFireInDirection:angle];
}

@end
