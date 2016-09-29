//
//  SmoothLineView.m
//  Simple
//
//  Created by renhong on 16/9/29.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "SmoothLineView.h"
#import <QuartzCore/QuartzCore.h>
#define DEFAULT_COLOR [UIColor blackColor]
#define DEFAULT_WIDTH 5.0f
@interface SmoothLineView()

CGPoint midPoint(CGPoint p1, CGPoint p2);

@end

@implementation SmoothLineView
@synthesize isErase;
@synthesize undoManager;
@synthesize lineColor,lineWidth;

-(void)setup
{
    self.lineWidth = DEFAULT_WIDTH;
    self.lineColor = DEFAULT_COLOR;
    NSUndoManager *tempUndoManager = [[NSUndoManager alloc] init];
    [tempUndoManager setLevelsOfUndo:10];
    [self setUndoManager:tempUndoManager];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setup];
    }
    return self;
}

#pragma mark Private Helper function

CGPoint midPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self.undoManager prepareWithInvocationTarget:self] setImage:[self imageRepresentation]];
    
    UITouch *touch = [touches anyObject];
    
    previousPoint1 = [touch previousLocationInView:self];
    previousPoint2 = [touch previousLocationInView:self];
    currentPoint = [touch locationInView:self];
    
    [self touchesMoved:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch  = [touches anyObject];
    
    previousPoint2  = previousPoint1;
    previousPoint1  = [touch previousLocationInView:self];
    currentPoint    = [touch locationInView:self];
    
    // calculate mid point
    CGPoint mid1    = midPoint(previousPoint1, previousPoint2);
    CGPoint mid2    = midPoint(currentPoint, previousPoint1);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, mid1.x, mid1.y);
    CGPathAddQuadCurveToPoint(path, NULL, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y);
    CGRect bounds = CGPathGetBoundingBox(path);
    CGPathRelease(path);
    
    CGRect drawBox = bounds;
    
    //Pad our values so the bounding box respects our line width
    drawBox.origin.x        -= self.lineWidth * 2;
    drawBox.origin.y        -= self.lineWidth * 2;
    drawBox.size.width      += self.lineWidth * 4;
    drawBox.size.height     += self.lineWidth * 4;
    
    UIGraphicsBeginImageContext(drawBox.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    curImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setNeedsDisplayInRect:drawBox];
    //[self setNeedsDisplay];
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //CGPathRelease(currentPath);
}

- (UIImage *)imageRepresentation {
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
-(void)setImage:(UIImage *)image
{
    curImage = image;
}
- (void)drawRect:(CGRect)rect
{
    [curImage drawAtPoint:CGPointMake(0, 0)];
    CGPoint mid1 = midPoint(previousPoint1, previousPoint2);
    CGPoint mid2 = midPoint(currentPoint, previousPoint1);
    
    context = UIGraphicsGetCurrentContext();
    
    [self.layer renderInContext:context];
    
    CGContextMoveToPoint(context, mid1.x, mid1.y);
    CGContextAddQuadCurveToPoint(context, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, isErase? 20.0f:self.lineWidth);
    CGContextSetStrokeColorWithColor(context, isErase?[UIColor clearColor].CGColor:self.lineColor.CGColor);
    CGContextSetBlendMode(context, isErase ? kCGBlendModeDestinationIn:kCGBlendModeNormal);
    
    CGContextStrokePath(context);
    
    [super drawRect:rect];
    
}

- (void)dealloc
{
    self.lineColor = nil;
}
-(void)clear
{
    //CGContextClearRect(context, CGRectMake(0, 60, 768, 1024));
    [self setImage:nil];
    previousPoint1=CGPointMake(0, 0);
    previousPoint2=CGPointMake(0, 0);
    currentPoint = CGPointMake(0, 0);
    [self setNeedsDisplay];
}
-(void)undo
{
    if ([self.undoManager canUndo]) {
        [self.undoManager undo];
        NSData *data;
        if (UIImagePNGRepresentation(curImage) == nil)
            data = UIImageJPEGRepresentation(curImage, 1);
        else
            data = UIImagePNGRepresentation(curImage);
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);//程序文件夹主目录
        NSString *documentsDirectory = [paths objectAtIndex:0];//Document目录
        static int i =1;
        [fileManager createFileAtPath:[documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/image%d.png",i++]] contents:data attributes:nil];
        previousPoint1=CGPointMake(0, 0);
        previousPoint2=CGPointMake(0, 0);
        currentPoint = CGPointMake(0, 0);
        [self setNeedsDisplay];
    }
}
@end
