//
// Bouquet
//
// Created by drif on 7/2/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import "BQInfiniteButton.h"
#import "BQInfiniteView.h"

@interface BQInfiniteButton ()

@property (nonatomic, strong, readwrite) BQInfiniteView *infiniteView;

@end

@implementation BQInfiniteButton

#pragma mark Private methods

- (void)initInfiniteView {
    self.infiniteView = [[BQInfiniteView alloc] initWithAnimationSpeed:5.0f];
    self.infiniteView.userInteractionEnabled = NO;

    self.infiniteView.translatesAutoresizingMaskIntoConstraints = NO;
    [self insertSubview:self.infiniteView belowSubview:self.titleLabel];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[infiniteView]|" options:(NSLayoutFormatOptions)0 metrics:nil views:@{@"infiniteView": self.infiniteView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[infiniteView]|" options:(NSLayoutFormatOptions)0 metrics:nil views:@{@"infiniteView": self.infiniteView}]];
}

#pragma mark UIView methods

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initInfiniteView];
    }
    return self;
}

@end
