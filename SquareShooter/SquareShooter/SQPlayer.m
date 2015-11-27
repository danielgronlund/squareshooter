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
@property (nonatomic, strong) SKSpriteNode *gunFire;
@property (nonatomic, strong) SKSpriteNode *jetPackFire;

@end

@implementation SQPlayer

- (instancetype)initWithColor:(UIColor *)color {
    self = [super initWithImageNamed:@"body"];
    if (self) {
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.size.width, self.size.height)];
        self.physicsBody.allowsRotation = NO;
        self.physicsBody.dynamic = YES;
        //self.color = color;
        //self.colorBlendFactor = 1.0;
        
        _arm = [SKSpriteNode spriteNodeWithImageNamed:@"arm1"];
        _arm.zPosition = 10;
        _arm.position = CGPointMake(30,30);
        _arm.anchorPoint = CGPointMake(.03, .4);
        
        _gunFire = [SKSpriteNode spriteNodeWithImageNamed:@"gun_fire"];
        [_arm addChild:_gunFire];
        _gunFire.position = CGPointMake(([self initialShotPosition].x - self.position.x) + 60 ,([self initialShotPosition].y - self.position.y) + 5);
        _gunFire.alpha = 0;
        
        _jetPackFire = [SKSpriteNode spriteNodeWithImageNamed:@"fire"];
        
        [self addChild:_jetPackFire];
        _jetPackFire.zPosition = -2;
        _jetPackFire.position = CGPointMake(-35, -30);
        _jetPackFire.alpha = 0;
        SKAction *flame = [SKAction moveBy:CGVectorMake(0, -5) duration:.2];
        flame.timingMode = SKActionTimingEaseInEaseOut;
        SKAction *flame2 = [SKAction moveBy:CGVectorMake(0, 5) duration:.2];
        flame2.timingMode = SKActionTimingEaseInEaseOut;
        [_jetPackFire runAction:[SKAction repeatActionForever:[SKAction sequence:@[flame, flame2]]]];
        
        [self addChild:_arm];
        
        self.health = kDefaultHealth;
    }
    return self;
}

- (void)updatePhysics
{
    self.physicsBody.velocity = CGVectorMake(self.physicsBody.velocity.dx + (self.velocity.dx * self.yScale), self.physicsBody.velocity.dy + (self.velocity.dy * self.yScale));
    
    if (arc4random() % 30 == 2) {
        [self aimInDirection:CGVectorMake(-5 + arc4random() % 10, -5 + arc4random() % 10)];
    }
}

- (void)setVelocity:(CGVector)velocity
{
    _velocity = velocity;
}

- (void)aimInDirection:(CGVector)direction
{
    CGPoint dir = (CGPoint) {.x = direction.dx, .y = direction.dy};
    CGFloat angle = [self pointPairToBearingDegrees:CGPointZero secondPoint:dir];
    self.arm.zRotation = angle;
}

- (void)fire {
    [self.gunFire removeAllActions];
    SKAction *fade = [SKAction fadeAlphaTo:1.0 duration:.1];
    SKAction *fadeOut = [SKAction fadeAlphaTo:0 duration:.1];
    [self.gunFire runAction:[SKAction sequence:@[fade,fadeOut]]];
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
        self.nameLabel.position = CGPointMake(0, 240);
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
