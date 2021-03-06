//
//  SQPlayer.h
//  SquareShooter
//
//  Created by Daniel Grönlund on 2015-11-27.
//  Copyright © 2015 Daniel Grönlund. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class SQPlayer;
@protocol  SQPlayerDelegate <NSObject>
- (void)player:(SQPlayer *)player didFireInDirection:(CGFloat)angle;
- (void)playerDidGetKilled:(SQPlayer *)player byPlayer:(SQPlayer *)player2;
- (BOOL)touchIsDown;
@end

@interface SQPlayer : SKSpriteNode
@property (nonatomic) int score;
@property (nonatomic) CGVector velocity;
@property (nonatomic, assign) id <SQPlayerDelegate> delegate;
@property (nonatomic) float health;
@property (nonatomic, strong) SKLabelNode *nameLabel;
@property (nonatomic) id specialAblility;
@property (nonatomic, strong) NSString *playerName;

- (instancetype)initWithColor:(UIColor *)color;
- (void)updatePhysics;
- (CGPoint)initialShotPosition;
- (void)aimInDirection:(CGVector)direction;
- (void)fire;

- (void)showNameLabel;

@end
