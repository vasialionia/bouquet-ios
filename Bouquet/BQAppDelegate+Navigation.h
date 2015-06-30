//
// Bouquet
//
// Created by drif on 6/22/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BQAppDelegate.h"

@interface BQAppDelegate (Navigation)

- (void)customizeNavigationControllerAppearance;
- (UIViewController *)createRootViewControllerWithComplimentId:(NSNumber *)complimentId;

@end