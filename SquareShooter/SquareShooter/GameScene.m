//
//  GameScene.m
//  SquareShooter
//
//  Created by Daniel Grönlund on 2015-11-27.
//  Copyright (c) 2015 Daniel Grönlund. All rights reserved.
//

#import "GameScene.h"
#import "SQPlayer.h"
#import "SQShot.h"
#import "SKSpriteNode+mathAdditions.h"

@interface GameScene () <SQPlayerDelegate>
@property (nonatomic, strong) SQPlayer *player;
@property (nonatomic) double playerRotationalForce;
@property (nonatomic) BOOL touchIsDown;
@property (nonatomic) CGPoint lastTouch;
@property (nonatomic, strong) NSMutableArray *activeShots;
@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    [self setUpPlayer];

    self.player.delegate = self;
    self.player.yScale = .2;
    self.player.xScale = .2;
    self.physicsWorld.gravity = CGVectorMake(0.0,  -.5 * self.player.yScale);
    self.activeShots = [NSMutableArray new];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    //
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        self.lastTouch = location;
    }

    self.touchIsDown = YES;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        self.player.velocity =  CGVectorMake(((location.x - 512) *.01),((location.y - 256) * .01));
        self.lastTouch = location;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.touchIsDown = NO;
}

-(void)update:(CFTimeInterval)currentTime {
    
    [self.player updatePhysics];
    NSMutableIndexSet *removedShots = [NSMutableIndexSet new];
    for (SQShot *shot in self.activeShots) {
        [shot updatePhysics];
        if (![self intersectsNode:shot]) {
            [shot destroy];
            [removedShots addIndex:[self.activeShots indexOfObject:shot]];
        }
    }

    [self.activeShots removeObjectsAtIndexes:removedShots];
    
    /* Called before each frame is rendered */
    //  if (!self.touchIsDown) self.playerRotationalForce = self.playerRotationalForce * .08;
}

- (void)setUpPlayer
{
    self.player = [[SQPlayer alloc] initWithColor:[SKColor redColor]];
    //    self.player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.player.size];
    self.player.position = CGPointMake(300, 600);
    //    self.player.physicsBody.friction = 5.0;
    //    self.player.physicsBody.linearDamping = 2.0;
    //    self.player.physicsBody.restitution = 0;
    [self addChild:self.player];
    [self.player showNameLabel];
}


#pragma markf - SQPlayerDelegate implementation

- (BOOL)touchIsDown
{
    return _touchIsDown;
}

- (void)player:(SQPlayer *)player didFireInDirection:(CGFloat)angle
{
    SQShot *shot = [[SQShot alloc] initWithRotation:angle andSpeed:100];
    shot.position = [player initialShotPosition];
    shot.yScale = player.yScale;
    shot.xScale = player.xScale;
    [self addChild:shot];
    [self.activeShots addObject:shot];
}

@end
