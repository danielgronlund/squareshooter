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

#define kGravityFactor .4

@interface GameScene () <SQPlayerDelegate>
@property (nonatomic, strong) NSMutableArray *players;
@property (nonatomic, strong) NSMutableArray *deadPlayers;
@property (nonatomic, strong) NSMutableArray *clouds;
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
    self.deadPlayers = [NSMutableArray new];
    self.gameAnnouncementsLabel = [[SKLabelNode alloc] initWithFontNamed:@"ArialRoundedMTBold"];
    self.gameAnnouncementsLabel.fontSize = 80;
    self.gameAnnouncementsLabel.yScale = 0;
    self.gameAnnouncementsLabel.xScale = 0;
    [self addChild:self.gameAnnouncementsLabel];
    self.gameAnnouncementsLabel.position = CGPointMake(0, 240);
    
    self.controllers = [NSMutableArray array];
    self.controllerConnectedCallbacks = [NSMutableArray array];
    self.controllerDisconnectedCallbacks = [NSMutableArray array];
    
    self.controllerBrowser = [[ControllerBrowser alloc] initWithName:@"SquareShooter_2"];
    self.controllerBrowser.delegate = self;
    [self.controllerBrowser start];
    
    self.clouds = [NSMutableArray new];
    
   
    /* Setup your scene here */
    
    [self setUpPlayerWithController:nil];
    
    self.players = [NSMutableArray new];
    self.physicsWorld.gravity = CGVectorMake(0.0,  -.5 * kGravityFactor);
    
    //[self announceMessage:@"Welcome"];
    self.gameAnnouncementsLabel.alpha = .7;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    self.gameAnnouncementsLabel.position = CGPointMake(screenSize.width / 2, 100);
    
    for (int i = 0; i < 6;  i ++ ) {
        SKSpriteNode *cloud = [SKSpriteNode spriteNodeWithImageNamed:@"cloud"];
        [self addChild:cloud];
        cloud.position = CGPointMake((cloud.size.width * i) + 100 + (arc4random() % 400), 300 + arc4random() % ((int)screenSize.height - 300));
        [self.clouds addObject:cloud];
        cloud.zPosition = -5;
        
    }
    
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
    
    [self updateClouds];
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

- (void)updateClouds
{
    for (SKSpriteNode *cloud in self.clouds) {
        cloud.position = CGPointMake(cloud.position.x - 1, cloud.position.y);
        if (cloud.position.x < -(cloud.size.width / 2))cloud.position = CGPointMake(1920 + (cloud.size.width / 2),  400 + arc4random() % 500);
    }
}

- (void)setUpPlayerWithController:(Controller *)controller
{
    SQPlayer *player = [[SQPlayer alloc] initWithColor:[SKColor blackColor]];
    
    player.delegate = self;
 
    self.activeShots = [NSMutableArray new];
    
    
    player = [[SQPlayer alloc] initWithColor:[SKColor grayColor]];
    //    self.player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.player.size];
    player.position = CGPointMake(300, 600);
    //    self.player.physicsBody.friction = 5.0;
    //    self.player.physicsBody.linearDamping = 2.0;
    //    self.player.physicsBody.restitution = 0;
    [self addChild:player];
    player.yScale = kGravityFactor;
    player.xScale = kGravityFactor;
    [player showNameLabel];
}

- (void)endGame
{
    SQPlayer *remainingPlayer = self.players.firstObject;
    if (remainingPlayer) {
        [self announceMessage:[NSString stringWithFormat:@"%@ won",remainingPlayer.name]];
    }
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

- (void)announceMessage:(NSString *)string
{
    self.gameAnnouncementsLabel.text = string;
    
    self.gameAnnouncementsLabel.xScale = 0;
    self.gameAnnouncementsLabel.yScale = 0;
    SKAction *scaleUp = [SKAction scaleTo:1.0 duration:.2];
    SKAction *wait = [SKAction waitForDuration:1.0];
    SKAction *scaleDown = [SKAction scaleTo:0.0 duration:.2];
    SKAction *sequence = [SKAction sequence:@[scaleUp,wait,scaleDown]];
    [self.gameAnnouncementsLabel runAction:sequence];
    
}

- (void)playerDidGetKilled:(SQPlayer *)player byPlayer:(SQPlayer *)player2
{
    [self announceMessage:[NSString stringWithFormat:@"Player %@ got smashed by %@", player.name, player2.name]];
    [player removeFromParent];
    [self.players removeObject:player];
    [self.deadPlayers addObject:player];
    player2.score += 1;
    if (self.players.count == 1) {
        [self endGame];
    }
}

#pragma mark - ControllerKit Delegate

- (void)onControllerConnected:(void (^)(Controller *))controllerConnected {
    [self.controllerConnectedCallbacks addObject:controllerConnected];
    [self announceMessage:[NSString stringWithFormat:@"Player %d joined", (int)[self.controllers count]]];
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
    controller.dpad.valueChangedHandler = ^(float xAxis, float yAxis) {
        NSLog(@"%f, %f", xAxis, yAxis);
    };
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
