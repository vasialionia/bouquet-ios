//
// Bouquet
//
// Created by drif on 6/22/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import "BQAppDelegate+Navigation.h"
#import "BQObjectManager.h"
#import "BQLicenseViewController.h"

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

- (UIViewController *)createLicenseViewControllerWithLicensePath:(NSString *)path {
    NSError *error = nil;
    NSString *license = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:&error];
    if (error) {
        BQLogError(@"Can't read file at path: %@. %@", path, error);
    }

    BQLicenseViewController *licenseViewController = [[BQLicenseViewController alloc] init];
    licenseViewController.licenseText = license;
    return licenseViewController;
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
    NSString *licensePath = [[NSBundle mainBundle] pathForResource:@"RestKitLicense" ofType:nil];
    UIViewController *licenseViewController = [self createLicenseViewControllerWithLicensePath:licensePath];
    licenseViewController.title = @"RestKit License";
    [(UINavigationController *)self.window.rootViewController pushViewController:licenseViewController animated:YES];
}

#pragma mark Interface methods

- (UIViewController *)createRootViewController {
    BQWelcomeViewController *welcomeViewController = [[BQWelcomeViewController alloc] init];
    welcomeViewController.delegate = self;
    return welcomeViewController;
}

@end
