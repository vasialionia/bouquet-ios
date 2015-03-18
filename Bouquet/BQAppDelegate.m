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

@implementation BQAppDelegate

#pragma mark UIApplicationDelegate methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#if !DEBUG
    [Crashlytics startWithAPIKey:[NSString stringWithCString:CC_TOKEN encoding:NSUTF8StringEncoding]];
#endif

    [[BQAnalyticsManager shareManager] initializeWithToken:[NSString stringWithCString:GA_TOKEN encoding:NSUTF8StringEncoding]];

    RKLogConfigureByName("RestKit/*", RKLogLevelWarning);
    BQObjectManager *objectManager = [BQObjectManager managerWithBaseURL:[NSURL URLWithString:[NSString stringWithCString:API_URL encoding:NSUTF8StringEncoding]]];
    [BQObjectManager setSharedManager:objectManager];

    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

    [BQNotificationsManager sharedManager].complimentDatasource = objectManager;

    UILocalNotification *notification = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    NSNumber *complimentId = notification.userInfo[BQNotificationsManagerKeyComplimentId];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [self createRootViewControllerWithComplimentId:complimentId];
    [self.window makeKeyAndVisible];

    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:nil]];
    }

    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[BQObjectManager sharedManager] updateComplimentsIfNeeded];

    if ([BQNotificationsManager sharedManager].notificationsEnabled) {
        [[BQNotificationsManager sharedManager] renewNotifications];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if (application.applicationState == UIApplicationStateInactive) {
        NSNumber *complimentId = notification.userInfo[BQNotificationsManagerKeyComplimentId];
        self.window.rootViewController = [self createRootViewControllerWithComplimentId:complimentId];
    }
}

#pragma mark Interface methods

- (BOOL)isFirstRun {
    return ![[NSUserDefaults standardUserDefaults] boolForKey:BQFirstRunKey];
}

@end
