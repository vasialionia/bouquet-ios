//
//  BQAppDelegate.h
//  Bouquet
//
//  Created by drif on 6/22/14.
//  Copyright (c) 2014 vasialionia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BQWelcomeViewController.h"
#import "BQComplimentViewController.h"
#import "BQSettingsViewController.h"

extern NSString *const BQAppDelegateIsFirstRunKey;

@interface BQAppDelegate : UIResponder <
    UIApplicationDelegate,
    BQWelcomeViewControllerDelegate,
    BQComplimentViewControllerDelegate,
    BQSettingsViewControllerDelegate
>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, assign, readonly) BOOL isFirstRun;

@end
