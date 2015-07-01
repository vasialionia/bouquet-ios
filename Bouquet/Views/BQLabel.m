//
// Bouquet
//
// Created by drif on 7/1/15.
// Copyright (c) 2015 vasialionia. All rights reserved.
//

#import "BQLabel.h"
#import "YETIMotionLabel.h"

@interface BQLabel ()

@property (nonatomic, strong) YETIMotionLabel *motionLabel;

@end

@implementation BQLabel

#pragma mark Private methods

- (void)initMotionLabel {
    self.motionLabel = [[YETIMotionLabel alloc] init];
    self.motionLabel.textContainer.lineFragmentPadding = 0.0f;

    self.motionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.motionLabel];
}

#pragma mark NSObject methods

- (id)init {
    self = [super init];
    if (self) {
        super.textColor = [UIColor clearColor];
        [self initMotionLabel];
    }
    return self;
}

#pragma mark UIView methods

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.motionLabel.frame = CGRectMake(0.0f, -2.0f, self.bounds.size.width, self.bounds.size.height + 5.0f);
    if (self.text) {
        self.motionLabel.text = self.text;
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.motionLabel.frame = CGRectMake(0.0f, -2.0f, self.bounds.size.width, self.bounds.size.height + 5.0f);
    if (self.text) {
        self.motionLabel.text = self.text;
    }
}

#pragma mark UILabel methods

- (void)setNumberOfLines:(NSInteger)numberOfLines {
    [super setNumberOfLines:numberOfLines];
    self.motionLabel.numberOfLines = numberOfLines;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    self.motionLabel.textAlignment = textAlignment;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.motionLabel.font = font;
}

- (void)setTextColor:(UIColor *)textColor {
    self.motionLabel.textColor = textColor;
}

@end
