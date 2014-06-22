//
// Bouquet
//
// Created by drif on 6/22/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import "BQComplimentViewController.h"
#import "BQComplimentView.h"

@implementation BQComplimentViewController

#pragma mark Private methods

- (void)onInfoButtonClick:(UIButton *)button {
    [self.delegate complimentViewControllerDidTapInfoButton:self];
}

- (void)onComplimentTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    NSLog(@"%s %s:%d", __PRETTY_FUNCTION__, __FILE__, __LINE__);
}

#pragma mark UIViewController methods

- (void)loadView {
    [super loadView];
    self.view = [[BQComplimentView alloc] initWithFrame:self.view.frame];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onComplimentTap:)]];
    [self.view.infoButton addTarget:self action:@selector(onInfoButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    self.view.complimentLabel.text = @"Copyright (c) 2014 vasialionia. All rights reserved. Copyright (c) 2014 vasialionia. All rights reserved. Copyright (c) 2014 vasialionia. All rights reserved.";
}

@end
