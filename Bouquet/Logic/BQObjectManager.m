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
#import "BQCompliment.h"

NSString *const BQObjectManagerCompletionBlockKeyResponse = @"BQObjectManagerCompletionBlockKeyResponse";
NSString *const BQObjectManagerCompletionBlockKeyError = @"BQObjectManagerCompletionBlockKeyError";

static NSString *const BQObjectManagerDefaultLangKey = @"en";

@interface BQObjectManager ()

@property (nonatomic, strong) NSNumber *prevRandComplimentId;
@property (nonatomic, strong) NSString *langKey;

@end

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
    if (persistentStore == nil) {
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

- (void)initLangKey {
    NSArray *preferredLangKeys = [NSLocale preferredLanguages];
    NSSet *supportedLangKeys = [self getSupportedLangKeys];

    NSString *langKey = BQObjectManagerDefaultLangKey;
    for (NSString *key in preferredLangKeys) {
        if ([supportedLangKeys containsObject:key]) {
            langKey = key;
            break;
        }
    }

    self.langKey = langKey;
}

- (NSSet *)getSupportedLangKeys {
    NSEntityDescription *complimentEntityDescription = [NSEntityDescription entityForName:@"Compliment" inManagedObjectContext:self.managedObjectStore.mainQueueManagedObjectContext];
    NSFetchRequest *langFetchRequest = [[NSFetchRequest alloc] init];
    langFetchRequest.entity = complimentEntityDescription;
    langFetchRequest.propertiesToFetch = @[[[complimentEntityDescription propertiesByName] objectForKey:@"langKey"]];
    langFetchRequest.returnsDistinctResults = YES;
    langFetchRequest.resultType = NSDictionaryResultType;

    NSError *error = nil;
    NSArray *langProperties = [self.managedObjectStore.mainQueueManagedObjectContext executeFetchRequest:langFetchRequest error:&error];
    if (error != nil) {
        BQLogError(@"Error while getting language keys. %@", error);
    }

    NSMutableSet *langKeys = [NSMutableSet setWithCapacity:langProperties.count];
    for (NSDictionary *langProperty in langProperties) {
        [langKeys addObject:langProperty[@"langKey"]];
    }

    return langKeys;
}

- (NSString *)getSexKey {
    switch (self.sex) {
        case BQSexMale:
            return @"m";
        case BQSexFemale:
            return @"f";
        case BQSexOther:
            return @"fm";
        default:
            BQAssert(NO, @"Unknown sex key. %d", (int)self.sex);
            return @"fm";
    }
}

#pragma mark RKObjectManager methods

- (id)initWithHTTPClient:(AFHTTPClient *)client {
    self = [super initWithHTTPClient:client];
    if (self) {
        self.requestSerializationMIMEType = RKMIMETypeJSON;

        [self initManagedObjectStore];
        [self initMappingParameters];
        [self initLangKey];
    }
    return self;
}

#pragma mark Interface methods

- (void)updateComplimentsWithCompletionBlock:(BQObjectManagerCompletionBlock)completionBlock {
    [self getObject:nil path:@"compliment" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self initLangKey];

        if (completionBlock != nil) {
            completionBlock(YES, @{
                    BQObjectManagerCompletionBlockKeyResponse: mappingResult.array
            });
        }
    }
    failure:^(RKObjectRequestOperation *operation, NSError *error) {
        BQLogError(@"Error while getting compliments. %@", error);

        if (completionBlock != nil) {
            completionBlock(YES, @{
                    BQObjectManagerCompletionBlockKeyError: error
            });
        }
    }];
}

#pragma mark BQComplimentDataSource protocol

- (BQCompliment *)getRandCompliment {
    NSEntityDescription *complimentEntityDescription = [NSEntityDescription entityForName:@"Compliment" inManagedObjectContext:self.managedObjectStore.mainQueueManagedObjectContext];
    NSFetchRequest *complimentFetchRequest = [[NSFetchRequest alloc] init];
    complimentFetchRequest.entity = complimentEntityDescription;
    complimentFetchRequest.predicate = [NSPredicate predicateWithFormat:@"langKey == %@ && sexKeys CONTAINS[c] %@", self.langKey, [self getSexKey]];

    NSError *error = nil;
    NSUInteger complimentsCount = [self.managedObjectStore.mainQueueManagedObjectContext countForEntityForName:complimentFetchRequest.entity.name predicate:complimentFetchRequest.predicate error:&error];
    if (error != nil) {
        BQLogError(@"Can't fetch compliments count. %@", error);
        return nil;
    }
    if (complimentsCount == 0) {
        BQLogError(@"Don't have enough compliments.");
        return nil;
    }

    complimentFetchRequest.fetchLimit = 1;
    complimentFetchRequest.fetchOffset = arc4random() % complimentsCount;

    NSArray *compliments = [self.managedObjectStore.mainQueueManagedObjectContext executeFetchRequest:complimentFetchRequest error:&error];
    if (error != nil) {
        BQLogError(@"Can't fetch compliments. %@", error);
        return nil;
    }
    if (compliments.count != 1) {
        BQAssert(NO, @"Can't fetch exactly 1 compliment.");
        return nil;
    }

    BQCompliment *compliment = compliments.firstObject;
    if ([self.prevRandComplimentId isEqualToNumber:compliment.complimentId] && complimentsCount > 1) {
        return [self getRandCompliment];
    }

    self.prevRandComplimentId = compliment.complimentId;

    return compliment;
}

@end
