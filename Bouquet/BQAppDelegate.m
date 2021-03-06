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
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#endif

NSString *const BQAppDelegateIsFirstRunKey = @"BQAppDelegateIsFirstRunKey";

@implementation BQAppDelegate

#pragma mark UIApplicationDelegate methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#if !DEBUG
    [Fabric with:@[CrashlyticsKit]];
#endif

    [[BQAnalyticsManager shareManager] initializeWithToken:[NSString stringWithCString:GA_TOKEN encoding:NSUTF8StringEncoding]];

    RKLogConfigureByName("RestKit/*", RKLogLevelWarning);
    BQObjectManager *objectManager = [BQObjectManager managerWithBaseURL:[NSURL URLWithString:[NSString stringWithCString:API_URL encoding:NSUTF8StringEncoding]]];
    [BQObjectManager setSharedManager:objectManager];

    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

    [BQNotificationsManager sharedManager].complimentDatasource = objectManager;

    UILocalNotification *notification = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    NSNumber *complimentId = notification.userInfo[BQNotificationsManagerKeyComplimentId];

    [self customizeNavigationControllerAppearance];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [self createRootViewControllerWithComplimentId:complimentId];
    [self.window makeKeyAndVisible];

    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:nil]];
    }

    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [[BQObjectManager sharedManager] updateComplimentsIfNeeded];
    });

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
    return ![[NSUserDefaults standardUserDefaults] boolForKey:BQAppDelegateIsFirstRunKey];
}

@end
