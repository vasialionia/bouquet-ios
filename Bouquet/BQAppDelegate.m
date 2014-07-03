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
#import "BQNotificationsManager.h"
#import "BQAnalyticsManager.h"

#if !DEBUG
#import <Crashlytics/Crashlytics.h>
#endif

NSString *const BQFirstRunKey = @"BQFirstRunKey";

static NSString *const BQBaseAPIURLString = @"http://dev-vlbouquet.rhcloud.com/";

@implementation BQAppDelegate

#pragma mark UIApplicationDelegate methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#if !DEBUG
    [Crashlytics startWithAPIKey:[NSString stringWithCString:CC_TOKEN encoding:NSUTF8StringEncoding]];
#endif

    [[BQAnalyticsManager shareManager] initializeWithToken:[NSString stringWithCString:GA_TOKEN encoding:NSUTF8StringEncoding]];

    RKLogConfigureByName("RestKit/*", RKLogLevelWarning);
    BQObjectManager *objectManager = [BQObjectManager managerWithBaseURL:[NSURL URLWithString:BQBaseAPIURLString]];
    [BQObjectManager setSharedManager:objectManager];

    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

    [BQNotificationsManager sharedManager].complimentDatasource = objectManager;

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [self createRootViewController];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[BQObjectManager sharedManager] updateComplimentsWithCompletionBlock:nil];

    if ([BQNotificationsManager sharedManager].notificationsEnabled) {
        [[BQNotificationsManager sharedManager] renewNotifications];
    }
}

#pragma mark Interface methods

- (BOOL)isFirstRun {
    return ![[NSUserDefaults standardUserDefaults] boolForKey:BQFirstRunKey];
}

@end
