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
#import "BQSettingsDataSource.h"

typedef NS_ENUM(NSUInteger, BQSettingsTableSections) {
    BQSettingsTableSectionsSettings,
    BQSettingsTableSectionsLincenses,
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

@implementation BQSettingsViewController

#pragma mark Private methods

- (void)onDoneTap:(id)sender {
    [self.delegate settingsViewControllerDidTapDone:self];
}

- (void)onSegmentedControlValueChanged:(UISegmentedControl *)segmentedControl {
    self.datasource.sex = (BQSex)segmentedControl.selectedSegmentIndex;
}

- (NSString *)getSexTitleForSex:(BQSex)sex {
    switch (sex) {
        case BQSexMale:
            return @"♂";
        case BQSexFemale:
            return @"♀";
        case BQSexOther:
            return @"?";
        default:
            BQAssert(NO, @"Unknown sex key. %d", (int)sex);
            return @"?";
    }
}

#pragma mark NSObject methods

- (id)init
{
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
        self.title = @"Settings";
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
        default:
            BQAssert(NO, @"Invalid section index.");
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case BQSettingsTableSectionsSettings:
            return @"Settings";
        case BQSettingsTableSectionsLincenses:
            return @"3rd party libraries used";
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
                    cell.textLabel.text = @"Sex";

                    [cell.segmentedControl removeAllSegments];
                    NSUInteger indexToInsert = 0;
                    for (BQSex sex = BQSexFirst; sex <= BQSexLast; sex ++) {
                        [cell.segmentedControl insertSegmentWithTitle:[self getSexTitleForSex:sex] atIndex:indexToInsert animated:NO];
                        [cell.segmentedControl setWidth:40.0f forSegmentAtIndex:indexToInsert];
                        indexToInsert ++;
                    }

                    cell.segmentedControl.selectedSegmentIndex = [self.datasource sex];

                    if (![cell.segmentedControl.allTargets containsObject:self]) {
                        [cell.segmentedControl addTarget:self action:@selector(onSegmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
                    }

                    return cell;
                }
                case BQSettingsTableSectionSettingsRowsNotifications: {
                    BQTableViewCellWithSwitch *cell = (BQTableViewCellWithSwitch *)[tableView cellOfClass:[BQTableViewCellWithSwitch class]];
                    cell.textLabel.text = @"Notifications";
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
        default:
            break;
    }
}

@end
