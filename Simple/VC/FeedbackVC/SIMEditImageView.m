//
//  HYScratchCardView.m
//  Test
//
//  Created by Shadow on 14-5-23.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "SIMEditImageView.h"
#import "PaintingView.h"

@interface SIMEditImageView ()
{
    SIMEditImageToolType m_editTool;
}

@property (nonatomic, strong) UIImageView *surfaceImageView;

@property (nonatomic, strong) CALayer *imageLayer;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (nonatomic, assign) CGMutablePathRef path;

@property (nonatomic, strong) NSMutableArray *arr;

@property (nonatomic, strong) NSMutableArray *toolTypeArr;

@property (nonatomic, strong) PaintingView *paintView;

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
        self.backgroundColor = [UIColor blackColor];

        //添加imageview（surfaceImageView）到self上
        self.surfaceImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:self.surfaceImageView];
        self.surfaceImageView.contentMode = UIViewContentModeScaleAspectFit;
        //添加layer（imageLayer）到self上
        self.imageLayer = [CALayer layer];
        self.imageLayer.frame = self.bounds;
        [self.surfaceImageView.layer addSublayer:self.imageLayer];
        
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
        
        self.currentEditTool = SIMEditImageToolTypeLine;
        
        self.path = CGPathCreateMutable();
        self.arr = [NSMutableArray array];
        self.toolTypeArr = [NSMutableArray array];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(touchEnd) name:SIMEditTouchEndNotification object:nil];
    }
    return self;
}

- (void)setCurrentEditTool:(SIMEditImageToolType)currentEditTool
{
    _currentEditTool = currentEditTool;
    switch (_currentEditTool) {
        case SIMEditImageToolTypeLine:
            self.paintView.userInteractionEnabled = YES;
            self.paintView.erasing = NO;
            break;
        case SIMEditImageToolTypeMosaic:
            self.paintView.userInteractionEnabled = NO;
            self.paintView.erasing = YES;
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

- (void)touchEnd
{
    if (self.toolTypeArr.count == 0 && self.editBlock)
    {
        self.editBlock(YES);
    }
    switch (_currentEditTool) {
        case SIMEditImageToolTypeLine:
        {
            SIMEditToolTypeItem *item = [[SIMEditToolTypeItem alloc]init];
            item.toolType = SIMEditImageToolTypeLine;
            [self.toolTypeArr addObject:item];
            [self.paintView addOffscreenImageToArr];
            break;
        }
        case SIMEditImageToolTypeMosaic:
        {
            SIMEditToolTypeItem *item = [[SIMEditToolTypeItem alloc]init];
            item.toolType = SIMEditImageToolTypeMosaic;
            [self.toolTypeArr addObject:item];
            [self.paintView addOffscreenImageToArr];
            [self addPathItem];
            break;
        }
        default:
            break;
        }
}

- (void)touchBack
{
    if (self.toolTypeArr.count > 0)
    {
        SIMEditToolTypeItem *item = self.toolTypeArr.lastObject;
        if (item.toolType == SIMEditImageToolTypeLine)
        {
            [self.paintView back];
        }
        else
        {
            [self back];
            [self.paintView back];
        }
        [self.toolTypeArr removeLastObject];
        
        if (self.toolTypeArr.count == 0 && self.editBlock)
        {
            self.editBlock(NO);
        }
    }
}

- (void)touchClear
{
    [self clear];
    [self.paintView clear];
    [self.toolTypeArr removeAllObjects];
    if (self.editBlock)
    {
        self.editBlock(NO);
    }
}

- (void)addPathItem
{
    CGMutablePathRef path = CGPathCreateMutableCopy(self.path);
    SIMEditPathItem *pathItem = [[SIMEditPathItem alloc]init];
    pathItem.path = path;
    [self.arr addObject:pathItem];
}

- (void)back
{
    if(self.arr.count > 0){
        SIMEditPathItem *item = self.arr.lastObject;
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
    for (SIMEditPathItem *item in self.arr) {
        CGPathRelease(item.path);
        item.path = NULL;
    }
    [self.arr removeAllObjects];
    
    CGPathRelease(self.path);
    self.path = CGPathCreateMutable();
    self.shapeLayer.path = self.path;
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

@end

@implementation SIMEditToolTypeItem

@end

@implementation SIMEditPathItem

@end



