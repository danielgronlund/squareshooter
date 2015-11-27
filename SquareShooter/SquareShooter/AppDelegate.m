//
//  AppDelegate.m
//  SquareShooter
//
//  Created by Daniel Grönlund on 2015-11-27.
//  Copyright © 2015 Daniel Grönlund. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () <ControllerBrowserDelegate>

@property (nonatomic, strong) ControllerBrowser *controllerBrowser;

@property (nonatomic, strong) NSMutableArray *controllers;
@property (nonatomic, strong) NSMutableArray *controllerConnectedCallbacks;
@property (nonatomic, strong) NSMutableArray *controllerDisconnectedCallbacks;

@end

@implementation AppDelegate

- (instancetype)sharedInstance
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.controllers = [NSMutableArray array];
    self.controllerConnectedCallbacks = [NSMutableArray array];
    self.controllerDisconnectedCallbacks = [NSMutableArray array];

    self.controllerBrowser = [[ControllerBrowser alloc] initWithName:@"SquareShooter"];
    self.controllerBrowser.delegate = self;
    [self.controllerBrowser start];
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

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
    NSLog(@"Browser encountered error: %@");
}

@end
