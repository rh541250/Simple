//
//  CATestViewController.m
//  Simple
//
//  Created by renhong on 16/9/29.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "CATestViewController.h"

@interface CATestViewController ()
{
    CATestImageView *backgroundImageView;
    UIBezierPath *bPath;
    CGBlendMode mode;
    CAShapeLayer *shapeLayer;
}
@end

@implementation CATestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    backgroundImageView = [[CATestImageView alloc]initWithFrame:CGRectZero];
    backgroundImageView.userInteractionEnabled = YES;
    [self.view addSubview:backgroundImageView];
    
    WS(ws);
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(ws.view).offset(0);
        make.size.mas_equalTo(ws.view.bounds.size);
    }];
    
    UIButton *masicButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,60, 30)];
    [masicButton setTitle:@"切换" forState:UIControlStateNormal];
    masicButton.backgroundColor = [UIColor redColor];
    [masicButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [masicButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [masicButton addTarget:self action:@selector(toolButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:masicButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
}

- (void)toolButtonDidClick:(UIButton *)sender
{
    if (mode == kCGBlendModeClear) {
        mode = kCGBlendModeNormal;
    }else{
        mode = kCGBlendModeClear;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

@implementation CATestImageView
{
    UIBezierPath *bPath;
    CGBlendMode mode;
    CAShapeLayer *shapeLayer;
    NSMutableSet *ptArr;
    BOOL isE;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.backgroundColor = [UIColor whiteColor];
    bPath = [UIBezierPath bezierPath];
    
    mode = kCGBlendModeNormal;
    isE = NO;
    
    self.layer.contents = (id)[UIImage imageNamed:@"p2.jpg"].CGImage;
    self.contentMode = UIViewContentModeScaleAspectFit;
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineWidth = 2.f;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = nil;//此处设置颜色有异常效果，可以自己试试
    [self.layer addSublayer:shapeLayer];
    
    ptArr = [[NSMutableSet alloc]init];
}

- (void)changeMode
{
    isE = !isE;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [bPath moveToPoint:point];
//    [bPath strokeWithBlendMode:mode alpha:1.0];
    shapeLayer.path = bPath.CGPath;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [bPath addLineToPoint:point];
//    [bPath strokeWithBlendMode:mode alpha:1.0];
    shapeLayer.path = bPath.CGPath;
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
}

//- (void)drawRect:(CGRect)rect
//{
////    [super drawRect:rect];
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextBeginTransparencyLayer(ctx,NULL);
//    [bPath moveToPoint:beginPoint];
//    [bPath addLineToPoint:endPoint];
//    [bPath strokeWithBlendMode:mode alpha:1.0];
//    CGContextEndTransparencyLayer(ctx);
//}



@end

