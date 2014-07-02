//
// Bouquet
//
// Created by drif on 7/2/14.
// Copyright (c) 2014 vasialionia. All rights reserved.
//

#import "BQBluredView.h"

@interface BQBluredView ()

@property (nonatomic, strong) UIToolbar *toolBar;

@end

@implementation BQBluredView

#pragma mark Private methods

- (void)initToolBar {
    self.toolBar = [[UIToolbar alloc] init];

    self.toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.toolBar];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolBar]|" options:(NSLayoutFormatOptions)0 metrics:nil views:@{@"toolBar": self.toolBar}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[toolBar]|" options:(NSLayoutFormatOptions)0 metrics:nil views:@{@"toolBar": self.toolBar}]];
}

#pragma mark UIView methods

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initToolBar];
    }
    return self;
}

#pragma mark Interface methods

- (UIColor *)tintColor {
    return self.toolBar.barTintColor;
}

- (void)setTintColor:(UIColor *)tintColor {
    self.toolBar.barTintColor = tintColor;
}

@end
