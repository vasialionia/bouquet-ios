//
//  CharacterLabel.m
//  TextFadeTest
//
//  Created by Andrew Hulsizer on 7/1/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import "YETICharacterLabel.h"
#import <CoreText/CoreText.h>

@interface YETICharacterLabel () <NSLayoutManagerDelegate>

@end

@implementation YETICharacterLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setBounds:(CGRect)bounds
{
    self.textContainer.size = bounds.size;
    super.bounds = bounds;
}

- (void)setFrame:(CGRect)frame
{
    self.textContainer.size = frame.size;
    super.frame = frame;
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode
{
    self.textContainer.lineBreakMode = lineBreakMode;
}

- (void)setNumberOfLines:(NSInteger)numberOfLines
{
    self.textContainer.maximumNumberOfLines = numberOfLines;
}

- (void)setup
{
    self.characterTextLayers = [[NSMutableArray alloc] init];
    self.oldCharacterTextLayers = [[NSMutableArray alloc] init];
    [self setupLayoutManager];
}

- (void)setupLayoutManager
{
    self.textStorage = [[NSTextStorage alloc] init];
    self.layoutManager = [[NSLayoutManager alloc] init];
    self.textContainer = [[NSTextContainer alloc] initWithSize:self.bounds.size];
    
    [self.textStorage addLayoutManager:self.layoutManager];
    [self.layoutManager addTextContainer:self.textContainer];
    self.layoutManager.delegate = self;
    
    self.textContainer.maximumNumberOfLines = self.numberOfLines;
    self.textContainer.lineBreakMode = self.lineBreakMode;
    
    [self setAttributedText:self.attributedText];
    [self setSuperToBlank];
}

#pragma mark - Overrides
- (void)setText:(NSString *)text
{
    NSRange wordRange = NSMakeRange(0, text.length);
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedText addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)self.textColor.CGColor range:wordRange];
    [attributedText addAttribute:(NSString *)kCTFontAttributeName value:self.font range:wordRange];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:self.textAlignment];
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:wordRange];
    [self setAttributedText:attributedText];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    if ([self.textStorage.string isEqualToString:attributedText.string]) {
        return;
    }
    
    [self cleanOutOldCharacterTextLayers];
    if (attributedText) {
        [self.textStorage setAttributedString:attributedText];
    }
}

- (void)setSuperToBlank {
    NSAttributedString *blank = [[NSAttributedString alloc] initWithString:@""];
    [super setAttributedText:blank];
}

#pragma mark - NSLayoutManagerDelegate

- (void)layoutManager:(NSLayoutManager *)layoutManager didCompleteLayoutForTextContainer:(NSTextContainer *)textContainer atEnd:(BOOL)layoutFinishedFlag
{
    [self calculateTextLayers];
}

#pragma mark - Private

- (void)cleanOutOldCharacterTextLayers
{
    //Remove all text layers from the superview
    for (CATextLayer *textLayer in self.oldCharacterTextLayers) {
        [textLayer removeFromSuperlayer];
    }
    
    //clean out the text layer
    self.oldCharacterTextLayers = [self.characterTextLayers mutableCopy];
    [self.characterTextLayers removeAllObjects];
}

- (void)updateLayoutCharacter
{
    if (self.textStorage.string) {
        NSRange wordRange = NSMakeRange(0, self.textStorage.string.length);
        CGRect layoutRect = [self.layoutManager usedRectForTextContainer:self.textContainer];
        
        NSInteger textLayerIndex = 0;
        
        for (NSUInteger glyphIndex = wordRange.location; glyphIndex < wordRange.length+wordRange.location; glyphIndex += 0) {
            
            NSRange glyphRange = NSMakeRange(glyphIndex, 1);
            
            // Convert those coordinates to the nearest glyph index
            NSRange characterRange = [self.layoutManager characterRangeForGlyphRange:glyphRange actualGlyphRange:NULL];
            
            // Check to see whether the mouse actually lies over the glyph it is nearest to
            NSTextContainer *textContainer = [self.layoutManager textContainerForGlyphAtIndex:glyphIndex effectiveRange:nil];
            
            //Get Bounding Glyph Rect
            CGRect glyphRect = [self.layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];
            
            //Get the location
            CGPoint location = [self.layoutManager locationForGlyphAtIndex:glyphIndex];
            
            //Check Kerning and add to previous rect if needed
            NSRange glyphKerningRange = [self.layoutManager rangeOfNominallySpacedGlyphsContainingIndex:glyphIndex];
            
            //Adjust if needed
            if (glyphIndex == glyphKerningRange.location && textLayerIndex != 0) {
                CATextLayer *previousLayer = self.characterTextLayers[textLayerIndex-1];
                CGRect frame = previousLayer.frame;
                frame.size.width = CGRectGetMaxX(glyphRect)-CGRectGetMinX(frame);
                previousLayer.frame = frame;
            }
            
            //Adjust the location
//            glyphRect.origin.y += location.y-(CGRectGetHeight(glyphRect)/2)+(CGRectGetMidY(self.bounds))-(CGRectGetHeight(layoutRect)/2);
            
            //Create the new text layer
            CATextLayer *textLayer = self.characterTextLayers[textLayerIndex];
            textLayer.frame = glyphRect;
            
            //Step the number of characters covered
            glyphIndex += characterRange.length;
            textLayerIndex++;
        }
    }
}

- (void)calculateTextLayers
{
    //If its only an update return
    if (self.characterTextLayers.count > 0) {
        [self updateLayoutCharacter];
        return;
    }
    
    if (self.textStorage.string) {
        NSRange wordRange = NSMakeRange(0, self.textStorage.string.length);
        NSMutableAttributedString *attributedText = [self internalAttributedText];
        CGRect layoutRect = [self.layoutManager usedRectForTextContainer:self.textContainer];
        
        for (NSUInteger glyphIndex = wordRange.location; glyphIndex < wordRange.length+wordRange.location; glyphIndex += 0) {
            
            NSRange glyphRange = NSMakeRange(glyphIndex, 1);
            
            // Convert those coordinates to the nearest glyph index
            NSRange characterRange = [self.layoutManager characterRangeForGlyphRange:glyphRange actualGlyphRange:NULL];
            
            // Check to see whether the mouse actually lies over the glyph it is nearest to
            NSTextContainer *textContainer = [self.layoutManager textContainerForGlyphAtIndex:glyphIndex effectiveRange:nil];
            
            //Get Bounding Glyph Rect
            CGRect glyphRect = [self.layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];
            
            //Get the location
            CGPoint location = [self.layoutManager locationForGlyphAtIndex:glyphIndex];
            
            //Check Kerning and add to previous rect if needed
            NSRange glyphKerningRange = [self.layoutManager rangeOfNominallySpacedGlyphsContainingIndex:glyphIndex];
            
            //Adjust if needed
            if (glyphIndex == glyphKerningRange.location) {
                CATextLayer *previousLayer = [self.characterTextLayers lastObject];
                CGRect frame = previousLayer.frame;
                frame.size.width = CGRectGetMaxX(glyphRect)-CGRectGetMinX(frame);
                previousLayer.frame = frame;
            }
            
            //Adjust the location
//            glyphRect.origin.y += location.y-(CGRectGetHeight(glyphRect)/2)+(CGRectGetMidY(self.bounds))-(CGRectGetHeight(layoutRect)/2);
            
            //Create the new text layer
            CATextLayer *textLayer = [CATextLayer layer];
            textLayer.contentsScale = [[UIScreen mainScreen] scale];
            textLayer.frame = glyphRect;
            textLayer.string = [attributedText attributedSubstringFromRange:characterRange];
            [self initialTextLayerAttributes:textLayer];
            
            //add new text layer to heirarchy
            [self.layer addSublayer:textLayer];
            [self.characterTextLayers addObject:textLayer];
            
            //Step the number of characters covered
            glyphIndex += characterRange.length;
        }
    }
}

- (NSMutableAttributedString *)internalAttributedText
{
    NSRange wordRange = NSMakeRange(0, self.textStorage.string.length);
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:self.textStorage.string];
    [attributedText addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)self.textColor.CGColor range:wordRange];
    [attributedText addAttribute:(NSString *)kCTFontAttributeName value:self.font range:wordRange];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:self.textAlignment];
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:wordRange];
    
    return attributedText;
}

#pragma mark - Subclass Overrides
- (void)initialTextLayerAttributes:(CATextLayer *)textLayer
{
    
}
@end
