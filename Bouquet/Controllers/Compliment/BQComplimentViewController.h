//
// Bouquet
//
// Created by drif on 6/22/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BQComplimentView;
@protocol BQComplimentViewControllerDelegate;

@interface BQComplimentViewController : UIViewController

@property (nonatomic, strong) BQComplimentView *view;
@property (nonatomic, weak) id<BQComplimentViewControllerDelegate> delegate;

@end

@protocol BQComplimentViewControllerDelegate

@required

- (void)complimentViewControllerDidTapInfoButton:(BQComplimentViewController *)complimentViewController;

@end
