//
// Bouquet
//
// Created by drif on 6/29/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RKObjectManager.h>
#import "BQComplimentDataSource.h"
#import "BQSex.h"
#import "BQSettingsDataSource.h"

extern NSString *const BQObjectManagerCompletionBlockKeyResponse;
extern NSString *const BQObjectManagerCompletionBlockKeyError;

typedef void (^BQObjectManagerCompletionBlock)(BOOL isSuccess, NSDictionary *info);

@interface BQObjectManager : RKObjectManager <
    BQComplimentDataSource,
    BQSettingsDataSource
>

@property (nonatomic, assign) BQSex sex;

- (void)updateComplimentsWithCompletionBlock:(BQObjectManagerCompletionBlock)completionBlock;

@end
