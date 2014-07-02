//
// Bouquet
//
// Created by drif on 6/22/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import "BQWelcomeView.h"
#import "BQInfiniteButton.h"
#import "BQInfiniteView.h"

@interface BQWelcomeView ()

@property (nonatomic, strong, readwrite) BQInfiniteButton *maleButton;
@property (nonatomic, strong, readwrite) BQInfiniteButton *femaleButton;
@property (nonatomic, strong, readwrite) UIButton *otherButton;

@end

@implementation BQWelcomeView

#pragma mark Private methods

- (void)initMaleButton {
    self.maleButton = [[BQInfiniteButton alloc] initWithFrame:CGRectZero];
    self.maleButton.backgroundColor = [UIColor clearColor];
    self.maleButton.infiniteView.image = [UIImage imageNamed:@"infinite_male.png"];
    self.maleButton.layer.masksToBounds = YES;
    self.maleButton.layer.cornerRadius = 6.0f;
    self.maleButton.layer.borderWidth = 2.0f;
    self.maleButton.layer.borderColor = [[UIColor colorWithRed:0.0f green:198.0f / 255.0f blue:245.0f / 255.0f alpha:1.0f] CGColor];
    self.maleButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f];
    self.maleButton.titleLabel.numberOfLines = 0;
    self.maleButton.titleLabel.textAlignment = NSTextAlignmentCenter;

    NSString *maleString = [NSString stringWithFormat:@"♂\n%@", NSLocalizedString(@"MALE", nil)];
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:maleString];
    [titleString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.0f green:198.0f / 255.0f blue:245.0f / 255.0f alpha:1.0f] range:NSMakeRange(0, maleString.length)];
    [titleString addAttribute:NSFontAttributeName value:[UIFont fontWithName:self.maleButton.titleLabel.font.fontName size:40.0f] range:NSMakeRange(0, 1)];
    [self.maleButton setAttributedTitle:titleString forState:UIControlStateNormal];

    self.maleButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.maleButton];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[maleButton(130)]" options:(NSLayoutFormatOptions)0 metrics:nil views:@{@"maleButton": self.maleButton}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[maleButton(70)]" options:(NSLayoutFormatOptions)0 metrics:nil views:@{@"maleButton": self.maleButton}]];
    [self addConstraints:@[
            [NSLayoutConstraint constraintWithItem:self.maleButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:-10.0f],
            [NSLayoutConstraint constraintWithItem:self.maleButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]
    ]];
}

- (void)initFemaleButton {
    self.femaleButton = [[BQInfiniteButton alloc] initWithFrame:CGRectZero];
    self.femaleButton.backgroundColor = [UIColor clearColor];
    self.femaleButton.infiniteView.image = [UIImage imageNamed:@"infinite_female.png"];
    self.femaleButton.layer.masksToBounds = YES;
    self.femaleButton.layer.cornerRadius = 6.0f;
    self.femaleButton.layer.borderWidth = 2.0f;
    self.femaleButton.layer.borderColor = [[UIColor colorWithRed:225.0f / 255.0f green:0.0f blue:124.0f / 255.0f alpha:1.0f] CGColor];
    self.femaleButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f];
    self.femaleButton.titleLabel.numberOfLines = 0;
    self.femaleButton.titleLabel.textAlignment = NSTextAlignmentCenter;

    NSString *femaleString = [NSString stringWithFormat:@"♀\n%@", NSLocalizedString(@"FEMALE", nil)];
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:femaleString];
    [titleString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:225.0f / 255.0f green:0.0f blue:124.0f / 255.0f alpha:1.0f] range:NSMakeRange(0, femaleString.length)];
    [titleString addAttribute:NSFontAttributeName value:[UIFont fontWithName:self.femaleButton.titleLabel.font.fontName size:40.0f] range:NSMakeRange(0, 1)];
    [self.femaleButton setAttributedTitle:titleString forState:UIControlStateNormal];

    self.femaleButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.femaleButton];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[femaleButton(130)]" options:(NSLayoutFormatOptions)0 metrics:nil views:@{@"femaleButton": self.femaleButton}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[femaleButton(70)]" options:(NSLayoutFormatOptions)0 metrics:nil views:@{@"femaleButton": self.femaleButton}]];
    [self addConstraints:@[
            [NSLayoutConstraint constraintWithItem:self.femaleButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:10.0f],
            [NSLayoutConstraint constraintWithItem:self.femaleButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]
    ]];
}

- (void)initOtherButton {
    self.otherButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.otherButton.backgroundColor = [UIColor clearColor];
    self.otherButton.layer.cornerRadius = 6.0f;
    self.otherButton.layer.borderWidth = 1.0f;
    self.otherButton.layer.borderColor = [[UIColor grayColor]CGColor];
    self.otherButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10.0f];

    [self.otherButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.otherButton setTitle:NSLocalizedString(@"IT'S A SECRET :-)", nil) forState:UIControlStateNormal];

    self.otherButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.otherButton];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[otherButton(150)]" options:(NSLayoutFormatOptions)0 metrics:nil views:@{@"otherButton": self.otherButton}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[otherButton(40)]-20-|" options:(NSLayoutFormatOptions)0 metrics:nil views:@{@"otherButton": self.otherButton}]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.otherButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
}

#pragma mark UIView methods

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        [self initMaleButton];
        [self initFemaleButton];
        [self initOtherButton];
    }
    return self;
}

@end
