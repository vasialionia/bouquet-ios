//
// Bouquet
//
// Created by drif on 6/29/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import "BQNotificationsManager.h"
#import "BQComplimentDatasource.h"
#import "BQCompliment.h"

NSString *const BQNotificationsManagerKeyComplimentId = @"BQNotificationsManagerKeyComplimentId";

static NSUInteger const BQNotificationsManagerHourMin = 8;
static NSUInteger const BQNotificationsManagerHourMax = 22;
static NSUInteger const BQNotificationsManagerNotificationsCount = 64;

@implementation BQNotificationsManager {
    dispatch_queue_t _queue;
}

#pragma mark Private methods

- (void)scheduleNotifications {
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];

    for (NSUInteger i = 0; i < BQNotificationsManagerNotificationsCount; i ++) {
        NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[[NSDate date] dateByAddingTimeInterval:24 * 60 * 60 * i]];

        dateComponents.hour = BQNotificationsManagerHourMin + arc4random() % (BQNotificationsManagerHourMax - BQNotificationsManagerHourMin + 1);
        dateComponents.minute = 0;

        BQCompliment *compliment = [self.complimentDatasource getRandCompliment];

        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [calendar dateFromComponents:dateComponents];
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.alertBody = compliment.text;
        localNotification.alertAction = @":-)";
        localNotification.userInfo = @{
            BQNotificationsManagerKeyComplimentId: compliment.complimentId
        };

        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

#pragma mark NSObject methods

- (id)init {
    self = [super init];
    if (self != nil) {
        _queue = dispatch_queue_create("by.vasialionia.bouquet.notificationsmanager", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

#pragma mark BQNotificationsDataSource protocol

- (BOOL)isNotificationsEnabled {
    __block BOOL enabled = NO;
    dispatch_sync(_queue, ^{
        enabled = [UIApplication sharedApplication].scheduledLocalNotifications.count > 0;
    });
    return enabled;
}

- (void)setNotificationsEnabled:(BOOL)notificationsEnabled {
    if (self.notificationsEnabled == notificationsEnabled) {
        return;
    }

    dispatch_async(_queue, ^{
        if (notificationsEnabled) {
            [self scheduleNotifications];
        }
        else {
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
        }
    });
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
