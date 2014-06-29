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

@implementation BQAppDelegate

#pragma mark UIApplicationDelegate methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    RKLogConfigureByName("RestKit/*", RKLogLevelWarning);
    BQObjectManager *objectManager = [BQObjectManager managerWithBaseURL:[NSURL URLWithString:BQBaseAPIURLString]];
    [BQObjectManager setSharedManager:objectManager];
    [[BQObjectManager sharedManager] updateComplimentsWithCompletionBlock:nil];

    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [self createRootViewController];
    [self.window makeKeyAndVisible];

    return YES;
}

@end
