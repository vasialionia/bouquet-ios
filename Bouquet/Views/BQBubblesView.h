//
// Bouquet
//
// Created by drif on 7/2/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BQBluredView.h"

@interface BQBubblesView : BQBluredView

@property (nonatomic, assign) CGFloat minRadius;
@property (nonatomic, assign) CGFloat maxRadius;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, assign) CGFloat density;
@property (nonatomic, assign) CGFloat minSpeed;
@property (nonatomic, assign) CGFloat maxSpeed;

@property (nonatomic, assign, readonly) BOOL isAnimating;

- (void)startAnimation;
- (void)stopAnimation;

@end
