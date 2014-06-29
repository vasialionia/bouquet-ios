//
// Bouquet
//
// Created by drif on 6/29/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import <RestKit/RKPathUtilities.h>
#import <CoreData/CoreData.h>
#import <RestKit/RestKit.h>
#import "BQObjectManager.h"

NSString *const BQObjectManagerCompletionBlockKeyResponse = @"BQObjectManagerCompletionBlockKeyResponse";
NSString *const BQObjectManagerCompletionBlockKeyError = @"BQObjectManagerCompletionBlockKeyError";

@implementation BQObjectManager

#pragma mark Private methods

- (NSString *)mainStorePath {
    return [RKApplicationDataDirectory() stringByAppendingPathComponent:@"bouquet.sqlite"];
}

- (void)initManagedObjectStore {
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];

    NSError *error = nil;
    if(!RKEnsureDirectoryExistsAtPath(RKApplicationDataDirectory(), &error)) {
        BQLogError(@"Failed to create Application Data Directory at path '%@': %@", RKApplicationDataDirectory(), error);
    }

    NSString *path = [self mainStorePath];
    NSDictionary *options = @{
            NSMigratePersistentStoresAutomaticallyOption: @YES,
            NSInferMappingModelAutomaticallyOption: @YES
    };
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:path fromSeedDatabaseAtPath:nil withConfiguration:nil options:options error:&error];
    if (!persistentStore) {
        BQLogError(@"Failed adding persistent store at path '%@': %@", path, error);
    }
    [managedObjectStore createManagedObjectContexts];

    self.managedObjectStore = managedObjectStore;
}

- (void)initMappingParameters {
    RKEntityMapping *complimentMapping = [RKEntityMapping mappingForEntityForName:@"Compliment" inManagedObjectStore:self.managedObjectStore];
    complimentMapping.identificationAttributes = @[@"complimentId"];
    [complimentMapping addAttributeMappingsFromDictionary:@{
            @"id": @"complimentId",
            @"lang": @"langKey",
            @"sex": @"sexKeys",
            @"text": @"text"
    }];

    RKResponseDescriptor *complimentResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:complimentMapping method:RKRequestMethodGET pathPattern:@"compliment" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [self addResponseDescriptor:complimentResponseDescriptor];

    [self addFetchRequestBlock:^NSFetchRequest *(NSURL *URL) {
        RKPathMatcher *pathMatcher = [RKPathMatcher pathMatcherWithPattern:@"compliment"];
        BOOL isMatch = [pathMatcher matchesPath:[URL relativePath] tokenizeQueryStrings:NO parsedArguments:nil];
        if (isMatch) {
            return [NSFetchRequest fetchRequestWithEntityName:@"Compliment"];
        }
        return nil;
    }];
}

#pragma mark RKObjectManager methods

- (id)initWithHTTPClient:(AFHTTPClient *)client {
    self = [super initWithHTTPClient:client];
    if (self) {
        self.requestSerializationMIMEType = RKMIMETypeJSON;

        [self initManagedObjectStore];
        [self initMappingParameters];
    }
    return self;
}

#pragma mark Interface methods

- (void)updateComplimentsWithCompletionBlock:(BQObjectManagerCompletionBlock)completionBlock {
    [self getObject:nil path:@"compliment" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (completionBlock) {
            completionBlock(YES, @{
                    BQObjectManagerCompletionBlockKeyResponse: mappingResult.array
            });
        }
    }
    failure:^(RKObjectRequestOperation *operation, NSError *error) {
        BQLogError(@"Error while getting compliments. %@", error);

        if (completionBlock) {
            completionBlock(YES, @{
                    BQObjectManagerCompletionBlockKeyError: error
            });
        }
    }];
}

@end
