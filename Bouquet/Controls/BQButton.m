//
// Bouquet
//
// Created by drif on 7/13/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import "BQButton.h"

@implementation BQButton

#pragma mark UIView methods

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect insetRect = UIEdgeInsetsInsetRect(self.bounds, self.tapEdgeInsets);
    return CGRectContainsPoint(insetRect, point) ? self : nil;
}

@end
