//
// Bouquet
//
// Created by drif on 6/22/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BQComplimentView;
@class BQCompliment;
@protocol BQComplimentViewControllerDelegate;
@protocol BQComplimentDatasource;
@protocol BQSettingsDatasource;

@interface BQComplimentViewController : UIViewController

@property (nonatomic, strong) BQComplimentView *view;
@property (nonatomic, strong) BQCompliment *compliment;
@property (nonatomic, weak) id<BQComplimentViewControllerDelegate> delegate;
@property (nonatomic, strong) id<BQComplimentDatasource> complimentDatasource;
@property (nonatomic, strong) id<BQSettingsDatasource> settingsDatasource;

@end

@protocol BQComplimentViewControllerDelegate <NSObject>

@required

- (void)complimentViewControllerDidTapInfoButton:(BQComplimentViewController *)complimentViewController;
- (void)complimentViewControllerDidTapShareButton:(BQComplimentViewController *)complimentViewController;

@optional

- (void)complimentViewControllerDidTapCompliment:(BQComplimentViewController *)complimentViewController;

@end
