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
    BQSex sex;

    if (button == self.view.maleButton) {
        sex = BQSexMale;
    }
    else if (button == self.view.femaleButton) {
        sex = BQSexFemale;
    }
    else {
        BQAssert(NO, @"Unknown button tapped.");
        sex = BQSexMale;
    }

    [self.delegate welcomeViewController:self didSelectSex:sex];
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

    self.title = NSLocalizedString(@"U R Awesome", nil);
}

@end
