//
//  AppDelegate.h
//  SquareShooter
//
//  Created by Daniel Grönlund on 2015-11-27.
//  Copyright © 2015 Daniel Grönlund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ControllerKit/ControllerKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

- (instancetype)sharedInstance;

@property (strong, nonatomic) UIWindow *window;

- (void)onControllerConnected:(void(^)(Controller *controller))controllerConnected;
- (void)onControllerDisconnected:(void(^)(Controller *controller))controllerDisconnected;

@end

