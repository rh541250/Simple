//
//  CAViewController.m
//  Simple
//
//  Created by ehsy on 16/5/11.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "CAViewController.h"

@interface CAViewController ()
{
    UIView *layerView;
    CALayer *greenLayer;
}
@end

@implementation CAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutViews];
//    [self layoutLayers];
//    [self layoutSepLayers];
}

- (void)layoutViews
{
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    layerView = [[UIView alloc]init];
    layerView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:layerView];
    
    WS(ws);
    [layerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.view).with.offset(-100);
        make.centerX.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
    
    greenLayer = [CALayer layer];
    
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    greenLayer.contents = (__bridge id)image.CGImage;
    greenLayer.contentsGravity = kCAGravityResizeAspect;
//    greenLayer.masksToBounds = YES;
    
//    greenLayer.contentsGravity = kCAGravityResizeAspect;
    greenLayer.frame = CGRectMake(50, 50, 100, 100);
    [layerView.layer addSublayer:greenLayer];

//  图层的边框默认是黑色的，宽度是0，并且边框是画在图层内部的
    greenLayer.borderColor = [UIColor blackColor].CGColor;
    greenLayer.borderWidth = 1.0;
//  圆角只能作用于当前图层的背景色，不能作用于子图层和背景图片，所以一般会加上maskToBounds = YES
//    greenLayer.cornerRadius = 10.0;
//    greenLayer.masksToBounds = YES;
    
    //要设置阴影的Opacity不为0才能显示阴影（默认是0，不显示）
    greenLayer.shadowOpacity = 0.8;
    //阴影颜色，CGColorRef类型
    greenLayer.shadowColor = [UIColor blackColor].CGColor;
    //代表阴影的模糊度，越大越模糊
    greenLayer.shadowRadius = 5.0;
    //代表阴影的偏移量，x标识X轴上的偏移量，y标识Y轴上的偏移量
    greenLayer.shadowOffset = CGSizeMake(0, 4);
    
    
    //阴影的path，设置shadowPath可以帮助提升性能(因为cpu不再需要计算阴影的路径了呀)，记得要释放掉
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddEllipseInRect(path, NULL, greenLayer.bounds);
//    greenLayer.shadowPath = path;
//    CGPathRelease(path);
    
    //图片的拉伸过滤，会造成性能的消耗，但是有时候需要缩略图或者查看大图，就会缩放图片，这时候就会用到图片的拉伸过滤算法，（CALayer使用的是双线性过滤算法，还有三线性过滤算法，这两个算法适合保存图片的纹理和路径，还有最近取样算法，适合保存像素的差异性，常用在简单的直方图中）
//    greenLayer.minificationFilter = kCAFilterTrilinear;//缩小的拉伸过滤算法(双线性过滤)
//    greenLayer.magnificationFilter = kCAFilterTrilinear;//放大的拉伸过滤算法(双线性过滤)
//    greenLayer.minificationFilter = kCAFilterNearest;
    
    //图层仿射变换，affineTransform
//    greenLayer.affineTransform = CGAffineTransformMakeRotation(M_PI_4);
    
    //组合仿射变换
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    transform = CGAffineTransformScale(transform, 0.5, 0.5);
//    transform = CGAffineTransformRotate(transform, M_PI / 180.0 * 30.0);
//    transform = CGAffineTransformTranslate(transform, 100, 0);
//    greenLayer.affineTransform = transform;
    
    //图层3D仿射变换，Transform3D
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0/500;
    transform = CATransform3DRotate(transform, -M_PI_4, 0, 1, 0);
    transform = CATransform3DRotate(transform, -M_PI_4, 1, 0, 0);
    greenLayer.transform = transform;
    
    //是否绘制图层背面（当图层做3D旋转时，可以设置成NO，禁止背面的绘制，提升性能）
//    greenLayer.doubleSided = YES;
    
//    CATransform3D transform = CATransform3DMakeRotation(M_PI_4,0, 1, 0);
//    greenLayer.transform = transform;

//    CATransform3D transform = CATransform3DIdentity;
//    transform.m34 = -1.0/500;
//    transform = CATransform3DRotate(transform, -M_PI_4, 0, 1, 0);
//    greenLayer.transform = transform;
    
}



//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    CGPoint point = [[touches anyObject] locationInView: self.view];
//
//    point = [self.view.layer convertPoint:point toLayer:layerView.layer];
//    
//    if ([layerView.layer containsPoint:point]) {
//        point = [greenLayer convertPoint:point fromLayer:layerView.layer];
//        if ([greenLayer containsPoint:point]) {
//            NSLog(@"点在绿色图层上了");
//        }else{
//            NSLog(@"点在白色图层上了");
//        }
//        
//    }
//    
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self.view];
    
    CALayer *layer = [self.view.layer hitTest:point];
    if (layer == greenLayer) {
        NSLog(@"点击在了绿色图层上");
    }else if(layer == layerView.layer){
        NSLog(@"点击在了白色图层上");
    }else if(layer == self.view.layer){
        NSLog(@"点击在了self.view图层上");
    }
}



- (void)layoutLayers
{
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIView *layerView2 = [[UIView alloc]init];
    layerView2.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:layerView2];
    
    WS(ws);
    [layerView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.view).with.offset(-100);
        make.centerX.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
    
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50, 50, 100, 100);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    
    blueLayer.delegate = self;
    blueLayer.contentsScale = [UIScreen mainScreen].scale;
    [layerView2.layer addSublayer:blueLayer];
    
    [blueLayer display];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    CGContextSetLineWidth(ctx, 10.0f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);
}


#pragma mark - 专用图层

- (void)layoutSepLayers
{
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.view.layer addSublayer:[self createCAShapeLayer]];
    [self.view.layer addSublayer:[self createCATextLayerWithRect:CGRectMake(50, 100, 100, 300)]];
}

- (CALayer *)createCAShapeLayer
{
    //画火柴人
    UIBezierPath *path = [[UIBezierPath alloc]init];
    [path moveToPoint:CGPointMake(175, 100)];
    [path addArcWithCenter:CGPointMake(150, 100) radius:25 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [path moveToPoint:CGPointMake(150, 125)];
    [path addLineToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(125, 225)];
    [path moveToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(175, 225)];
    [path moveToPoint:CGPointMake(100, 150)];
    [path addLineToPoint:CGPointMake(200, 150)];
    
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor redColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 5;
    layer.lineJoin  = kCALineJoinRound;
    layer.lineCap = kCALineCapRound;
    layer.path = path.CGPath;
    return layer;
}

- (CALayer *)createCATextLayerWithRect:(CGRect)rect
{
    CATextLayer *layer = [CATextLayer layer];
    
    layer.frame = rect;
    layer.foregroundColor = [UIColor blackColor].CGColor;
    layer.alignmentMode  = kCAAlignmentJustified;
    layer.wrapped = YES;
    
    //解决文字像素化问题
    layer.contentsScale = [UIScreen mainScreen].scale;
    
    UIFont *font = [UIFont systemFontOfSize:15.0];
    CFStringRef fontName =(__bridge CFStringRef) font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    layer.font = fontRef;
    layer.fontSize = font.pointSize;
    
    CGFontRelease(fontRef);
    
    NSString *str = @"dsfasfasfasdff sdflfhaslkdfaklsd aldfaljfdklafl afklj;;,asdf laskdfjlkasjf ad";
    layer.string = str;
    
    
    return layer;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
