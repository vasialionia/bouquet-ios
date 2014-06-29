//
//  BQCompliment.h
//  Bouquet
//
//  Created by drif on 6/29/14.
//  Copyright (c) 2014 vasialionia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BQCompliment : NSManagedObject

@property (nonatomic, retain) NSNumber * complimentId;
@property (nonatomic, retain) NSString * sexKeys;
@property (nonatomic, retain) NSString * langKey;
@property (nonatomic, retain) NSString * text;

@end
