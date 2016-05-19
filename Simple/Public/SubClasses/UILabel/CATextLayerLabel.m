//
//  CATextLayerLabel.m
//  Simple
//
//  Created by ehsy on 16/5/18.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "CATextLayerLabel.h"

@implementation CATextLayerLabel

+(Class)layerClass
{
    return [CATextLayer class];
}


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (CATextLayer *)textLayer
{
    return (CATextLayer *)self.layer;
}

- (void)setup
{
    self.text = self.text;
    self.textColor = self.textColor;
    self.font = self.font;
    
    [self textLayer].alignmentMode = kCAAlignmentJustified;
    [self textLayer].wrapped = YES;
    [self.layer display];
}


- (void)awakeFromNib
{
    [self setup];
}


- (void)setText:(NSString *)text
{
    super.text = text;
    [self textLayer].string = text;
}

- (void)setTextColor:(UIColor *)textColor
{
    super.textColor = textColor;
    [self textLayer].foregroundColor = textColor.CGColor;
}

- (void)setFont:(UIFont *)font
{
    super.font = font;
    
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    
    [self textLayer].font = fontRef;
    [self textLayer].fontSize = font.pointSize;
    
    CGFontRelease(fontRef);
}

@end
