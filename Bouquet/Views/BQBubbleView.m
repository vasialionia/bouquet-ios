//
// Bouquet
//
// Created by drif on 7/1/15.
// Copyright (c) 2015 vasialionia. All rights reserved.
//

#import "BQBubbleView.h"

@interface BQBubbleView ()

@property (nonatomic, strong) UIColor *fillColor;

@end

@implementation BQBubbleView

#pragma mark NSObject methods

- (id)init {
    self = [super init];
    if (self) {
        self.fillColor = [UIColor blackColor];
        self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

#pragma mark UIView methods

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:[UIColor clearColor]];
    self.fillColor = backgroundColor;
}

- (UIColor *)backgroundColor {
    return self.fillColor;
}

- (void)drawRect:(CGRect)rect {
    if (CGRectGetWidth(self.bounds) < 50.0f || CGRectGetHeight(self.bounds) < 70.0f) {
        return;
    }

    CGFloat tailHeight = 30.0f;
    CGRect bodyRect = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - tailHeight);

    UIBezierPath *bodyPath = [UIBezierPath bezierPathWithRoundedRect:bodyRect cornerRadius:15.0f];
    [self.fillColor setFill];
    [bodyPath fill];

    CGFloat controlPointX = CGRectGetWidth(bodyRect) - 50.0f;
    CGFloat controlPointY = CGRectGetHeight(bodyRect);

    UIBezierPath *tailPath = UIBezierPath.bezierPath;
    [tailPath moveToPoint: CGPointMake(controlPointX + 16.0f, controlPointY + 10.0f)];
    [tailPath addCurveToPoint: CGPointMake(controlPointX + 28.0f, controlPointY + 25.0f) controlPoint1: CGPointMake(controlPointX + 24.0f, controlPointY + 18.0f) controlPoint2: CGPointMake(controlPointX + 28.0f, controlPointY + 25.0f)];
    [tailPath addLineToPoint: CGPointMake(controlPointX + 26.0f, controlPointY)];
    [tailPath addLineToPoint: CGPointMake(controlPointX, controlPointY)];
    [tailPath addCurveToPoint: CGPointMake(controlPointX + 16.0f, controlPointY + 10.0f) controlPoint1: CGPointMake(controlPointX, controlPointY) controlPoint2: CGPointMake(controlPointX + 8.0f, controlPointY + 2.0f)];
    [tailPath closePath];
    [self.fillColor setFill];
    [tailPath fill];
}

@end
