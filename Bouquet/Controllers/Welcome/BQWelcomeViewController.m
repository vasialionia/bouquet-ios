//
//  BQWelcomeViewController.m
//  Bouquet
//
//  Created by drif on 6/22/14.
//  Copyright (c) 2014 vasialionia. All rights reserved.
//

#import "BQWelcomeViewController.h"
#import "BQWelcomeView.h"

@implementation BQWelcomeViewController

#pragma mark Private methods

- (void)onButtonTap:(UIButton *)button {
    if (button == self.view.maleButton) {
        [self.delegate welcomeViewController:self didSelectSexMode:BQWelcomeViewControllerSexModeMale];
    }
    else if (button == self.view.femaleButton) {
        [self.delegate welcomeViewController:self didSelectSexMode:BQWelcomeViewControllerSexModeFemale];
    }
    else if (button == self.view.otherButton) {
        [self.delegate welcomeViewController:self didSelectSexMode:BQWelcomeViewControllerSexModeOther];
    }
    else {
        BQAssert(NO, @"Unknown button tapped!");
    }
}

#pragma mark UIViewController methods

- (void)loadView {
    [super loadView];
    self.view = [[BQWelcomeView alloc] initWithFrame:self.view.frame];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view.maleButton addTarget:self action:@selector(onButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view.femaleButton addTarget:self action:@selector(onButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view.otherButton addTarget:self action:@selector(onButtonTap:) forControlEvents:UIControlEventTouchUpInside];
}

@end
