//
// Bouquet
//
// Created by drif on 6/22/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import "BQComplimentView.h"

@interface BQComplimentView ()

@property (nonatomic, strong, readwrite) UILabel *complimentLabel;

@end

@implementation BQComplimentView

#pragma mark Private methods

- (void)initComplimentLabel {
    self.complimentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.complimentLabel.numberOfLines = 0;
    self.complimentLabel.textAlignment = NSTextAlignmentCenter;
    self.complimentLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0f];

    self.complimentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.complimentLabel];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[complimentLabel]-20-|" options:(NSLayoutFormatOptions)0 metrics:nil views:@{@"complimentLabel": self.complimentLabel}]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.complimentLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
}

#pragma mark UIView methods

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initComplimentLabel];
    }
    return self;
}

@end
