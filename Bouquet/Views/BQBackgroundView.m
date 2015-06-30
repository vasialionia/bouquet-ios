//
// Bouquet
//
// Created by drif on 6/30/15.
// Copyright (c) 2015 vasialionia. All rights reserved.
//

#import "BQBackgroundView.h"
#import "UIColor+BQ.h"

@implementation BQBackgroundView

#pragma mark UIView methods

- (void)drawRect:(CGRect)rect {

    [[UIColor bqLightColor] setFill];
    [[UIColor bqLightColor] setStroke];

    UIBezierPath *topRectangle = [UIBezierPath bezierPath];
    [topRectangle moveToPoint:CGPointZero];
    [topRectangle addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds), 0.0f)];
    [topRectangle addLineToPoint:CGPointMake(0.0f, CGRectGetHeight(self.bounds) * 0.9f)];
    [topRectangle closePath];
    [topRectangle fill];
    [topRectangle stroke];

    [[UIColor bqLighterColor] setFill];
    [[UIColor bqLighterColor] setStroke];

    UIBezierPath *bottomRectangle = [UIBezierPath bezierPath];
    [bottomRectangle moveToPoint:CGPointMake(CGRectGetWidth(self.bounds), 0.0f)];
    [bottomRectangle addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    [bottomRectangle addLineToPoint:CGPointMake(0.0f, CGRectGetHeight(self.bounds))];
    [bottomRectangle addLineToPoint:CGPointMake(0.0f, CGRectGetHeight(self.bounds) * 0.9f)];
    [bottomRectangle closePath];
    [bottomRectangle fill];
    [bottomRectangle stroke];
}

@end
