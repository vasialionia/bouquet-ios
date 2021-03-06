//
// Bouquet
//
// Created by drif on 6/22/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import "BQComplimentView.h"
#import "BQBubbleView.h"
#import "UIColor+BQ.h"

@interface BQComplimentView ()

@property (nonatomic, strong) BQBubbleView *complimentBubble;
@property (nonatomic, strong, readwrite) BQLabel *complimentLabel;
@property (nonatomic, strong, readwrite) UIImageView *friendImageView;

@end

@implementation BQComplimentView

#pragma mark Private methods

- (void)initComplimentBubble {
    self.complimentBubble = [[BQBubbleView alloc] init];
    self.complimentBubble.backgroundColor = [UIColor bqMainColor];

    self.complimentBubble.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.complimentBubble];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=15)-[complimentBubble]-15-|" options:(NSLayoutFormatOptions)0 metrics:nil views:@{@"complimentBubble": self.complimentBubble}]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.complimentBubble attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.3f constant:0.0f]];
}

- (void)initComplimentLabel {
    self.complimentLabel = [[BQLabel alloc] init];
    self.complimentLabel.numberOfLines = 0;
    self.complimentLabel.textAlignment = NSTextAlignmentCenter;
    self.complimentLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0f];

    self.complimentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.complimentBubble addSubview:self.complimentLabel];

    [self.complimentBubble addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[complimentLabel]-15-|" options:(NSLayoutFormatOptions)0 metrics:nil views:@{@"complimentLabel": self.complimentLabel}]];
    [self.complimentBubble addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[complimentLabel]-45-|" options:(NSLayoutFormatOptions)0 metrics:nil views:@{@"complimentLabel": self.complimentLabel}]];
}

- (void)initFriendImageView {
    self.friendImageView = [[UIImageView alloc] init];

    self.friendImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.friendImageView];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[friendImageView]|" options:(NSLayoutFormatOptions)0 metrics:nil views:@{@"friendImageView": self.friendImageView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[friendImageView]|" options:(NSLayoutFormatOptions)0 metrics:nil views:@{@"friendImageView": self.friendImageView}]];
}

#pragma mark UIView methods

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initComplimentBubble];
        [self initComplimentLabel];
        [self initFriendImageView];
    }
    return self;
}

@end
