//
// Bouquet
//
// Created by drif on 6/25/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import "UITableView+BQ.h"

@implementation UITableView (BQ)

#pragma mark Interface methods

- (UITableViewCell *)cellOfClass:(Class)cellClass withStyle:(UITableViewCellStyle)cellStyle {
    BQParameterAssert(cellClass);

    NSString *cellIdentifier = [NSString stringWithFormat:@"%@", cellClass];

    id cell = [self dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[cellClass alloc] initWithStyle:cellStyle reuseIdentifier:cellIdentifier];
    }

    return cell;
}

- (UITableViewCell *)cellOfClass:(Class)cellClass {
    return [self cellOfClass:cellClass withStyle:UITableViewCellStyleDefault];
}

@end
