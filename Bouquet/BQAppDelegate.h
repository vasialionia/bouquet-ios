//
//  BQAppDelegate.h
//  Bouquet
//
//  Created by drif on 6/22/14.
//  Copyright (c) 2014 vasialionia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BQWelcomeViewController.h"

@interface BQAppDelegate : UIResponder <
    UIApplicationDelegate,
    BQWelcomeViewControllerDelegate
>

@property (nonatomic, strong) UIWindow *window;

@end
