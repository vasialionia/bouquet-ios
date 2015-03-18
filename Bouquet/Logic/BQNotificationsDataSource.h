//
// Bouquet
//
// Created by drif on 6/29/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BQSex.h"

@class BQCompliment;

@protocol BQNotificationsDataSource

@required

- (BOOL)canEnableNotifications;
- (BOOL)isNotificationsEnabled;
- (void)setNotificationsEnabled:(BOOL)enabled;

@end
