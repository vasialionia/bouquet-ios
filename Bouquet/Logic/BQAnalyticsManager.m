//
// Bouquet
//
// Created by drif on 7/3/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import "BQAnalyticsManager.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"
#import "BQSettingsDatasource.h"
#import "BQNotificationsDataSource.h"

#if DEBUG
static NSTimeInterval BQAnalyticsManagerDispatchInterval = 5.0f;
#else
static NSTimeInterval BQAnalyticsManagerDispatchInterval = 20.0f;
#endif

typedef NS_ENUM(NSUInteger, BQAnalyticsManagerCustomDimension) {
    BQAnalyticsManagerCustomDimensionSex = 1,
    BQAnalyticsManagerCustomDimensionNotifications = 2,
    BQAnalyticsManagerCustomDimensionAppRun = 3,
    BQAnalyticsManagerCustomDimensionTimeSinceLastRun = 4,
    BQAnalyticsManagerCustomDimensionNotificationsChanges = 5,
    BQAnalyticsManagerCustomDimensionSexChanges = 6,
    BQAnalyticsManagerCustomDimensionDebug = 7
};

@interface BQAnalyticsManager ()

@property (nonatomic, assign) NSUInteger appRunCounter;
@property (nonatomic, assign) NSTimeInterval timeSinceLastRun;
@property (nonatomic, assign) NSUInteger complimentsCountInRow;
@property (nonatomic, assign) NSUInteger notificationsChangesCount;
@property (nonatomic, assign) NSUInteger sexChangesCount;

@end

@implementation BQAnalyticsManager

#pragma mark Private methods

- (void)setCustomDimensions {
    [[GAI sharedInstance].defaultTracker set:[GAIFields customDimensionForIndex:BQAnalyticsManagerCustomDimensionSex] value:[self getSexName:self.settingsDatasource.sex]];
    [[GAI sharedInstance].defaultTracker set:[GAIFields customDimensionForIndex:BQAnalyticsManagerCustomDimensionNotifications] value:self.notificationsDatasource.isNotificationsEnabled ? @"yes" : @"no"];
    [[GAI sharedInstance].defaultTracker set:[GAIFields customDimensionForIndex:BQAnalyticsManagerCustomDimensionAppRun] value:[NSString stringWithFormat:@"%lu", (unsigned long)self.appRunCounter]];
    [[GAI sharedInstance].defaultTracker set:[GAIFields customDimensionForIndex:BQAnalyticsManagerCustomDimensionTimeSinceLastRun] value:[NSString stringWithFormat:@"%f", self.timeSinceLastRun]];
    [[GAI sharedInstance].defaultTracker set:[GAIFields customDimensionForIndex:BQAnalyticsManagerCustomDimensionNotificationsChanges] value:[NSString stringWithFormat:@"%lu", (unsigned long)self.notificationsChangesCount]];
    [[GAI sharedInstance].defaultTracker set:[GAIFields customDimensionForIndex:BQAnalyticsManagerCustomDimensionSexChanges] value:[NSString stringWithFormat:@"%lu", (unsigned long)self.sexChangesCount]];
#if DEBUG
    [[GAI sharedInstance].defaultTracker set:[GAIFields customDimensionForIndex:BQAnalyticsManagerCustomDimensionDebug] value:@"yes"];
#else
    [[GAI sharedInstance].defaultTracker set:[GAIFields customDimensionForIndex:BQAnalyticsManagerCustomDimensionDebug] value:@"no"];
#endif
}

- (NSString *)getPageName:(BQAnalyticsManagerPage)page {
    switch (page) {
        case BQAnalyticsManagerPageWelcome:
            return @"welcome";
        case BQAnalyticsManagerPageCompliment:
            return @"compliment";
        case BQAnalyticsManagerPageSettings:
            return @"settings";
        case BQAnalyticsManagerPageLicense:
            return @"license";
        default:
            BQAssert(NO, @"Unknown page key. %d", (int)page);
            return @"?";
    }
}

- (NSString *)getSexName:(BQSex)sex {
    switch (sex) {
        case BQSexMale:
            return @"m";
        case BQSexFemale:
            return @"f";
        default:
            BQAssert(NO, @"Unknown sex key. %d", (int)sex);
            return @"?";
    }
}

- (void)onApplicationDidBecomeActiveNotification:(NSNotification *)notification {
    self.appRunCounter++;
}

- (void)onApplicationWillResignActiveNotification:(NSNotification *)notification {
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"BQAnalyticsManager.timeSinceLastRun"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    if (self.complimentsCountInRow > 0) {
        [self trackLeavingComplimentPage];
        self.complimentsCountInRow = 0;
    }
}

- (void)setAppRunCounter:(NSUInteger)appRunCounter {
    _appRunCounter = appRunCounter;

    [[NSUserDefaults standardUserDefaults] setInteger:_appRunCounter forKey:@"BQAnalyticsManager.appRunCounter"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setNotificationsChangesCount:(NSUInteger)notificationsChangesCount {
    _notificationsChangesCount = notificationsChangesCount;

    [[NSUserDefaults standardUserDefaults] setInteger:_notificationsChangesCount forKey:@"BQAnalyticsManager.notificationsChangesCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setSexChangesCount:(NSUInteger)sexChangesCount {
    _sexChangesCount = sexChangesCount;

    [[NSUserDefaults standardUserDefaults] setInteger:_sexChangesCount forKey:@"BQAnalyticsManager.sexChangesCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)trackLeavingComplimentPage {
    [self setCustomDimensions];

    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:@"compliments_page" action:@"leave" label:@"count_in_row" value:@(self.complimentsCountInRow)] build]];
}

#pragma mark NSObject methods

- (id)init {
    self = [super init];
    if (self) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        self.appRunCounter = (NSUInteger)[userDefaults integerForKey:@"BQAnalyticsManager.appRunCounter"];
        self.notificationsChangesCount = (NSUInteger)[userDefaults integerForKey:@"BQAnalyticsManager.notificationsChangesCount"];
        self.sexChangesCount = (NSUInteger)[userDefaults integerForKey:@"BQAnalyticsManager.sexChangesCount"];

        NSDate *lastRunTime = [userDefaults objectForKey:@"BQAnalyticsManager.timeSinceLastRun"];
        if (lastRunTime != nil) {
            self.timeSinceLastRun = [[NSDate date] timeIntervalSinceDate:lastRunTime];
        }

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    }
    return self;
}

#pragma mark Interface methods

+ (instancetype)shareManager {
    static id instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)initializeWithToken:(NSString *)token {
    if (token.length == 0) {
        return;
    }

    GAI *tracker = [GAI sharedInstance];
    tracker.trackUncaughtExceptions = NO;
    tracker.dispatchInterval = BQAnalyticsManagerDispatchInterval;
    tracker.optOut = NO;
    tracker.dryRun = NO;
    tracker.logger.logLevel = kGAILogLevelWarning;
    [tracker trackerWithTrackingId:token];
}

- (void)trackPageView:(BQAnalyticsManagerPage)page {
    if (page == BQAnalyticsManagerPageCompliment) {
        self.complimentsCountInRow = 1;
    }
    else if (self.complimentsCountInRow > 0) {
        [self trackLeavingComplimentPage];
        self.complimentsCountInRow = 0;
    }

    [self setCustomDimensions];

    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:[self getPageName:page]];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)trackNotificationsChangeToValue:(BOOL)value {
    self.notificationsChangesCount++;
    [self setCustomDimensions];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:@"settings" action:@"notifications" label:value ? @"yes" : @"no" value:nil] build]];
}

- (void)trackSexChangeFrom:(BQSex)fromSex to:(BQSex)toSex {
    self.sexChangesCount++;
    [self setCustomDimensions];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:@"settings" action:@"sex" label:[NSString stringWithFormat:@"%@->%@", [self getSexName:fromSex], [self getSexName:toSex]] value:nil] build]];
}

- (void)trackComplimentTap {
    self.complimentsCountInRow++;
    [self setCustomDimensions];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:@"action" action:@"compliment_tap" label:nil value:nil] build]];
}

- (void)trackShareTap {
    self.complimentsCountInRow++;
    [self setCustomDimensions];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:@"action" action:@"share_tap" label:nil value:nil] build]];
}

@end
