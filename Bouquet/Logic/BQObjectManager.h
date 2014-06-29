//
// Bouquet
//
// Created by drif on 6/29/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RKObjectManager.h>
#import "BQComplimentDatasource.h"
#import "BQSex.h"
#import "BQSettingsDatasource.h"

extern NSString *const BQObjectManagerCompletionBlockKeyResponse;
extern NSString *const BQObjectManagerCompletionBlockKeyError;

typedef void (^BQObjectManagerCompletionBlock)(BOOL isSuccess, NSDictionary *info);

@interface BQObjectManager : RKObjectManager <
        BQComplimentDatasource,
        BQSettingsDatasource
>

@property (nonatomic, assign) BQSex sex;

- (void)updateComplimentsWithCompletionBlock:(BQObjectManagerCompletionBlock)completionBlock;

@end
