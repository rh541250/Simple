//
//  PaintingView.m
//  AutoLayoutAnimation
//
//  Created by Rafael Fantini da Costa on 9/15/15.
//  Copyright © 2015 Rafael Fantini da Costa. All rights reserved.
//

#import "PaintingView.h"
#import <QuartzCore/QuartzCore.h>

@interface PaintingView ()

@property (nonatomic) CGContextRef offscreenContext;
@property (nonatomic) CGPoint lastLocation;

@property (nonatomic,assign)CGMutablePathRef path;
@property (nonatomic,strong)NSMutableArray *arr;

@property (nonatomic,assign)BOOL backMode;
@end

@implementation PaintingView

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.offscreenContext != NULL) {
        CGContextRelease(self.offscreenContext);
    }
    self.backgroundColor = [UIColor clearColor];
    
    [self initOffscreenContext];
    self.strokeColor = [UIColor redColor];
    
    self.lineWidth = 2.0;
}

- (void)initOffscreenContext
{
    if (self.offscreenContext != NULL) {
        CGContextRelease(self.offscreenContext);
        self.offscreenContext = NULL;
    }
    CGSize viewSize = self.frame.size;
    size_t width = viewSize.width;
    size_t height = viewSize.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    self.offscreenContext = CGBitmapContextCreate(NULL, width, height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
}


- (void)dealloc {
    if (self.offscreenContext != NULL) {
        CGContextRelease(self.offscreenContext);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSAssert(self.offscreenContext != NULL, @"nil");
    [self eraserTouchBeginWithPoint:[[touches anyObject] locationInView:self]];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self eraserTouchMoveWithPoint:[[touches anyObject] locationInView:self]];
}

- (void)eraserTouchBeginWithPoint:(CGPoint)point
{
//    self.lastLocation = point;
    _backMode = NO;
    _path = CGPathCreateMutable();
    CGPathMoveToPoint(_path, NULL, point.x, point.y);
}

- (void)eraserTouchMoveWithPoint:(CGPoint)point
{
    UIColor *strokeColor = self.strokeColor ?: [UIColor redColor];
    
    if (self.isErasing) {
        CGContextSaveGState(self.offscreenContext);
        CGContextSetBlendMode(self.offscreenContext, kCGBlendModeClear);
    }
    
    CGContextSetLineWidth(self.offscreenContext, self.lineWidth);
    CGContextSetLineCap(self.offscreenContext, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(self.offscreenContext, strokeColor.CGColor);
    
    CGPathAddLineToPoint(_path, NULL, point.x, point.y);
    CGContextAddPath(self.offscreenContext, _path);
    CGContextStrokePath(self.offscreenContext);
    
    if (self.isErasing) {
        CGContextRestoreGState(self.offscreenContext);
    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGImageRef offscreenImage = CGBitmapContextCreateImage(self.offscreenContext);
    CAImageItem *item = [CAImageItem new];
    item.cgimage = offscreenImage;
    [self.arr addObject:item];
    
    CGPathRelease(_path);
    _path = NULL;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    NSAssert(self.offscreenContext != NULL, @"nil");
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!_backMode) {
        CGImageRef offscreenImage = CGBitmapContextCreateImage(self.offscreenContext);
        CGContextDrawImage(context, self.bounds, offscreenImage);
        CGImageRelease(offscreenImage);
    }else{
        if (self.arr.count > 0) {
            CAImageItem *item = self.arr.lastObject;
            CGImageRelease(item.cgimage);
            item.cgimage = NULL;
            [self.arr removeLastObject];
            if (self.arr.count > 0) {
                item = self.arr.lastObject;
                CGContextDrawImage(context, self.bounds, item.cgimage);
            }else{
                [self initOffscreenContext];
                CGImageRef offscreenImage = CGBitmapContextCreateImage(self.offscreenContext);
                CGContextDrawImage(context, self.bounds, offscreenImage);
                CGImageRelease(offscreenImage);
            }
        }
    }
}

- (void)back
{
    _backMode = YES;
    [self setNeedsDisplay];
}

@end

@implementation CAImageItem

@end
