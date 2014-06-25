//
// Bouquet
//
// Created by drif on 6/22/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import "BQAppDelegate+Navigation.h"

@implementation BQAppDelegate (Navigation)

#pragma mark Private methods

- (UIViewController *)createComplimentViewController {
    BQComplimentViewController *complimentViewController = [[BQComplimentViewController alloc] init];
    complimentViewController.delegate = self;
    return complimentViewController;
}

- (UINavigationController *)createSettingsViewController {
    BQSettingsViewController *settingsViewController = [[BQSettingsViewController alloc] init];
    settingsViewController.delegate = self;
    UINavigationController *settingsNavigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    return settingsNavigationController;
}

#pragma mark BQWelcomeViewControllerDelegate protocol

- (void)welcomeViewController:(BQWelcomeViewController *)welcomeViewController didSelectSexMode:(BQWelcomeViewControllerSexMode)sexMode {
    self.window.rootViewController = [self createComplimentViewController];
}

#pragma mark BQComplimentViewControllerDelegate protocol

- (void)complimentViewControllerDidTapInfoButton:(BQComplimentViewController *)complimentViewController {
    self.window.rootViewController = [self createSettingsViewController];
}

#pragma mark BQSettingsViewControllerDelegate protocol

- (void)settingsViewControllerDidTapDone:(BQSettingsViewController *)settingsViewController {
    self.window.rootViewController = [self createComplimentViewController];
}

- (void)settingsViewController:(BQSettingsViewController *)settingsViewController didSelectLibrary:(BQSettingsViewControllerLibrary)library {
    [(UINavigationController *)self.window.rootViewController pushViewController:[[UIViewController alloc] init] animated:YES];
}

#pragma mark Interface methods

- (UIViewController *)createRootViewController {
    BQWelcomeViewController *welcomeViewController = [[BQWelcomeViewController alloc] init];
    welcomeViewController.delegate = self;
    return welcomeViewController;
}

@end
