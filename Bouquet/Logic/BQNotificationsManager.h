//
// Bouquet
//
// Created by drif on 6/29/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BQNotificationsDataSource.h"

@protocol BQComplimentDatasource;

@interface BQNotificationsManager : NSObject <
    BQNotificationsDataSource
>

@property (nonatomic, assign, getter=isNotificationsEnabled) BOOL notificationsEnabled;
@property (nonatomic, strong) id<BQComplimentDatasource> complimentDatasource;

+ (instancetype)sharedManager;
- (void)renewNotifications;

@end
