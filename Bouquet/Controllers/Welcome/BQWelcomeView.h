//
// Bouquet
//
// Created by drif on 6/22/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BQInfiniteButton;

@interface BQWelcomeView : UIView

@property (nonatomic, strong, readonly) BQInfiniteButton *maleButton;
@property (nonatomic, strong, readonly) BQInfiniteButton *femaleButton;
@property (nonatomic, strong, readonly) UIButton *otherButton;

@end
