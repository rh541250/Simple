//
//  HYScratchCardView.m
//  Test
//
//  Created by Shadow on 14-5-23.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "HYScratchCardView.h"

@interface HYScratchCardView ()
{
    SIMImageEditTool m_editTool;
    NSUInteger masicNum;
    NSUInteger lineNum;
    BOOL m_isEraserMode;
}

@property (nonatomic, strong) UIImageView *surfaceImageView;

@property (nonatomic, strong) CALayer *imageLayer;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (nonatomic, strong) CAShapeLayer *lineShapeLayer;

@property (nonatomic, strong) UIBezierPath *masicPath;

@property (nonatomic, strong) UIBezierPath *lienPath;

//@property (nonatomic, assign) CGMutablePathRef path;
//
//@property (nonatomic, assign) CGMutablePathRef linePath;

@property (nonatomic, strong) NSMutableArray *arr;

@end

@implementation HYScratchCardView

- (void)dealloc
{
//    if (self.path) {
//        CGPathRelease(self.path);
//    }
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        m_editTool = SIMImageEditToolRedLine;
        masicNum = 0;
        lineNum = 0;
        m_isEraserMode = NO;
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
        
//        [self.layer addSublayer:self.shapeLayer];
        self.imageLayer.mask = self.shapeLayer;
        
        self.lineShapeLayer = [CAShapeLayer layer];
        self.lineShapeLayer.frame = self.bounds;
        self.lineShapeLayer.lineCap = kCALineCapRound;
        self.lineShapeLayer.lineJoin = kCALineJoinRound;
        self.lineShapeLayer.lineWidth = 2.f;
        self.lineShapeLayer.strokeColor = [UIColor redColor].CGColor;
        self.lineShapeLayer.fillColor = nil;//此处设置颜色有异常效果，可以自己试试
        [self.layer addSublayer:self.lineShapeLayer];
        
        
        self.masicPath = [UIBezierPath bezierPath];
        self.lienPath = [UIBezierPath bezierPath];
//        self.path = CGPathCreateMutable();
//        self.linePath = CGPathCreateMutable();
        self.arr = [NSMutableArray array];
    }
    return self;
}

- (void)setEditTool:(SIMImageEditTool)editTool
{
    m_editTool = editTool;
}

- (void)eraserSwitch
{
    m_isEraserMode = !m_isEraserMode;
    if (m_isEraserMode) {
        [self.masicPath strokeWithBlendMode:kCGBlendModeClear alpha:1];
        [self.lienPath strokeWithBlendMode:kCGBlendModeClear alpha:1];
    }else{
        [self.masicPath strokeWithBlendMode:kCGBlendModeNormal alpha:1];
        [self.lienPath strokeWithBlendMode:kCGBlendModeNormal alpha:1];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (m_editTool == SIMImageEditToolMasic) {
            [self.masicPath moveToPoint:point];
            //        CGPathMoveToPoint(self.masicPath.CGPath, NULL, point.x, point.y);
            CGMutablePathRef path = CGPathCreateMutableCopy(self.masicPath.CGPath);
            self.shapeLayer.path = path;
            CGPathRelease(path);
        }else if(m_editTool == SIMImageEditToolRedLine){
            [self.lienPath moveToPoint:point];
            //        CGPathMoveToPoint(self.linePath, NULL, point.x, point.y);
            CGMutablePathRef path = CGPathCreateMutableCopy(self.lienPath.CGPath);
            self.lineShapeLayer.path = path;
            CGPathRelease(path);
        }else{
        }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    if (m_editTool == SIMImageEditToolMasic) {
        [self.masicPath addLineToPoint:point];
        
//        CGPathAddLineToPoint(self.path, NULL, point.x, point.y);
        CGMutablePathRef path = CGPathCreateMutableCopy(self.masicPath.CGPath);
        self.shapeLayer.path = path;
        CGPathRelease(path);
    }else if(m_editTool == SIMImageEditToolRedLine){
        [self.lienPath addLineToPoint:point];
//        CGPathAddLineToPoint(self.linePath, NULL, point.x, point.y);
        CGMutablePathRef path = CGPathCreateMutableCopy(self.lienPath.CGPath);
        self.lineShapeLayer.path = path;
        CGPathRelease(path);
    }else{
        
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (m_editTool == SIMImageEditToolMasic) {
        CGMutablePathRef path = CGPathCreateMutableCopy(self.masicPath.CGPath);
        [self addPathItem:path withTool:SIMImageEditToolMasic];
        CGPathRelease(path);
        masicNum += 1;
    }else if(m_editTool == SIMImageEditToolRedLine){
        CGMutablePathRef path = CGPathCreateMutableCopy(self.lienPath.CGPath);
        [self addPathItem:path withTool:SIMImageEditToolRedLine];
        CGPathRelease(path);
        lineNum += 1;
    }else{
        
    }
}

- (void)drawRect:(CGRect)rect
{
    
}

- (void)addPathItem:(CGMutablePathRef)path withTool:(SIMImageEditTool)editTool
{
    HYPathItem *pathItem = [[HYPathItem alloc]init];
    pathItem.path = path;
    pathItem.editTool = editTool;
    CGPathRetain(pathItem.path);
    [self.arr addObject:pathItem];
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
//    if (self.arr.count > 0) {
//        HYPathItem *pathItem = self.arr.lastObject;
//        CGPathRelease(pathItem.path);
//        pathItem.path = nil;
//        if(pathItem.editTool == SIMImageEditToolMasic){
//            CGPathRelease(self.masicPath.CGPath);
////            self.masicPath.CGPath = nil;
//            [self.masicPath closePath];
//            masicNum -= 1;
//        }else if(m_editTool == SIMImageEditToolRedLine){
//            CGPathRelease(self.lienPath.CGPath);
////            self.lienPath.CGPath = nil;
//            [self.lienPath closePath];
//            lineNum -= 1;
//        }else{
//            
//        }
//        [self.arr removeLastObject];
//        pathItem = self.arr.lastObject;
//        if (pathItem.editTool == SIMImageEditToolMasic) {
//            self.masicPath.CGPath = CGPathCreateMutableCopy(pathItem.path);
//            self.shapeLayer.path = self.self.masicPath.CGPath;
//        }else if(m_editTool == SIMImageEditToolRedLine){
//            self.lienPath.CGPath = CGPathCreateMutableCopy(pathItem.path);
//            self.lineShapeLayer.path = self.lienPath.CGPath;
//        }else{
//            
//        }
//        
//        if (0 == lineNum) {
//            CGPathRelease(self.masicPath.CGPath);
//            [self.masicPath closePath];
//            self.masicPath.CGPath = CGPathCreateMutable();
//            self.lineShapeLayer.path = self.masicPath.CGPath;
//        }
//        if (0 == masicNum) {
//            CGPathRelease(self.lienPath.CGPath);
//            [self.lienPath closePath];
////            self.path = nil;
//            self.lienPath.CGPath = CGPathCreateMutable();
//            self.shapeLayer.path = self.lienPath.CGPath;
//        }
//    }
}

@end

@implementation HYPathItem

@end
