//
// Bouquet
//
// Created by drif on 6/25/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BQSettingsViewControllerLibrary) {
    BQSettingsViewControllerLibraryRestKit
};

@protocol BQSettingsViewControllerDelegate;
@protocol BQSettingsDataSource;

@interface BQSettingsViewController : UITableViewController

@property (nonatomic, weak) id<BQSettingsViewControllerDelegate> delegate;
@property (nonatomic, strong) id<BQSettingsDataSource> datasource;

@end

@protocol BQSettingsViewControllerDelegate

@required

- (void)settingsViewControllerDidTapDone:(BQSettingsViewController *)settingsViewController;
- (void)settingsViewController:(BQSettingsViewController *)settingsViewController didSelectLibrary:(BQSettingsViewControllerLibrary)library;

@end
