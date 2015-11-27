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
- (BOOL)touchIsDown;
@end

@interface SQPlayer : SKSpriteNode
- (instancetype)initWithColor:(UIColor *)color;
@property (nonatomic) CGVector velocity;
@property (nonatomic, assign) id <SQPlayerDelegate> delegate;

- (void)updatePhysics;

@end
