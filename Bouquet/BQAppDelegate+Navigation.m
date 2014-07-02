//
// Bouquet
//
// Created by drif on 6/22/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import "BQAppDelegate+Navigation.h"
#import "BQObjectManager.h"
#import "BQLicenseViewController.h"
#import "BQNotificationsManager.h"
#import "BQCompliment.h"

static NSTimeInterval const BQFlipAnimationDuration = 0.7f;

@implementation BQAppDelegate (Navigation)

#pragma mark Private methods

- (UIViewController *)createWelcomeViewController {
    BQWelcomeViewController *welcomeViewController = [[BQWelcomeViewController alloc] init];
    welcomeViewController.delegate = self;
    return welcomeViewController;
}

- (UIViewController *)createComplimentViewController {
    BQComplimentViewController *complimentViewController = [[BQComplimentViewController alloc] init];
    complimentViewController.delegate = self;
    complimentViewController.complimentDatasource = [BQObjectManager sharedManager];
    return complimentViewController;
}

- (UINavigationController *)createSettingsViewController {
    BQSettingsViewController *settingsViewController = [[BQSettingsViewController alloc] init];
    settingsViewController.delegate = self;
    settingsViewController.settingsDatasource = [BQObjectManager sharedManager];
    settingsViewController.notificationsDatasource = [BQNotificationsManager sharedManager];
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
    [BQNotificationsManager sharedManager].notificationsEnabled = YES;

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:BQFirstRunKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

    self.window.rootViewController = [self createComplimentViewController];
    [UIView transitionWithView:self.window duration:BQFlipAnimationDuration options:UIViewAnimationOptionTransitionFlipFromLeft animations:nil completion:nil];
}

#pragma mark BQComplimentViewControllerDelegate protocol

- (void)complimentViewControllerDidTapInfoButton:(BQComplimentViewController *)complimentViewController {
    self.window.rootViewController = [self createSettingsViewController];
    [UIView transitionWithView:self.window duration:BQFlipAnimationDuration options:UIViewAnimationOptionTransitionFlipFromLeft animations:nil completion:nil];
}

- (void)complimentViewController:(BQComplimentViewController *)complimentViewController didTapShareButtonForCompliment:(BQCompliment *)compliment {
    [UIPasteboard generalPasteboard].string = compliment.text;

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Copied to clipboard", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
}

#pragma mark BQSettingsViewControllerDelegate protocol

- (void)settingsViewControllerDidTapDone:(BQSettingsViewController *)settingsViewController {
    if ([BQNotificationsManager sharedManager].notificationsEnabled) {
        [[BQNotificationsManager sharedManager] renewNotifications];
    }

    self.window.rootViewController = [self createComplimentViewController];
    [UIView transitionWithView:self.window duration:BQFlipAnimationDuration options:UIViewAnimationOptionTransitionFlipFromLeft animations:nil completion:nil];
}

- (void)settingsViewController:(BQSettingsViewController *)settingsViewController didSelectLibrary:(BQSettingsViewControllerLibrary)library {
    NSString *licensePath = [[NSBundle mainBundle] pathForResource:@"RestKitLicense" ofType:nil];
    UIViewController *licenseViewController = [self createLicenseViewControllerWithLicensePath:licensePath];
    licenseViewController.title = @"RestKit License";
    [(UINavigationController *)self.window.rootViewController pushViewController:licenseViewController animated:YES];
}

#pragma mark Interface methods

- (UIViewController *)createRootViewController {
    return [self isFirstRun] ? [self createWelcomeViewController] : [self createComplimentViewController];
}

@end
