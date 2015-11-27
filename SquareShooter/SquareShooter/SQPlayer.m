//
//  SQPlayer.m
//  SquareShooter
//
//  Created by Daniel Grönlund on 2015-11-27.
//  Copyright © 2015 Daniel Grönlund. All rights reserved.
//

#import "SQPlayer.h"

#import "SKSpriteNode+mathAdditions.h"


#define kDefaultHealth 100

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
        self.health = kDefaultHealth;


        
    }
    return self;
}

- (void)updatePhysics
{
    self.physicsBody.velocity = CGVectorMake(self.physicsBody.velocity.dx + (self.velocity.dx * self.yScale), self.physicsBody.velocity.dy + (self.velocity.dy * self.yScale));
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
    [self fire];
}

- (void)fire {
    [self.delegate player:self didFireInDirection:self.arm.zRotation];
}

- (CGPoint)initialShotPosition
{
    CGPoint shotOffset = [self getVectorFromAngle:self.arm.zRotation AndMagnitude:(40) * self.yScale];
    return CGPointMake(self.position.x + self.arm.position.x + shotOffset.x, self.position.y + self.arm.position.y + shotOffset.y);
}


- (void)showNameLabel
{
    if (!self.nameLabel) {
        self.nameLabel = [[SKLabelNode alloc] initWithFontNamed:@"ArialRoundedMTBold"];
        self.nameLabel.text = self.name;
        self.nameLabel.fontSize = 80;
        if (self.name.length == 0) {
            self.nameLabel.text = @"Unnamed player";
        }
        [self addChild:self.nameLabel];
        self.nameLabel.position = CGPointMake(0, 100);
    }
    self.nameLabel.xScale = 0;
    self.nameLabel.yScale = 0;
    SKAction *scaleUp = [SKAction scaleTo:1.0 duration:.2];
    SKAction *wait = [SKAction waitForDuration:1.0];
    SKAction *scaleDown = [SKAction scaleTo:0.0 duration:.2];
    SKAction *sequence = [SKAction sequence:@[wait,scaleUp,wait,scaleDown]];
    [self.nameLabel runAction:sequence];
    
}

@end
