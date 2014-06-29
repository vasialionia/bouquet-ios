//
// Bouquet
//
// Created by drif on 6/29/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BQSex.h"

@class BQCompliment;

@protocol BQSettingsDataSource

@required

- (BQSex)sex;
- (void)setSex:(BQSex)sex;

@end
