//
// Bouquet
//
// Created by drif on 7/2/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import "BQInfiniteView.h"

@interface BQInfiniteView ()

@property (nonatomic, assign) CGFloat animationSpeed;

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) NSLayoutConstraint *leftImageViewRightConstraint;

@end

@implementation BQInfiniteView

#pragma mark Private methods

- (void)initLeftImageView {
    self.leftImageView = [[UIImageView alloc] init];
    self.leftImageView.contentMode = UIViewContentModeScaleToFill;

    self.leftImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.leftImageView];

    self.leftImageViewRightConstraint = [NSLayoutConstraint constraintWithItem:self.leftImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[leftImageView]|" options:(NSLayoutFormatOptions)0 metrics:nil views:@{@"leftImageView": self.leftImageView}]];
    [self addConstraints:@[
            [NSLayoutConstraint constraintWithItem:self.leftImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f],
            self.leftImageViewRightConstraint
    ]];
}

- (void)initRightImageView {
    self.rightImageView = [[UIImageView alloc] init];
    self.rightImageView.contentMode = UIViewContentModeScaleToFill;

    self.rightImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.rightImageView];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[rightImageView]|" options:(NSLayoutFormatOptions)0 metrics:nil views:@{@"rightImageView": self.rightImageView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[leftImageView][rightImageView]" options:(NSLayoutFormatOptions)0 metrics:nil views:@{@"leftImageView": self.leftImageView, @"rightImageView": self.rightImageView}]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rightImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.leftImageView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f]];
}

- (void)startAnimation {
    __weak BQInfiniteView *wself = self;

    [self layoutIfNeeded];
    [UIView animateWithDuration:self.bounds.size.width / self.animationSpeed delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        [wself removeConstraint:wself.leftImageViewRightConstraint];
        wself.leftImageViewRightConstraint = [NSLayoutConstraint constraintWithItem:wself.leftImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:wself attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
        [wself addConstraint:wself.leftImageViewRightConstraint];

        [wself layoutIfNeeded];
    }
    completion:^(BOOL finished) {
        [wself removeConstraint:wself.leftImageViewRightConstraint];
        if (wself) {
            wself.leftImageViewRightConstraint = [NSLayoutConstraint constraintWithItem:wself.leftImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:wself attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f];
        }
        [wself addConstraint:wself.leftImageViewRightConstraint];

        [wself startAnimation];
    }];
}

#pragma mark Interface methods

- (id)initWithAnimationSpeed:(CGFloat)animationSpeed {
    BQAssert(animationSpeed > 0.0f, @"animationSpeed must be greater than zero.");

    self = [super init];
    if(self) {
        self.animationSpeed = animationSpeed;

        [self initLeftImageView];
        [self initRightImageView];

        [self startAnimation];
    }
    return self;
}

- (UIImage *)image {
    return self.leftImageView.image;
}

- (void)setImage:(UIImage *)image {
    self.leftImageView.image = image;
    self.rightImageView.image = image;
}

@end
