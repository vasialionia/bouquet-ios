//
// Bouquet
//
// Created by drif on 6/22/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import "BQComplimentViewController.h"
#import "BQComplimentView.h"
#import "BQObjectManager.h"
#import "BQCompliment.h"
#import "BQButton.h"

@implementation BQComplimentViewController

#pragma mark Private methods

- (void)onInfoButtonClick:(UIButton *)button {
    [self.delegate complimentViewControllerDidTapInfoButton:self];
}

- (void)onShareButtonClick:(UIButton *)button {
    [self.delegate complimentViewControllerDidTapShareButton:self];
}

- (void)onComplimentTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    self.compliment = [self.complimentDatasource getRandCompliment];

    if ([self.delegate respondsToSelector:@selector(complimentViewControllerDidTapCompliment:)]) {
        [self.delegate complimentViewControllerDidTapCompliment:self];
    }
}

- (void)onApplicationWillResignActiveNotification:(NSNotification *)notification {
    if ([self.view isAnimating]) {
        [self.view stopAnimation];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationWillEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
}

- (void)onApplicationWillEnterForegroundNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [self.view startAnimation];
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
    [self.view.shareButton addTarget:self action:@selector(onShareButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    if (self.compliment == nil) {
        self.compliment = [self.complimentDatasource getRandCompliment];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view startAnimation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.view stopAnimation];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

    if ([self.view isAnimating]) {
        [self.view stopAnimation];
        [self.view startAnimation];
    }
}

#pragma mark Interface methods

- (void)setCompliment:(BQCompliment *)compliment {
    _compliment = compliment;
    self.view.complimentLabel.text = _compliment.text;
}

@end
