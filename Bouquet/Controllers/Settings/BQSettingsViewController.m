//
// Bouquet
//
// Created by drif on 6/25/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import "BQSettingsViewController.h"
#import "BQTableViewCellWithSwitch.h"
#import "UITableView+BQ.h"
#import "BQTableViewCellWithSegmentedControl.h"
#import "BQSettingsDatasource.h"
#import "BQNotificationsDataSource.h"

typedef NS_ENUM(NSUInteger, BQSettingsTableSections) {
    BQSettingsTableSectionsSettings,
    BQSettingsTableSectionsLincenses,
    BQSettingsTableSectionsSourceCode,
    BQSettingsTableSectionsCount
};

typedef NS_ENUM(NSUInteger, BQSettingsTableSectionSettingsRows) {
    BQSettingsTableSectionSettingsRowsSex,
    BQSettingsTableSectionSettingsRowsNotifications,
    BQSettingsTableSectionSettingsRowsCount
};

typedef NS_ENUM(NSUInteger, BQSettingsTableSectionLincensesRows) {
    BQSettingsTableSectionLincensesRowsRestKit,
    BQSettingsTableSectionLincensesRowsCount
};

typedef NS_ENUM(NSUInteger, BQSettingsTableSectionSourceCodeRows) {
    BQSettingsTableSectionSourceCodeRowsIOS,
    BQSettingsTableSectionSourceCodeRowsServer,
    BQSettingsTableSectionSourceCodeRowsCount
};

@implementation BQSettingsViewController

#pragma mark Private methods

- (void)onDoneTap:(id)sender {
    [self.delegate settingsViewControllerDidTapDone:self];
}

- (void)onSegmentedControlValueChanged:(UISegmentedControl *)segmentedControl {
    BQSex oldValue = self.settingsDatasource.sex;
    self.settingsDatasource.sex = (BQSex)segmentedControl.selectedSegmentIndex;

    if ([self.delegate respondsToSelector:@selector(settingsViewController:didChangeSexFrom:to:)]) {
        [self.delegate settingsViewController:self didChangeSexFrom:oldValue to:self.settingsDatasource.sex];
    }
}

- (void)onSwitchControlValueChanged:(UISwitch *)switchControl {
    if (switchControl.on && !self.notificationsDatasource.canEnableNotifications) {
        [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Enable notifications for the app in the device settings", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        [switchControl setOn:NO animated:YES];
    }
    else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self.notificationsDatasource setNotificationsEnabled:switchControl.on];
        });
    }

    if ([self.delegate respondsToSelector:@selector(settingsViewController:didChangeNotificationsSettingsToValue:)]) {
        [self.delegate settingsViewController:self didChangeNotificationsSettingsToValue:self.notificationsDatasource.isNotificationsEnabled];
    }
}

- (NSString *)getSexTitleForSex:(BQSex)sex {
    switch (sex) {
        case BQSexMale:
            return @"♂";
        case BQSexFemale:
            return @"♀";
        default:
            BQAssert(NO, @"Unknown sex key. %d", (int)sex);
            return @"?";
    }
}

#pragma mark NSObject methods

- (id)init {
    return [self initWithStyle:UITableViewStyleGrouped];
}

#pragma mark UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDoneTap:)];
}

#pragma mark UITableViewController methods

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.title = NSLocalizedString(@"Settings", nil);
    }
    return self;
}

#pragma mark UITableViewDataSource protocol

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return BQSettingsTableSectionsCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch(section) {
        case BQSettingsTableSectionsSettings:
            return BQSettingsTableSectionSettingsRowsCount;
        case BQSettingsTableSectionsLincenses:
            return BQSettingsTableSectionLincensesRowsCount;
        case BQSettingsTableSectionsSourceCode:
            return BQSettingsTableSectionSourceCodeRowsCount;
        default:
            BQAssert(NO, @"Invalid section index.");
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case BQSettingsTableSectionsSettings:
            return NSLocalizedString(@"Settings", nil);
        case BQSettingsTableSectionsLincenses:
            return NSLocalizedString(@"3rd party libraries used", nil);
        case BQSettingsTableSectionsSourceCode:
            return NSLocalizedString(@"Source code", nil);
        default:
            BQAssert(NO, @"Invalid section index.");
            return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch(indexPath.section) {
        case BQSettingsTableSectionsSettings:
            switch(indexPath.row) {
                case BQSettingsTableSectionSettingsRowsSex: {
                    BQTableViewCellWithSegmentedControl *cell = (BQTableViewCellWithSegmentedControl *)[tableView cellOfClass:[BQTableViewCellWithSegmentedControl class]];
                    cell.textLabel.text = NSLocalizedString(@"Sex", nil);

                    [cell.segmentedControl removeAllSegments];
                    NSUInteger indexToInsert = 0;
                    for (BQSex sex = BQSexFirst; sex <= BQSexLast; sex ++) {
                        [cell.segmentedControl insertSegmentWithTitle:[self getSexTitleForSex:sex] atIndex:indexToInsert animated:NO];
                        [cell.segmentedControl setWidth:40.0f forSegmentAtIndex:indexToInsert];
                        indexToInsert ++;
                    }

                    cell.segmentedControl.selectedSegmentIndex = [self.settingsDatasource sex];

                    if (![cell.segmentedControl.allTargets containsObject:self]) {
                        [cell.segmentedControl addTarget:self action:@selector(onSegmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
                    }

                    return cell;
                }
                case BQSettingsTableSectionSettingsRowsNotifications: {
                    BQTableViewCellWithSwitch *cell = (BQTableViewCellWithSwitch *)[tableView cellOfClass:[BQTableViewCellWithSwitch class]];
                    cell.textLabel.text = NSLocalizedString(@"Notifications", nil);

                    cell.switchControl.on = [self.notificationsDatasource isNotificationsEnabled];
                    if (![cell.switchControl.allTargets containsObject:self]) {
                        [cell.switchControl addTarget:self action:@selector(onSwitchControlValueChanged:) forControlEvents:UIControlEventValueChanged];
                    }

                    return cell;
                }
                default:
                    BQAssert(NO, @"Invalid row index.");
                    return [[UITableViewCell alloc] init];
            }
        case BQSettingsTableSectionsLincenses:
            switch(indexPath.row) {
                case BQSettingsTableSectionLincensesRowsRestKit: {
                    UITableViewCell *cell = [tableView cellOfClass:[UITableViewCell class]];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.textLabel.text = @"RestKit";
                    return cell;
                }
                default:
                    BQAssert(NO, @"Invalid row index.");
                    return [[UITableViewCell alloc] init];
            }
        case BQSettingsTableSectionsSourceCode:
            switch(indexPath.row) {
                case BQSettingsTableSectionSourceCodeRowsIOS: {
                    UITableViewCell *cell = [tableView cellOfClass:[UITableViewCell class]];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.textLabel.text = NSLocalizedString(@"iOS application", nil);
                    return cell;
                }
                case BQSettingsTableSectionSourceCodeRowsServer: {
                    UITableViewCell *cell = [tableView cellOfClass:[UITableViewCell class]];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.textLabel.text = NSLocalizedString(@"Web-server", nil);
                    return cell;
                }
                default:
                    BQAssert(NO, @"Invalid row index.");
                    return [[UITableViewCell alloc] init];
            }
        default:
            BQAssert(NO, @"Invalid section index.");
            return [[UITableViewCell alloc] init];
    }
}

#pragma mark UITableViewDelegate protocol

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch(indexPath.section) {
        case BQSettingsTableSectionsLincenses:
            switch(indexPath.row) {
                case BQSettingsTableSectionLincensesRowsRestKit:
                    [self.delegate settingsViewController:self didSelectLibrary:BQSettingsViewControllerLibraryRestKit];
                    break;
                default:
                    break;
            }
            break;
        case BQSettingsTableSectionsSourceCode:
            switch(indexPath.row) {
                case BQSettingsTableSectionSourceCodeRowsIOS:
                    [self.delegate settingsViewController:self didSelectSourceCode:BQSettingsViewControllerSourceCodeIOS];
                    break;
                case BQSettingsTableSectionSourceCodeRowsServer:
                    [self.delegate settingsViewController:self didSelectSourceCode:BQSettingsViewControllerSourceCodeServer];
                    break;
                default:
                    break;
            }
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
        default:
            break;
    }
}

@end
