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

    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [self createRootViewController];
    [self.window makeKeyAndVisible];

    [[BQObjectManager sharedManager] updateComplimentsWithCompletionBlock:^(BOOL isSuccess, NSDictionary *info) {
        NSLog(@"%s %s:%d", __PRETTY_FUNCTION__, __FILE__, __LINE__);
    }];

    return YES;
}

@end
