//
// Bouquet
//
// Created by drif on 6/29/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BQCompliment;

@protocol BQComplimentDataSource

@required

- (BQCompliment *)getRandCompliment;

@end