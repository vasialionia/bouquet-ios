//
//  BQAppDelegate.m
//  Bouquet
//
//  Created by drif on 6/22/14.
//  Copyright (c) 2014 vasialionia. All rights reserved.
//

#import <RestKit/RKLog.h>
#import "BQAppDelegate.h"
#import "BQAppDelegate+Navigation.h"
#import "BQObjectManager.h"

static NSString *const BQBaseAPIURLString = @"http://dev-vlbouquet.rhcloud.com/";
static NSString *const BQFirstRunKey = @"BQFirstRunKey";

@implementation BQAppDelegate

#pragma mark UIApplicationDelegate methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    RKLogConfigureByName("RestKit/*", RKLogLevelWarning);
    BQObjectManager *objectManager = [BQObjectManager managerWithBaseURL:[NSURL URLWithString:BQBaseAPIURLString]];
    [BQObjectManager setSharedManager:objectManager];

    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [self createRootViewController];
    [self.window makeKeyAndVisible];

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:BQFirstRunKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[BQObjectManager sharedManager] updateComplimentsWithCompletionBlock:nil];
}

#pragma mark Interface methods

- (BOOL)isFirstRun {
    return ![[NSUserDefaults standardUserDefaults] boolForKey:BQFirstRunKey];
}

@end
