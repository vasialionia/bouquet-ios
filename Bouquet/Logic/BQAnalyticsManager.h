//
// Bouquet
//
// Created by drif on 7/3/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BQSex.h"

@protocol BQSettingsDatasource;
@protocol BQNotificationsDataSource;

typedef NS_ENUM(NSUInteger, BQAnalyticsManagerPage) {
    BQAnalyticsManagerPageWelcome,
    BQAnalyticsManagerPageCompliment,
    BQAnalyticsManagerPageSettings,
    BQAnalyticsManagerPageLicense
};

@interface BQAnalyticsManager : NSObject

@property (nonatomic, weak) id<BQSettingsDatasource> settingsDatasource;
@property (nonatomic, weak) id<BQNotificationsDataSource> notificationsDatasource;

+ (instancetype)shareManager;
- (void)initializeWithToken:(NSString *)token;

- (void)trackPageView:(BQAnalyticsManagerPage)page;
- (void)trackNotificationsChangeToValue:(BOOL)value;
- (void)trackSexChangeFrom:(BQSex)fromSex to:(BQSex)toSex;
- (void)trackComplimentTap;
- (void)trackShareTap;

@end
