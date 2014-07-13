//
// Bouquet
//
// Created by drif on 6/22/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BQBubblesView.h"

@class BQButton;

@interface BQComplimentView : BQBubblesView

@property (nonatomic, strong, readonly) UILabel *complimentLabel;
@property (nonatomic, strong, readonly) BQButton *infoButton;
@property (nonatomic, strong, readonly) BQButton *shareButton;

@end
