//
// Bouquet
//
// Created by drif on 6/22/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import "BQWelcomeView.h"
#import "UIFont+BQ.h"

@interface BQWelcomeView ()

@property (nonatomic, strong, readwrite) UIButton *maleButton;
@property (nonatomic, strong, readwrite) UIButton *femaleButton;

@property (nonatomic, strong) UILabel *topHelpLabel;
@property (nonatomic, strong) UILabel *bottomHelpLabel;

@end

@implementation BQWelcomeView

#pragma mark Private methods

- (void)initMaleButton {
    self.maleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.maleButton setImage:[UIImage imageNamed:@"Boy"] forState:UIControlStateNormal];

    self.maleButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.maleButton];

    [self addConstraints:@[
            [NSLayoutConstraint constraintWithItem:self.maleButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:0.85f constant:0.0f],
            [NSLayoutConstraint constraintWithItem:self.maleButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:0.9f constant:0.0f]
    ]];
}

- (void)initFemaleButton {
    self.femaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.femaleButton setImage:[UIImage imageNamed:@"Girl"] forState:UIControlStateNormal];

    self.femaleButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.femaleButton];

    [self addConstraints:@[
            [NSLayoutConstraint constraintWithItem:self.femaleButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.15f constant:0.0f],
            [NSLayoutConstraint constraintWithItem:self.femaleButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.maleButton attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]
    ]];
}

- (void)initTopHelpLabel {
    self.topHelpLabel = [[UILabel alloc] init];
    self.topHelpLabel.text = NSLocalizedString(@"Choose your gender", nil);
    self.topHelpLabel.font = [UIFont bqLightFontOfSize:18.0f];
    self.topHelpLabel.textAlignment = NSTextAlignmentCenter;

    self.topHelpLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.topHelpLabel];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_topHelpLabel]-20-|" options:(NSLayoutFormatOptions)0 metrics:nil views:NSDictionaryOfVariableBindings(_topHelpLabel)]];
    [self addConstraints:@[
            [NSLayoutConstraint constraintWithItem:self.topHelpLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:40.0f]
    ]];
}

- (void)initBottomHelpLabel {
    self.bottomHelpLabel = [[UILabel alloc] init];
    self.bottomHelpLabel.text = NSLocalizedString(@"Help us customize content", nil);
    self.bottomHelpLabel.font = [UIFont bqLightFontOfSize:18.0f];
    self.bottomHelpLabel.textAlignment = NSTextAlignmentCenter;
    self.bottomHelpLabel.numberOfLines = 0;

    self.bottomHelpLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.bottomHelpLabel];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_bottomHelpLabel]-20-|" options:(NSLayoutFormatOptions)0 metrics:nil views:NSDictionaryOfVariableBindings(_bottomHelpLabel)]];
    [self addConstraints:@[
            [NSLayoutConstraint constraintWithItem:self.bottomHelpLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-20.0f]
    ]];
}

#pragma mark UIView methods

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initMaleButton];
        [self initFemaleButton];

        [self initTopHelpLabel];
        [self initBottomHelpLabel];
    }
    return self;
}

@end
