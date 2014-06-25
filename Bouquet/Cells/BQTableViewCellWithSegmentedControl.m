//
// Bouquet
//
// Created by drif on 6/25/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import "BQTableViewCellWithSegmentedControl.h"

@interface BQTableViewCellWithSegmentedControl ()

@property (nonatomic, strong, readwrite) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UILabel *cellTextLabel;

@end

@implementation BQTableViewCellWithSegmentedControl

#pragma mark Private methods

- (void)initSegmentedControl {
    self.segmentedControl = [[UISegmentedControl alloc] init];

    self.segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.segmentedControl];

    [self.segmentedControl setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.segmentedControl setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[segmentedControl]-15-|" options:(NSLayoutFormatOptions)0 metrics:nil views:@{@"segmentedControl": self.segmentedControl}]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentedControl attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
}

- (void)initCellTitleLabel {
    self.cellTextLabel = [[UILabel alloc] init];

    self.cellTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.cellTextLabel];

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[cellTextLabel][segmentedControl]" options:(NSLayoutFormatOptions)0 metrics:nil views:@{@"cellTextLabel": self.cellTextLabel, @"segmentedControl": self.segmentedControl}]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.cellTextLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
}

#pragma mark UITableViewCell methods

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSegmentedControl];
        [self initCellTitleLabel];
    }
    return self;
}

- (UILabel *)textLabel {
    return self.cellTextLabel;
}

@end
