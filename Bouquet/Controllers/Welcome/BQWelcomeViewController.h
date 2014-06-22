//
//  BQWelcomeViewController.h
//  Bouquet
//
//  Created by drif on 6/22/14.
//  Copyright (c) 2014 vasialionia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BQWelcomeViewControllerSexMode) {
    BQWelcomeViewControllerSexModeMale,
    BQWelcomeViewControllerSexModeFemale,
    BQWelcomeViewControllerSexModeOther
};

@class BQWelcomeView;
@protocol BQWelcomeViewControllerDelegate;

@interface BQWelcomeViewController : UIViewController

@property (nonatomic, strong, readwrite) BQWelcomeView *view;
@property (nonatomic, weak) id<BQWelcomeViewControllerDelegate> delegate;

@end

@protocol BQWelcomeViewControllerDelegate

@required

- (void)welcomeViewController:(BQWelcomeViewController *)welcomeViewController didSelectSexMode:(BQWelcomeViewControllerSexMode)sexMode;

@end
