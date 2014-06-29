//
// Bouquet
//
// Created by drif on 6/29/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import "BQLicenseViewController.h"

@implementation BQLicenseViewController

#pragma mark UIViewController methods

- (void)loadView {
    [super loadView];
    self.view = [[UITextView alloc] init];
}

#pragma mark Interface methods

- (NSString *)licenseText {
    return self.view.text;
}

- (void)setLicenseText:(NSString *)licenseText{
    self.view.text = licenseText;
}

@end
