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
@property (nonatomic, strong) NSMutableArray *players;
@property (nonatomic) double playerRotationalForce;
@property (nonatomic) BOOL touchIsDown;
@property (nonatomic) CGPoint lastTouch;
@property (nonatomic, strong) NSMutableArray *activeShots;

@property (nonatomic, strong) ControllerBrowser *controllerBrowser;
@property (nonatomic, strong) NSMutableArray *controllers;
@property (nonatomic, strong) NSMutableArray *controllerConnectedCallbacks;
@property (nonatomic, strong) NSMutableArray *controllerDisconnectedCallbacks;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
    self.controllers = [NSMutableArray array];
    self.controllerConnectedCallbacks = [NSMutableArray array];
    self.controllerDisconnectedCallbacks = [NSMutableArray array];
    
    u_int32_t identifier = arc4random_uniform(1000);
    self.controllerBrowser = [[ControllerBrowser alloc] initWithName:[NSString stringWithFormat:@"SquareShooter_%d", identifier]];
    self.controllerBrowser.delegate = self;
    [self.controllerBrowser start];
    
    
    /* Setup your scene here */


    self.players = [NSMutableArray new];

}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    /* Called when a touch begins */
//    //
//    for (UITouch *touch in touches) {
//        CGPoint location = [touch locationInNode:self];
//        self.lastTouch = location;
//    }
//
//    self.touchIsDown = YES;
//}
//
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    for (UITouch *touch in touches) {
//        CGPoint location = [touch locationInNode:self];
//        
//        self.player.velocity =  CGVectorMake(((location.x - 512) *.01),((location.y - 256) * .01));
//        self.lastTouch = location;
//    }
//}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.touchIsDown = NO;
}

-(void)update:(CFTimeInterval)currentTime {
    
    for (SQPlayer *player in self.players) {
        [player updatePhysics];
    }
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

- (void)setUpPlayerWithController:(Controller *)controller
{
    NSLog(@"Adding player for controller: %d", controller.index);
    SQPlayer *player = [[SQPlayer alloc] initWithColor:[SKColor blackColor]];
    if (controller.name) {
        player.name = controller.name;
    } else {
        player.name = [NSString stringWithFormat:@"Player %ld", (unsigned long)controller.index];
    }
    player.delegate = self;
    player.yScale = .2;
    player.xScale = .2;
    self.physicsWorld.gravity = CGVectorMake(0.0,  -.5 * player.yScale);
    self.activeShots = [NSMutableArray new];
    
    controller.leftThumbstick.valueChangedHandler = ^(float xAxis, float yAxis) {
        NSLog(@"%f, %f", xAxis, yAxis);
        player.velocity = CGVectorMake(xAxis, yAxis);
    };
    
    player = [[SQPlayer alloc] initWithColor:[SKColor redColor]];
    //    self.player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.player.size];
    player.position = CGPointMake(300, 600);
    //    self.player.physicsBody.friction = 5.0;
    //    self.player.physicsBody.linearDamping = 2.0;
    //    self.player.physicsBody.restitution = 0;
    [self addChild:player];
    [player showNameLabel];
    
    [self.players addObject:player];
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

#pragma mark - ControllerKit Delegate

- (void)onControllerConnected:(void (^)(Controller *))controllerConnected {
    [self.controllerConnectedCallbacks addObject:controllerConnected];
}

- (void)onControllerDisconnected:(void (^)(Controller *))controllerDisconnected {
    [self.controllerConnectedCallbacks addObject:controllerDisconnected];
}

#pragma mark - ControllerBrowserDelegate
- (void)controllerBrowser:(ControllerBrowser *)browser controllerConnected:(Controller *)controller type:(enum ControllerType)type {
    for (void (^callback)(Controller *controller) in self.controllerConnectedCallbacks) {
        callback(controller);
    }
    [self.controllers addObject:controller];
    
    [self setUpPlayerWithController:controller];
}

- (void)controllerBrowser:(ControllerBrowser *)browser controllerDisconnected:(Controller *)controller {
    for (void (^callback)(Controller *controller) in self.controllerDisconnectedCallbacks) {
        callback(controller);
    }
    [self.controllers removeObject:controller];
}

- (void)controllerBrowser:(ControllerBrowser *)browser encounteredError:(NSError * _Nonnull)error {
    NSLog(@"Browser encountered error: %@",error);
}

@end
