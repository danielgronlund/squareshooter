//
//  GameScene.h
//  SquareShooter
//

//  Copyright (c) 2015 Daniel Grönlund. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <ControllerKit/ControllerKit.h>

@interface GameScene : SKScene <ControllerBrowserDelegate>

@property (nonatomic, strong) SKLabelNode *gameAnnouncementsLabel;

- (void)onControllerConnected:(void(^)(Controller *controller))controllerConnected;
- (void)onControllerDisconnected:(void(^)(Controller *controller))controllerDisconnected;

@end
