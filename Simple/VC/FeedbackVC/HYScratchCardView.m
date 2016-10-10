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
}

@property (nonatomic, strong) UIImageView *surfaceImageView;

@property (nonatomic, strong) CALayer *imageLayer;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (nonatomic, strong) CAShapeLayer *lineShapeLayer;

@property (nonatomic, assign) CGMutablePathRef path;

@property (nonatomic, assign) CGMutablePathRef linePath;

@property (nonatomic, strong) NSMutableArray *arr;

@end

@implementation HYScratchCardView

- (void)dealloc
{
    if (self.path) {
        CGPathRelease(self.path);
    }
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        m_editTool = SIMImageEditToolRedLine;
        masicNum = 0;
        lineNum = 0;
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
        
        self.path = CGPathCreateMutable();
        self.linePath = CGPathCreateMutable();
        self.arr = [NSMutableArray array];
    }
    return self;
}

- (void)setEditTool:(SIMImageEditTool)editTool
{
    m_editTool = editTool;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (m_editTool == SIMImageEditToolMasic) {
        CGPathMoveToPoint(self.path, NULL, point.x, point.y);
        CGMutablePathRef path = CGPathCreateMutableCopy(self.path);
        self.shapeLayer.path = path;
        CGPathRelease(path);
    }else{
        CGPathMoveToPoint(self.linePath, NULL, point.x, point.y);
        CGMutablePathRef path = CGPathCreateMutableCopy(self.linePath);
        self.lineShapeLayer.path = path;
        CGPathRelease(path);
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    if (m_editTool == SIMImageEditToolMasic) {
        CGPathAddLineToPoint(self.path, NULL, point.x, point.y);
        CGMutablePathRef path = CGPathCreateMutableCopy(self.path);
        self.shapeLayer.path = path;
        CGPathRelease(path);
    }else{
        CGPathAddLineToPoint(self.linePath, NULL, point.x, point.y);
        CGMutablePathRef path = CGPathCreateMutableCopy(self.linePath);
        self.lineShapeLayer.path = path;
        CGPathRelease(path);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (m_editTool == SIMImageEditToolMasic) {
        CGMutablePathRef path = CGPathCreateMutableCopy(self.path);
        [self addPathItem:path withTool:SIMImageEditToolMasic];
        CGPathRelease(path);
        masicNum += 1;
    }else{
        CGMutablePathRef path = CGPathCreateMutableCopy(self.linePath);
        [self addPathItem:path withTool:SIMImageEditToolRedLine];
        CGPathRelease(path);
        lineNum += 1;
    }
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
    if (self.arr.count > 0) {
        HYPathItem *pathItem = self.arr.lastObject;
        CGPathRelease(pathItem.path);
        pathItem.path = nil;
        if(pathItem.editTool == SIMImageEditToolMasic){
            CGPathRelease(self.path);
            self.path = nil;
            masicNum -= 1;
        }else{
            CGPathRelease(self.linePath);
            self.linePath = nil;
            lineNum -= 1;
        }
        HYPathItem *tempItem = nil;
        for (NSInteger i = self.arr.count - 1; i >= 0; i--) {
            if((pathItem.editTool == SIMImageEditToolRedLine && lineNum == 0) || (pathItem.editTool == SIMImageEditToolMasic && masicNum == 0)){
                break;
            }
            
            tempItem = self.arr[i];
            if (tempItem.editTool == pathItem.editTool && tempItem != pathItem) {
                break;
            }
        }
        if (tempItem) {
            if (tempItem.editTool == SIMImageEditToolMasic) {
                self.path = CGPathCreateMutableCopy(tempItem.path);
                self.shapeLayer.path = self.path;
            }else if(tempItem.editTool == SIMImageEditToolRedLine){
                self.linePath = CGPathCreateMutableCopy(tempItem.path);
                self.lineShapeLayer.path = self.linePath;
            }else{
                
            }
        }else{
            if (0 == lineNum && pathItem.editTool == SIMImageEditToolRedLine) {
                CGPathRelease(self.linePath);
                self.linePath = nil;
                self.linePath = CGPathCreateMutable();
                self.lineShapeLayer.path = self.linePath;
            }
            if (0 == masicNum && pathItem.editTool == SIMImageEditToolMasic) {
                CGPathRelease(self.path);
                self.path = nil;
                self.path = CGPathCreateMutable();
                self.shapeLayer.path = self.path;
            }
        }
        [self.arr removeLastObject];
        
    }
}

@end

@implementation HYPathItem

@end
