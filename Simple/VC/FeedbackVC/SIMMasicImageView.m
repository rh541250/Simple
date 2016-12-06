//
//  SIMMasicImageView.m
//  Simple
//
//  Created by hong.ren on 2016/10/24.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "SIMMasicImageView.h"
#import "SIMImageEditDefine.h"

@interface SIMMasicImageView()

@property (nonatomic, strong) UIImageView *surfaceImageView;

@property (nonatomic, strong) CALayer *imageLayer;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (nonatomic, assign) CGMutablePathRef path;

@property (nonatomic, strong) NSMutableArray *arr;


@end


@implementation SIMMasicImageView
@synthesize image = _image;
@synthesize surfaceImage = _surfaceImage;

- (void)dealloc
{
    if (self.path)
    {
        CGPathRelease(self.path);
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.contentMode = UIViewContentModeScaleAspectFit;
        //添加layer（imageLayer）到self上
        self.imageLayer = [CALayer layer];
        self.imageLayer.frame = self.bounds;
        [self.layer addSublayer:self.imageLayer];
        
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.frame = self.bounds;
        self.shapeLayer.lineCap = kCALineCapRound;
        self.shapeLayer.lineJoin = kCALineJoinRound;
        self.shapeLayer.lineWidth = 10.f;
        self.shapeLayer.strokeColor = [UIColor blueColor].CGColor;
        self.shapeLayer.fillColor = nil;//此处设置颜色有异常效果，可以自己试试
        
        self.imageLayer.mask = self.shapeLayer;
        
        self.path = CGPathCreateMutable();
        self.arr = [NSMutableArray array];
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    if (_image != image)
    {
        image = image;
        self.imageLayer.contents = (id)image.CGImage;
    }
}

- (void)setSurfaceImage:(UIImage *)surfaceImage
{
    if (_surfaceImage != surfaceImage)
    {
        _surfaceImage = surfaceImage;
        self.surfaceImageView.image = surfaceImage;
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGPathMoveToPoint(self.path, NULL, point.x, point.y);
    CGMutablePathRef path = CGPathCreateMutableCopy(self.path);
    self.shapeLayer.path = path;
    CGPathRelease(path);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGPathAddLineToPoint(self.path, NULL, point.x, point.y);
    CGMutablePathRef path = CGPathCreateMutableCopy(self.path);
    self.shapeLayer.path = path;
    CGPathRelease(path);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self masicTouchEnd];
}

- (void)masicTouchEnd
{
    [[NSNotificationCenter defaultCenter]postNotificationName:SIMEditTouchEndNotification object:nil];
}

- (void)addPathItem
{
    CGMutablePathRef path = CGPathCreateMutableCopy(self.path);
    SIMMasicPathItem *masicPathItem = [[SIMMasicPathItem alloc]init];
    masicPathItem.path = path;
    [self.arr addObject:masicPathItem];
}

- (void)back
{
    if(self.arr.count > 0){
        SIMMasicPathItem *item = self.arr.lastObject;
        CGPathRelease(item.path);
        [self.arr removeLastObject];
        if (self.arr.count > 0) {
            item = self.arr.lastObject;
            CGPathRelease(self.path);
            self.path = CGPathCreateMutableCopy(item.path);
            self.shapeLayer.path = self.path;
        }else{
            CGPathRelease(self.path);
            self.path = CGPathCreateMutable();
            self.shapeLayer.path = self.path;
        }
    }
}

- (void)clear
{
    if (self.arr.count == 0) {
        return;
    }
    for (SIMMasicPathItem *item in self.arr) {
        CGPathRelease(item.path);
        item.path = NULL;
    }
    [self.arr removeAllObjects];
    
    CGPathRelease(self.path);
    self.path = CGPathCreateMutable();
    self.shapeLayer.path = self.path;
}

@end

@implementation SIMMasicPathItem

@end
