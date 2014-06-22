//
// Bouquet
//
// Created by drif on 6/22/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import "BQAppDelegate+Navigation.h"

@implementation BQAppDelegate (Navigation)

#pragma mark BQWelcomeViewControllerDelegate protocol

- (void)welcomeViewController:(BQWelcomeViewController *)welcomeViewController didSelectSexMode:(BQWelcomeViewControllerSexMode)sexMode
{
    NSLog(@"%s %s:%d", __PRETTY_FUNCTION__, __FILE__, __LINE__);
}

#pragma mark Interface methods

- (UIViewController *)createRootViewController
{
    BQWelcomeViewController *welcomeViewController = [[BQWelcomeViewController alloc] init];
    welcomeViewController.delegate = self;
    return welcomeViewController;
}

@end
