//
//  SpecialLayer.m
//  Simple
//
//  Created by ehsy on 16/5/18.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "SpecialLayer.h"

@implementation SpecialLayer

/*
 *  CAShapeLayer
 */
+ (CALayer *)createCAShapeLayer
{
    /*
     使用CAShapeLayer可以通过矢量图形而不是bitmap来绘制图层子类，
     相比通过Core Graphics的绘图方法，CAShapeLayer有更好的优点:
     
     1.渲染快速。CAShapeLayer使用了硬件加速，绘制同一图形会比Core Graphics更快
     2.高效的使用内存，一个CAShapeLayer不需要像普通的CALayer一样，创建一个图形上下文
     3.不会被图层的边界裁剪掉，一个CAShapeLayer可以在边界之外绘制，而用CoreGraphics绘制图形时，只能在图层内指定的区域内
     4.不会出现像素化
     
     */
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


/*
 *  CATextLayer
 */
+ (CALayer *)createCATextLayerWithRect:(CGRect)rect
{
    /*
     CATextLayer要比UILabel渲染的快得多，CATextLayer使用了core text
     但是其实core text会导致离屏渲染
     离屏渲染就是，GPU在绘图的同时，CPU也在处理绘图信息，所以数据交互还要通过内存，而且还要同步数据，而内存与GPU的交互本来就是比较慢的
     */
    CATextLayer *layer = [CATextLayer layer];
    
    layer.frame = rect;
    layer.foregroundColor = [UIColor blackColor].CGColor;
    layer.alignmentMode  = kCAAlignmentJustified;
    layer.wrapped = YES;
    
    //解决文字像素化问题
    layer.contentsScale = [UIScreen mainScreen].scale;
    
    UIFont *font = [UIFont systemFontOfSize:15.0];
    layer.fontSize = font.pointSize;
    NSString *str = @"dsfasfasfasdffsdflfhaslkdfaklsdaldfaljfdklaflafklj;;,asdf laskdfjlkasjfad";
    
    NSMutableAttributedString *string = nil;
    string = [[NSMutableAttributedString alloc]initWithString:str];
    
    CFStringRef fontName =(__bridge CFStringRef) font.fontName;
    CGFloat fontSize = font.pointSize;
    CTFontRef fontRef = CTFontCreateWithName(fontName, fontSize, NULL);
    
    NSDictionary *attribs = @{
                              (__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor blackColor].CGColor,
                              (__bridge id)kCTFontAttributeName:(__bridge id)fontRef
                              };
    
    [string setAttributes:attribs range:NSMakeRange(0, [str length])];
    attribs = @{
                (__bridge id)kCTForegroundColorAttributeName: (__bridge id)[UIColor redColor].CGColor,
                (__bridge id)kCTUnderlineStyleAttributeName: @(kCTUnderlineStyleSingle),
                (__bridge id)kCTFontAttributeName: (__bridge id)fontRef
                };
    [string setAttributes:attribs range:NSMakeRange(6, 5)];
    
    CFRelease(fontRef);
    
    layer.string = string;
    return layer;
}


/*
 *  CAGradientLayer
 */
+ (CALayer *)createCAGradientLayerWithRect:(CGRect)rect
{
    //CAGradientLayer真正的好处在于绘制的时候使用了硬件加速
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = rect;
    
    layer.colors = @[(__bridge id)[UIColor redColor].CGColor,(__bridge id)[UIColor orangeColor].CGColor,(__bridge id)[UIColor yellowColor].CGColor,(__bridge id)[UIColor greenColor].CGColor,(__bridge id)[UIColor cyanColor].CGColor,(__bridge id)[UIColor blueColor].CGColor,(__bridge id)[UIColor purpleColor].CGColor];
    
    
    layer.locations = @[@0.1,@0.25,@0.35,@0.45,@0.6,@0.7,@0.8];
    layer.startPoint = CGPointMake(0,1);
    layer.endPoint = CGPointMake(1, 0);
    
    return layer;
}

/**
 *  CAReplicatorLayer
 */
+(CALayer *)createCAReplicatorLayerWithRect:(CGRect)rect
{
    //用于创建重复的图层，适合做倒影的时候
    
    CAReplicatorLayer *layer = [CAReplicatorLayer layer];
    layer.frame = rect;
    layer.instanceCount = 15;
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0, 40, 0);
    transform = CATransform3DRotate(transform, M_PI / 4.0, 0, 1, 1);
    transform.m34 = -1.0/500;
    transform = CATransform3DTranslate(transform, 0, -40, 0);
    layer.instanceTransform = transform;
    
    layer.instanceBlueOffset = -0.1;
    layer.instanceGreenOffset = -0.1;
    
    CALayer *lay = [CALayer layer];
    lay.frame = CGRectMake(20, 30, 30, 30);
    lay.backgroundColor = [UIColor cyanColor].CGColor;
    [layer addSublayer:lay];
    
    return layer;
}

/**
 *  CAEmitterLayer
 */
+(CALayer *)createCAEmitterLayerWithRect:(CGRect)rect
{
    CAEmitterLayer *layer = [CAEmitterLayer layer];
    layer.frame = rect;
    
    layer.renderMode = kCAEmitterLayerSurface;
    layer.emitterPosition = CGPointMake(layer.frame.size.width / 2.0, layer.frame.size.height / 2.0);
    
    CAEmitterCell *cell = [[CAEmitterCell alloc]init];
    cell.contents = (__bridge id)[UIImage imageNamed:@"5"].CGImage;
    cell.birthRate = 150;
    cell.lifetime = 5.0;
    cell.color = [UIColor colorWithRed:0.5 green:1 blue:0.1 alpha:1.0].CGColor;
    cell.alphaSpeed = -0.4;
    cell.velocity = 50;
    cell.velocityRange = 50;
    cell.emissionRange = M_PI/3.0 ;
    
    layer.emitterCells = @[cell];
    return layer;
}


@end
