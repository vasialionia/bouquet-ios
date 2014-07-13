//
// Bouquet
//
// Created by drif on 6/22/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import "BQComplimentView.h"
#import "BQButton.h"

@interface BQComplimentView ()

@property (nonatomic, strong, readwrite) UILabel *complimentLabel;
@property (nonatomic, strong, readwrite) BQButton *infoButton;
@property (nonatomic, strong, readwrite) BQButton *shareButton;

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

- (void)initInfoButton {
    self.infoButton = [[BQButton alloc] initWithFrame:CGRectZero];
    self.infoButton.tapEdgeInsets = UIEdgeInsetsMake(-20.0f, -20.0f, -20.0f, -20.0f);
    self.infoButton.backgroundColor = [UIColor clearColor];
    self.infoButton.layer.cornerRadius = 15.0f;
    self.infoButton.layer.borderWidth = 1.0f;
    self.infoButton.layer.borderColor = [[UIColor blackColor] CGColor];
    [self.infoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.infoButton setTitle:@"i" forState:UIControlStateNormal];

    self.infoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.infoButton];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[infoButton(30)]-10-|" options:(NSLayoutFormatOptions)0 metrics:nil views:@{@"infoButton": self.infoButton}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[infoButton(30)]" options:(NSLayoutFormatOptions)0 metrics:nil views:@{@"infoButton": self.infoButton}]];
}

- (void)initShareButton {
    self.shareButton = [[BQButton alloc] initWithFrame:CGRectZero];
    self.shareButton.tapEdgeInsets = UIEdgeInsetsMake(-20.0f, -20.0f, -20.0f, -20.0f);
    self.shareButton.backgroundColor = [UIColor clearColor];
    self.shareButton.layer.cornerRadius = 15.0f;
    self.shareButton.layer.borderWidth = 1.0f;
    self.shareButton.layer.borderColor = [[UIColor blackColor] CGColor];
    self.shareButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 1.0f, 1.0f, 0.0f);
    [self.shareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.shareButton setTitle:@"⏏" forState:UIControlStateNormal];

    self.shareButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.shareButton];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[shareButton(30)]-10-|" options:(NSLayoutFormatOptions)0 metrics:nil views:@{@"shareButton": self.shareButton}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[shareButton(30)]-10-|" options:(NSLayoutFormatOptions)0 metrics:nil views:@{@"shareButton": self.shareButton}]];
}

#pragma mark UIView methods

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        self.minRadius = 60.0f;
        self.maxRadius = 150.0f;
        self.density = 0.00007f;
        self.minSpeed = 4.0f;
        self.maxSpeed = 8.0f;

        self.colors = @[
                [UIColor colorWithRed:184.0f / 255.0f green:164.0f / 255.0f blue:233.0f / 255.0f alpha:1.0f],
                [UIColor colorWithRed:153.0f / 255.0f green:233.0f / 255.0f blue:255.0f / 255.0f alpha:1.0f],
                [UIColor colorWithRed:92.0f / 255.0f green:220.0f / 255.0f blue:254.0f / 255.0f alpha:1.0f],
                [UIColor colorWithRed:110.0f / 255.0f green:178.0f / 255.0f blue:241.0f / 255.0f alpha:1.0f],
                [UIColor colorWithRed:255.0f / 255.0f green:179.0f / 255.0f blue:233.0f / 255.0f alpha:1.0f],
                [UIColor colorWithRed:153.0f / 255.0f green:188.0f / 255.0f blue:241.0f / 255.0f alpha:1.0f],
                [UIColor colorWithRed:153.0f / 255.0f green:141.0f / 255.0f blue:228.0f / 255.0f alpha:1.0f],
                [UIColor colorWithRed:38.0f / 255.0f green:222.0f / 255.0f blue:158.0f / 255.0f alpha:1.0f],
                [UIColor colorWithRed:64.0f / 255.0f green:236.0f / 255.0f blue:95.0f / 255.0f alpha:1.0f],
                [UIColor colorWithRed:38.0f / 255.0f green:233.0f / 255.0f blue:62.0f / 255.0f alpha:1.0f],
                [UIColor colorWithRed:64.0f / 255.0f green:255.0f / 255.0f blue:101.0f / 255.0f alpha:1.0f],
                [UIColor colorWithRed:179.0f / 255.0f green:102.0f / 255.0f blue:150.0f / 255.0f alpha:1.0f],
                [UIColor colorWithRed:107.0f / 255.0f green:141.0f / 255.0f blue:191.0f / 255.0f alpha:1.0f],
                [UIColor colorWithRed:255.0f / 255.0f green:102.0f / 255.0f blue:112.0f / 255.0f alpha:1.0f]
        ];

        [self initComplimentLabel];
        [self initInfoButton];
        [self initShareButton];
    }
    return self;
}

@end
