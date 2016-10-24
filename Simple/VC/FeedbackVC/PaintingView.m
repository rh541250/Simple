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
{
    CGRect offScreenContextRect;
}
@property (nonatomic) CGContextRef offscreenContext;
@property (nonatomic) CGPoint lastLocation;

@property (nonatomic,assign)CGMutablePathRef path;
@property (nonatomic,strong)NSMutableArray *arr;


@property (nonatomic,assign)BOOL backMode;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) UIColor *strokeColor;

@end

@implementation PaintingView

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    
    [self initOffscreenContext];
    self.strokeColor = [UIColor redColor];
    self.lineWidth = 2.0;
    
    self.arr = [NSMutableArray array];
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
    
    offScreenContextRect = CGRectMake(0, 0, viewSize.width, viewSize.height);
    
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
    [self touchBeginWithPoint:[[touches anyObject] locationInView:self]];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchMoveWithPoint:[[touches anyObject] locationInView:self]];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self lineTouchEnd];
}

- (void)lineTouchEnd
{
    [[NSNotificationCenter defaultCenter]postNotificationName:SIMEditTouchEndNotification object:nil];
}

- (void)touchBeginWithPoint:(CGPoint)point
{
    _backMode = NO;
    _path = CGPathCreateMutable();
    CGPathMoveToPoint(_path, NULL, point.x, point.y);
}

- (void)touchMoveWithPoint:(CGPoint)point
{
    self.lineWidth = 2.0;
    if (self.isErasing) {
        CGContextSaveGState(self.offscreenContext);
        CGContextSetBlendMode(self.offscreenContext, kCGBlendModeClear);
        self.lineWidth = 10.0;
    }
    
    CGContextSetLineWidth(self.offscreenContext, self.lineWidth);
    CGContextSetLineCap(self.offscreenContext, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(self.offscreenContext, self.strokeColor.CGColor);
    
    CGPathAddLineToPoint(_path, NULL, point.x, point.y);
    CGContextAddPath(self.offscreenContext, _path);
    CGContextStrokePath(self.offscreenContext);
    
    if (self.isErasing) {
        CGContextRestoreGState(self.offscreenContext);
    }
    [self setNeedsDisplay];
}

- (void)addOffscreenImageToArr
{
    CGImageRef offscreenImage = CGBitmapContextCreateImage(self.offscreenContext);
    SIMEditImageItem *item = [SIMEditImageItem new];
    item.cgimage = offscreenImage;
    item.path = CGPathCreateMutableCopy(self.path);
    item.blendMode = self.isErasing ? kCGBlendModeClear : kCGBlendModeNormal;
    [self.arr addObject:item];
    
    CGPathRelease(self.path);
    self.path = NULL;
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
            SIMEditImageItem *item = self.arr.lastObject;
            CGImageRelease(item.cgimage);
            item.cgimage = NULL;
            CGPathRelease(item.path);
            item.path = NULL;
            [self.arr removeLastObject];
            if (self.arr.count > 0) {
                item = self.arr.lastObject;
                CGContextClearRect(self.offscreenContext,offScreenContextRect);
                [self reDrawPath];
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

- (void)clear
{
    if (self.arr.count == 0) {
        return;
    }
    for (SIMEditImageItem *item in self.arr) {
        CGImageRelease(item.cgimage);
        item.cgimage = NULL;
        CGPathRelease(item.path);
        item.path = NULL;
    }
    [self.arr removeAllObjects];
    _backMode = NO;
    [self initOffscreenContext];
    [self setNeedsDisplay];
}

- (void)reDrawPath
{
    for (SIMEditImageItem *item in self.arr) {
        self.lineWidth = 2.0;
        if (item.blendMode == kCGBlendModeClear) {
            CGContextSaveGState(self.offscreenContext);
            CGContextSetBlendMode(self.offscreenContext, kCGBlendModeClear);
            self.lineWidth = 10.0;
        }
        
        CGContextSetLineWidth(self.offscreenContext, self.lineWidth);
        CGContextSetLineCap(self.offscreenContext, kCGLineCapRound);
        CGContextSetStrokeColorWithColor(self.offscreenContext, self.strokeColor.CGColor);
        
        CGContextAddPath(self.offscreenContext, item.path);
        CGContextStrokePath(self.offscreenContext);
        
        if (item.blendMode == kCGBlendModeClear) {
            CGContextRestoreGState(self.offscreenContext);
        }
    }
}

@end

@implementation SIMEditImageItem

@end
