//
// Bouquet
//
// Created by drif on 6/22/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import "BQWelcomeView.h"

@interface BQWelcomeView()

@property (nonatomic, strong, readwrite) UIButton *maleButton;
@property (nonatomic, strong, readwrite) UIButton *femaleButton;
@property (nonatomic, strong, readwrite) UIButton *otherButton;

@end

@implementation BQWelcomeView

#pragma mark Private methods

- (void)initMaleButton {
    self.maleButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.maleButton.backgroundColor = [UIColor blueColor];
    [self.maleButton setTitle:@"Male" forState:UIControlStateNormal];

    self.maleButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.maleButton];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[maleButton(100)]" options:(NSLayoutFormatOptions)0 metrics:nil views:@{@"maleButton": self.maleButton}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[maleButton(40)]" options:(NSLayoutFormatOptions)0 metrics:nil views:@{@"maleButton": self.maleButton}]];
    [self addConstraints:@[
            [NSLayoutConstraint constraintWithItem:self.maleButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:-10.0f],
            [NSLayoutConstraint constraintWithItem:self.maleButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]
    ]];
}

- (void)initFemaleButton {
    self.femaleButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.femaleButton.backgroundColor = [UIColor purpleColor];
    [self.femaleButton setTitle:@"Female" forState:UIControlStateNormal];

    self.femaleButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.femaleButton];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[femaleButton(100)]" options:(NSLayoutFormatOptions)0 metrics:nil views:@{@"femaleButton": self.femaleButton}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[femaleButton(40)]" options:(NSLayoutFormatOptions)0 metrics:nil views:@{@"femaleButton": self.femaleButton}]];
    [self addConstraints:@[
            [NSLayoutConstraint constraintWithItem:self.femaleButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:10.0f],
            [NSLayoutConstraint constraintWithItem:self.femaleButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]
    ]];
}

- (void)initOtherButton {
    self.otherButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.otherButton.backgroundColor = [UIColor orangeColor];
    [self.otherButton setTitle:@"It's a secret" forState:UIControlStateNormal];

    self.otherButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.otherButton];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[otherButton(150)]" options:(NSLayoutFormatOptions)0 metrics:nil views:@{@"otherButton": self.otherButton}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[otherButton(40)]-20-|" options:(NSLayoutFormatOptions)0 metrics:nil views:@{@"otherButton": self.otherButton}]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.otherButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
}

#pragma mark UIView methods

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];

        [self initMaleButton];
        [self initFemaleButton];
        [self initOtherButton];
    }
    return self;
}

@end
