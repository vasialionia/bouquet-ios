//
// Bouquet
//
// Created by drif on 6/22/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import "BQAppDelegate+Navigation.h"
#import "BQObjectManager.h"

@implementation BQAppDelegate (Navigation)

#pragma mark Private methods

- (UIViewController *)createComplimentViewController {
    BQComplimentViewController *complimentViewController = [[BQComplimentViewController alloc] init];
    complimentViewController.delegate = self;
    complimentViewController.datasource = [BQObjectManager sharedManager];
    return complimentViewController;
}

- (UINavigationController *)createSettingsViewController {
    BQSettingsViewController *settingsViewController = [[BQSettingsViewController alloc] init];
    settingsViewController.delegate = self;
    settingsViewController.datasource = [BQObjectManager sharedManager];
    UINavigationController *settingsNavigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    return settingsNavigationController;
}

#pragma mark BQWelcomeViewControllerDelegate protocol

- (void)welcomeViewController:(BQWelcomeViewController *)welcomeViewController didSelectSex:(BQSex)sex {
    [BQObjectManager sharedManager].sex = sex;
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
