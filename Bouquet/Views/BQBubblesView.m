//
// Bouquet
//
// Created by drif on 7/2/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import "BQBubblesView.h"

@interface BQBubblesView ()

@property (nonatomic, strong) NSMutableArray *bubbles;
@property (nonatomic, assign, readwrite) BOOL isAnimating;

@end

@implementation BQBubblesView

#pragma mark Private methods

- (NSUInteger)ballsCount {
    return (NSUInteger)(self.bounds.size.width * self.bounds.size.height * self.density);
}

- (void)addBubbleWithAnimationAtTop:(BOOL)atTop {
    CGFloat radius = self.minRadius + arc4random() % (int)(self.maxRadius - self.minRadius + 1);
    UIColor *color = self.colors[arc4random() % self.colors.count];
    CGFloat x = arc4random() % (int)self.bounds.size.width - radius;
    CGFloat y = atTop ? -2.0f * radius :  arc4random() % (int)self.bounds.size.height - radius;
    CGFloat speed = self.minSpeed + arc4random() % (int)(self.maxSpeed - self.minSpeed + 1);
    NSTimeInterval duration = (self.bounds.size.height - y) / speed;

    UIView *bubble = [[UIView alloc] init];
    bubble.backgroundColor = color;
    bubble.layer.cornerRadius = radius;

    bubble.translatesAutoresizingMaskIntoConstraints = NO;
    [self insertSubview:bubble atIndex:0];

    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:bubble attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:y / self.bounds.size.height constant:0.0f];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[bubble(width)]" options:(NSLayoutFormatOptions)0 metrics:@{@"width": @(2.0f * radius)} views:NSDictionaryOfVariableBindings(bubble)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bubble(height)]" options:(NSLayoutFormatOptions)0 metrics:@{@"height": @(2.0f * radius)} views:NSDictionaryOfVariableBindings(bubble)]];
    [self addConstraints:@[
            [NSLayoutConstraint constraintWithItem:bubble attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:x / self.bounds.size.width constant:0.0f],
            heightConstraint
    ]];

    __weak BQBubblesView *wself = self;

    [self layoutIfNeeded];
    [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        [wself removeConstraint:heightConstraint];
        [wself addConstraint:[NSLayoutConstraint constraintWithItem:bubble attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
        [wself layoutIfNeeded];
    }
    completion:^(BOOL finished) {
        [wself.bubbles removeObject:bubble];
        [wself addBubbleWithAnimationAtTop:YES];
    }];

    [self.bubbles addObject:bubble];
}

#pragma mark Interface methods

- (void)startAnimation {
    if (self.isAnimating) {
        return;
    }

    BQAssert(self.minRadius > 0.0f, @"minRadius must be greater than 0.");
    BQAssert(self.maxRadius > 0.0f, @"maxRadius must be greater than 0.");
    BQAssert(self.maxRadius >= self.minRadius, @"maxRadius must be greater or equeal to minRadius.");
    BQAssert(self.density > 0.0f, @"density must be greater than 0.");
    BQAssert(self.colors.count > 0, @"color must contain at least on color.");
    BQAssert(self.minSpeed > 0.0f, @"minSpeed must be greater than 0.");
    BQAssert(self.maxSpeed > 0.0f, @"maxSpeed must be greater than 0.");
    BQAssert(self.maxSpeed >= self.minSpeed, @"maxSpeed must be greater or equeal to minSpeed.");
    BQAssert(self.bounds.size.width > 0.0f, @"width must be greater than 0.");
    BQAssert(self.bounds.size.height > 0.0f, @"height must be greater than 0.");

    self.isAnimating = YES;

    if (self.bubbles == nil) {
        self.bubbles = [NSMutableArray arrayWithCapacity:self.ballsCount];
    }

    for (NSUInteger i = 0; i < self.ballsCount; i++) {
        [self addBubbleWithAnimationAtTop:NO];
    }
}

- (void)stopAnimation {
    if (!self.isAnimating) {
        return;
    }

    for (UIView *bubble in self.bubbles) {
        [bubble removeFromSuperview];
    }
    [self.bubbles removeAllObjects];

    self.isAnimating = NO;
}

@end
