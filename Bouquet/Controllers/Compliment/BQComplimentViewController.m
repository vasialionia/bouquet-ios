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
#import "BQSettingsDatasource.h"

@implementation BQComplimentViewController

#pragma mark Private methods

- (void)onInfoButtonClick:(UIBarButtonItem *)barButtonItem {
    [self.delegate complimentViewControllerDidTapInfoButton:self];
}

- (void)onShareButtonClick:(UIBarButtonItem *)barButtonItem {
    [self.delegate complimentViewControllerDidTapShareButton:self];
}

- (void)onComplimentTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    self.compliment = [self.complimentDatasource getRandCompliment];

    if ([self.delegate respondsToSelector:@selector(complimentViewControllerDidTapCompliment:)]) {
        [self.delegate complimentViewControllerDidTapCompliment:self];
    }
}

#pragma mark UIViewController methods

- (void)loadView {
    [super loadView];
    self.view = [[BQComplimentView alloc] initWithFrame:self.view.frame];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onComplimentTap:)]];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(onInfoButtonClick:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(onShareButtonClick:)];

    self.title = NSLocalizedString(@"U R Awesome", nil);

    if (self.compliment == nil) {
        self.compliment = [self.complimentDatasource getRandCompliment];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    switch (self.settingsDatasource.sex) {
        case BQSexMale:
            self.view.friendImageView.image = [UIImage imageNamed:@"Girl"];
            break;
        case BQSexFemale:
            self.view.friendImageView.image = [UIImage imageNamed:@"Boy"];
            break;
        default:
            BQAssert(NO, @"Unknown sex key. %d", (int)self.settingsDatasource.sex);
            self.view.friendImageView.image = [UIImage imageNamed:@"Girl"];
    }
}

#pragma mark Interface methods

- (void)setCompliment:(BQCompliment *)compliment {
    _compliment = compliment;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.view.complimentLabel.text = _compliment.text;
        [self.view layoutIfNeeded];
    } completion:nil];
}

@end
