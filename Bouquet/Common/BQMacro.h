//
// Bouquet
//
// Created by drif on 6/22/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#if !DEBUG
#import "MWLogging.h"
#import <Crashlytics/Crashlytics.h>
#endif

#if DEBUG
#define BQLogError NSLog
#else
#define BQLogError(...) \
do \
{ \
    NSString *message = [NSString stringWithFormat:__VA_ARGS__]; \
    MWLogError(@"%@ in %s of %s:%u", message, __PRETTY_FUNCTION__, __FILE__, __LINE__); \
    CLS_LOG(@"<Error> %@", message); \
} \
while(0)
#endif

#if DEBUG
#define BQAssert NSAssert
#else
#define BQAssert(condition, ...) \
do \
{ \
    if(!(condition)) \
    { \
        NSString *assertmessage = [NSString stringWithFormat:__VA_ARGS__]; \
        BQLogError(@"<Assert> %@", assertmessage); \
    } \
} \
while(0)
#endif

#if DEBUG
#define BQParameterAssert NSParameterAssert
#else
#define BQParameterAssert(condition) NSAssert((condition), @"Invalid parameter not satisfying: %s", #condition)
#endif
