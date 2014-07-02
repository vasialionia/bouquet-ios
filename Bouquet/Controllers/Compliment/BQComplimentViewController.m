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
#import "BQComplimentDatasource.h"

@interface BQComplimentViewController()

@property (nonatomic, strong) BQCompliment *currentComplient;

@end

@implementation BQComplimentViewController

#pragma mark Private methods

- (void)onInfoButtonClick:(UIButton *)button {
    [self.delegate complimentViewControllerDidTapInfoButton:self];
}

- (void)onShareButtonClick:(UIButton *)button {
    [self.delegate complimentViewController:self didTapShareButtonForCompliment:self.currentComplient];
}

- (void)onComplimentTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    self.currentComplient = [self.complimentDatasource getRandCompliment];
    self.view.complimentLabel.text = self.currentComplient.text;
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

    self.currentComplient = [self.complimentDatasource getRandCompliment];
    self.view.complimentLabel.text = self.currentComplient.text;
}

@end
