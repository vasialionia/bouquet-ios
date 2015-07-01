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
#import "BQAnalyticsManager.h"
#import "UIColor+BQ.h"

static NSTimeInterval const BQFlipAnimationDuration = 0.3f;

@implementation BQAppDelegate (Navigation)

#pragma mark Private methods

- (void)customizeNavigationControllerAppearance {
    [[UINavigationBar appearance] setBarTintColor:[UIColor bqMainColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];

    if ([[UINavigationBar appearance] respondsToSelector:@selector(setTranslucent:)]) {
        [[UINavigationBar appearance] setTranslucent:NO];
    }
}

- (UIViewController *)createWelcomeViewController {
    [[BQAnalyticsManager shareManager] trackPageView:BQAnalyticsManagerPageWelcome];

    BQWelcomeViewController *welcomeViewController = [[BQWelcomeViewController alloc] init];
    welcomeViewController.delegate = self;
    UINavigationController *welcomeNavigationController = [[UINavigationController alloc] initWithRootViewController:welcomeViewController];
    return welcomeNavigationController;
}

- (UIViewController *)createComplimentViewControllerWithComplimentId:(NSNumber *)complimentId {
    [[BQAnalyticsManager shareManager] trackPageView:BQAnalyticsManagerPageCompliment];

    BQComplimentViewController *complimentViewController = [[BQComplimentViewController alloc] init];
    complimentViewController.delegate = self;
    complimentViewController.complimentDatasource = [BQObjectManager sharedManager];
    complimentViewController.settingsDatasource = [BQObjectManager sharedManager];

    if (complimentId != nil) {
        complimentViewController.compliment = [[BQObjectManager sharedManager] getComplimentWithId:complimentId];
    }

    UINavigationController *complimentNavigationController = [[UINavigationController alloc] initWithRootViewController:complimentViewController];
    return complimentNavigationController;
}

- (UINavigationController *)createSettingsViewController {
    [[BQAnalyticsManager shareManager] trackPageView:BQAnalyticsManagerPageSettings];

    BQSettingsViewController *settingsViewController = [[BQSettingsViewController alloc] init];
    settingsViewController.delegate = self;
    settingsViewController.settingsDatasource = [BQObjectManager sharedManager];
    settingsViewController.notificationsDatasource = [BQNotificationsManager sharedManager];
    UINavigationController *settingsNavigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    return settingsNavigationController;
}

- (UIViewController *)createLicenseViewControllerWithLicensePath:(NSString *)path {
    [[BQAnalyticsManager shareManager] trackPageView:BQAnalyticsManagerPageLicense];

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

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [BQNotificationsManager sharedManager].notificationsEnabled = YES;
    });

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:BQAppDelegateIsFirstRunKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

    self.window.rootViewController = [self createComplimentViewControllerWithComplimentId:nil];
    [UIView transitionWithView:self.window duration:BQFlipAnimationDuration options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
}

#pragma mark BQComplimentViewControllerDelegate protocol

- (void)complimentViewControllerDidTapInfoButton:(BQComplimentViewController *)complimentViewController {
    [complimentViewController presentViewController:[self createSettingsViewController] animated:YES completion:nil];
}

- (void)complimentViewControllerDidTapShareButton:(BQComplimentViewController *)complimentViewController {
    [UIPasteboard generalPasteboard].string = complimentViewController.compliment.text;

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Copied to clipboard", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });

    [[BQAnalyticsManager shareManager] trackShareTap];
}

- (void)complimentViewControllerDidTapCompliment:(BQComplimentViewController *)complimentViewController {
    [[BQAnalyticsManager shareManager] trackComplimentTap];
}

#pragma mark BQSettingsViewControllerDelegate protocol

- (void)settingsViewControllerDidTapDone:(BQSettingsViewController *)settingsViewController {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if ([BQNotificationsManager sharedManager].notificationsEnabled) {
            [[BQNotificationsManager sharedManager] renewNotifications];
        }
    });

    [settingsViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)settingsViewController:(BQSettingsViewController *)settingsViewController didSelectLibrary:(BQSettingsViewControllerLibrary)library {
    NSString *licenseFileName;
    NSString *title;
    switch (library) {
        case BQSettingsViewControllerLibraryRestKit:
            licenseFileName = @"RestKitLicense";
            title = @"RestKit";
            break;
        case BQSettingsViewControllerLibraryYetiCharacterLabel:
            licenseFileName = @"YetiCharacterLabelLicense";
            title = @"YetiCharacterLabel";
            break;
        default:
            BQAssert(NO, @"Unknown library key. %d", (int)library);
            licenseFileName = nil;
            break;
    }
    NSString *licensePath = [[NSBundle mainBundle] pathForResource:licenseFileName ofType:nil];
    UIViewController *licenseViewController = [self createLicenseViewControllerWithLicensePath:licensePath];
    licenseViewController.title = title;
    [settingsViewController.navigationController pushViewController:licenseViewController animated:YES];
}

- (void)settingsViewController:(BQSettingsViewController *)settingsViewController didSelectSourceCode:(BQSettingsViewControllerSourceCode)sourceCode {
    NSURL *url = nil;
    switch (sourceCode) {
        case BQSettingsViewControllerSourceCodeIOS:
            url = [NSURL URLWithString:@"https://github.com/vasialionia/bouquet-ios"];
            break;
        case BQSettingsViewControllerSourceCodeServer:
            url = [NSURL URLWithString:@"https://github.com/vasialionia/bouquet-api"];
            break;
        default:
            BQAssert(NO, @"Unknown source code key. %d", (int)sourceCode);
            url = [NSURL URLWithString:@"https://github.com/vasialionia"];
            break;
    }
    [[UIApplication sharedApplication] openURL:url];
}

- (void)settingsViewController:(BQSettingsViewController *)settingsViewController didChangeNotificationsSettingsToValue:(BOOL)value {
    [[BQAnalyticsManager shareManager] trackNotificationsChangeToValue:value];
}

- (void)settingsViewController:(BQSettingsViewController *)settingsViewController didChangeSexFrom:(BQSex)fromSex to:(BQSex)toSex {
    [[BQAnalyticsManager shareManager] trackSexChangeFrom:fromSex to:toSex];
}

#pragma mark Interface methods

- (UIViewController *)createRootViewControllerWithComplimentId:(NSNumber *)complimentId {
    return [self isFirstRun] ? [self createWelcomeViewController] : [self createComplimentViewControllerWithComplimentId:complimentId];
}

@end
