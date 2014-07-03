//
// Bouquet
//
// Created by drif on 6/25/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BQSex.h"

typedef NS_ENUM(NSUInteger, BQSettingsViewControllerLibrary) {
    BQSettingsViewControllerLibraryRestKit
};

@protocol BQSettingsViewControllerDelegate;
@protocol BQSettingsDatasource;
@protocol BQNotificationsDataSource;

@interface BQSettingsViewController : UITableViewController

@property (nonatomic, weak) id<BQSettingsViewControllerDelegate> delegate;
@property (nonatomic, strong) id<BQSettingsDatasource> settingsDatasource;
@property (nonatomic, strong) id<BQNotificationsDataSource> notificationsDatasource;

@end

@protocol BQSettingsViewControllerDelegate <NSObject>

@required

- (void)settingsViewControllerDidTapDone:(BQSettingsViewController *)settingsViewController;
- (void)settingsViewController:(BQSettingsViewController *)settingsViewController didSelectLibrary:(BQSettingsViewControllerLibrary)library;

@optional

- (void)settingsViewController:(BQSettingsViewController *)settingsViewController didChangeNotificationsSettingsToValue:(BOOL)value;
- (void)settingsViewController:(BQSettingsViewController *)settingsViewController didChangeSexFrom:(BQSex)fromSex to:(BQSex)toSex;

@end
