//
// Bouquet
//
// Created by drif on 6/25/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITableView (BQ)

- (UITableViewCell *)cellOfClass:(Class)cellClass withStyle:(UITableViewCellStyle)cellStyle;
- (UITableViewCell *)cellOfClass:(Class)cellClass;

@end