//
//  HYScratchCardView.m
//  Test
//
//  Created by Shadow on 14-5-23.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "SIMEditImageView.h"
#import "PaintingView.h"

NSString * const SIMEditTouchEndNotification = @"SIMEditTouchEndNotificationKey";

@interface SIMEditImageView ()
{
    SIMImageEditTool m_editTool;
}

@property (nonatomic, strong) UIImageView *surfaceImageView;

@property (nonatomic, strong) CALayer *imageLayer;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (nonatomic, assign) CGMutablePathRef path;

@property (nonatomic, strong) PaintingView *paintView;

@property (nonatomic, strong) NSMutableArray *arr;

@end

@implementation SIMEditImageView

- (void)dealloc
{
    if (self.path) {
        CGPathRelease(self.path);
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:SIMEditTouchEndNotification object:nil];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //添加imageview（surfaceImageView）到self上
        self.surfaceImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:self.surfaceImageView];
        self.backgroundColor = [UIColor lightGrayColor];
        self.surfaceImageView.contentMode = UIViewContentModeScaleAspectFit;
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
        
        self.paintView = [[PaintingView alloc]initWithFrame:self.bounds];
        self.paintView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.paintView];
        
        self.simImageEditTool = SIMImageEditToolLine;
        
        self.path = CGPathCreateMutable();
        self.arr = [NSMutableArray array];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(touchEnd) name:SIMEditTouchEndNotification object:nil];
    }
    return self;
}

- (void)setSimImageEditTool:(SIMImageEditTool)simImageEditTool
{
    _simImageEditTool = simImageEditTool;
    switch (_simImageEditTool) {
        case SIMImageEditToolLine:
            self.paintView.userInteractionEnabled = YES;
            self.paintView.erasing = NO;
            self.paintView.lineWidth = 2.0;
            break;
        case SIMImageEditToolMasic:
            self.paintView.userInteractionEnabled = NO;
            self.paintView.erasing = YES;
            self.paintView.lineWidth = 10.0;
            break;
        default:
            break;
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

    [self.paintView touchBeginWithPoint:point];
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
    
    [self.paintView touchMoveWithPoint:point];
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
    SIMEditPathItem *pathItem = [[SIMEditPathItem alloc]init];
    pathItem.path = path;
    [self.arr addObject:pathItem];
}

- (void)touchEnd
{
    switch (_simImageEditTool) {
        case SIMImageEditToolLine:
            [self.paintView addOffscreenImageToArr];
            [self addPathItem];
            break;
        case SIMImageEditToolMasic:
            [self.paintView addOffscreenImageToArr];
            [self addPathItem];
            break;
        default:
            break;
        }
}

- (void)touchBack
{
    [self back];
    [self.paintView back];
}


- (void)setImage:(UIImage *)image
{
    //底图
    _image = image;
    self.imageLayer.contents = (id)image.CGImage;
}

- (void)setSurfaceImage:(UIImage *)surfaceImage
{
    //顶图
    _surfaceImage = surfaceImage;
    self.surfaceImageView.image = surfaceImage;
}

- (void)back
{
    if(self.arr.count > 0){
        SIMEditPathItem *item = self.arr.lastObject;
        CGPathRelease(item.path);
        [self.arr removeLastObject];
        if (self.arr.count > 0) {
            item = self.arr.lastObject;
            self.shapeLayer.path = item.path;
        }else{
            CGPathRelease(self.path);
            self.path = CGPathCreateMutable();
            self.shapeLayer.path = self.path;
        }
    }
}

@end

@implementation SIMEditPathItem

@end



