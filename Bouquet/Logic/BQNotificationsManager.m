//
// Bouquet
//
// Created by drif on 6/29/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import "BQNotificationsManager.h"
#import "BQComplimentDatasource.h"
#import "BQCompliment.h"

static NSUInteger const BQNotificationsManagerHourMin = 8;
static NSUInteger const BQNotificationsManagerHourMax = 22;
static NSUInteger const BQNotificationsManagerNotificationsCount = 64;

@implementation BQNotificationsManager

#pragma mark Private methods

- (void)scheduleNotifications {
    BQAssert(!self.notificationsEnabled, @"Notifications are already scheduled.");

    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];

    for (NSUInteger i = 0; i < BQNotificationsManagerNotificationsCount; i ++) {
        NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[[NSDate date] dateByAddingTimeInterval:24 * 60 * 60 * i]];

        dateComponents.hour = BQNotificationsManagerHourMin + arc4random() % (BQNotificationsManagerHourMax - BQNotificationsManagerHourMin + 1);
        dateComponents.minute = 0;

        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [calendar dateFromComponents:dateComponents];
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.alertBody = [self.complimentDatasource getRandCompliment].text;
        localNotification.alertAction = @":-)";

        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

#pragma mark BQNotificationsDataSource protocol

- (BOOL)isNotificationsEnabled {
    return [UIApplication sharedApplication].scheduledLocalNotifications.count > 0;
}

- (void)setNotificationsEnabled:(BOOL)notificationsEnabled {
    if (self.notificationsEnabled == notificationsEnabled) {
        return;
    }

    if (notificationsEnabled) {
        [self scheduleNotifications];
    }
    else {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}

#pragma mark Interface methods

+ (instancetype)sharedManager {
    static id instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)renewNotifications {
    BQAssert(self.notificationsEnabled, @"Notifications are off.");

    self.notificationsEnabled = NO;
    self.notificationsEnabled = YES;
}

@end