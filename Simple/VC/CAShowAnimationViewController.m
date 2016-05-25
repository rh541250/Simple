//
//  CAShowAnimationViewController.m
//  Simple
//
//  Created by ehsy on 16/5/23.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "CAShowAnimationViewController.h"

@interface CAShowAnimationViewController ()
{
    CALayer *layer;
    
    UIImageView *im;
    NSArray *imgArr;
}
@end

@implementation CAShowAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
/**
 CAAnimation是抽象父类
 CAPropertyAnimation是CAAnimation的子类
 CABasicAnimation和CAKeyframeAnimation，是CAPropertyAnimation的子类
 
 CABasicAnimation也称为single-keyframe,也就是单一关键帧的属性动画
 而CAKeyframeAnimation是多关键帧的属性动画
 
 在CALayer中的可动画属性都属于属性动画的范畴
 
 
 CASpringAnimation是CABasicAnimation的子类，用于做弹簧动画
 
 CATransition是CAAnimation的子类，即过渡动画，不属于属性动画的范畴，可以用于非动画属性的动画制作
 注意：CATranisiton的效果作用于整个图层，而不是单一的属性
 */
    
    
//    [self layoutViews];
//    [self layoutViewsForAnimation];
    [self layoutUnrealProperty];
//    [self layoutTransitionAnimation];
//    [self openOrCloseDoor];
//    [self openOrCloseDoorWithHand];
}

- (void)layoutViews
{
    
    layer =[CALayer layer];
    layer.frame = CGRectMake(100, 100, 100, 100);
    layer.backgroundColor = [UIColor blueColor].CGColor;
    [self.view.layer addSublayer:layer];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"点击" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor cyanColor]];
    btn.frame = CGRectMake(100, 250, 50, 25);
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)clickBtn
{
//    CGFloat red = arc4random() / (CGFloat)INT_MAX;
//    CGFloat green = arc4random() / (CGFloat)INT_MAX;
//    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
//    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
//    
//    //create a basic animation
//    CABasicAnimation *animation = [CABasicAnimation animation];
//    animation.keyPath = @"backgroundColor";
//    animation.toValue = (__bridge id)color.CGColor;
//    animation.duration = 1.0;
//    animation.delegate = self;
//    
//    //通过KVO，对动画指定属于哪个layer，方便在代理方法中进行设置
//    [animation setValue:layer forKey:@"layer"];
//    [layer addAnimation:animation forKey:nil];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.duration = 2.0;
    animation.values = @[
                         (__bridge id)[UIColor blueColor].CGColor,
                         (__bridge id)[UIColor redColor].CGColor,
                         (__bridge id)[UIColor greenColor].CGColor,
                         (__bridge id)[UIColor blueColor].CGColor,
                         (__bridge id)[UIColor cyanColor].CGColor ];
    
//    animation.removedOnCompletion = NO;
//    animation.fillMode = kCAFillModeBoth;
    animation.delegate= self;
    [animation setValue:layer forKey:@"faf"];
    [layer addAnimation:animation forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    CALayer *la = [anim valueForKey:@"faf"];
    
    la.backgroundColor = [UIColor cyanColor].CGColor;
    [CATransaction commit];
}


//CAKeyFrameAnimation
- (void)layoutViewsForAnimation
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(40, 150)];
    [path addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(75, 0) controlPoint2:CGPointMake(225, 300)];
    CAShapeLayer *lay = [CAShapeLayer layer];
    lay.path = path.CGPath;
    lay.fillColor = [UIColor clearColor].CGColor;
    lay.strokeColor = [UIColor redColor].CGColor;
    lay.lineWidth = 3.0f;
    [self.view.layer addSublayer:lay];
    
    CALayer *ship = [CALayer layer];
//    ship.frame = CGRectMake(0, 0,64, 64);
    ship.bounds = CGRectMake(0, 0, 64, 64);
    ship.position = CGPointMake(40, 150);
    ship.contents = (__bridge id)[UIImage imageNamed:@"1.jpg"].CGImage;
    [self.view.layer addSublayer:ship];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 4.0;
    animation.path = path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    [ship addAnimation:animation forKey:nil];
}

//虚拟属性(transform.rotation)以及动画组
- (void)layoutUnrealProperty
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(40, 150)];
    [path addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(75, 0) controlPoint2:CGPointMake(225, 300)];
    CAShapeLayer *lay = [CAShapeLayer layer];
    lay.path = path.CGPath;
    lay.fillColor = [UIColor clearColor].CGColor;
    lay.strokeColor = [UIColor redColor].CGColor;
    lay.lineWidth = 3.0f;
    [self.view.layer addSublayer:lay];
    
    layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 128, 128);
    layer.position = CGPointMake(40, 150);
    layer.contents = (__bridge id)[UIImage imageNamed:@"1.jpg"].CGImage;
    layer.masksToBounds = YES;
    [self.view.layer addSublayer:layer];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.path = path.CGPath;
    CAMediaTimingFunction *fn = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    animation.timingFunctions = @[fn, fn, fn];
    
//    animation.rotationMode = kCAAnimationRotateAuto;
    
    //byValue 相对值，toValue 绝对值
    CABasicAnimation *animation1 = [CABasicAnimation animation];
    animation1.keyPath = @"transform.rotation";
//    animation1.byValue = @(2*M_PI);
//    animation1.duration = 2.0;
    animation1.toValue = @(2*M_PI);
    
    //通过把CALayer中的animatable（可动画）属性设置成keyPath，封装属性动画
    CABasicAnimation *animation2 = [CABasicAnimation animation];
    animation2.keyPath = @"cornerRadius";
    animation2.toValue = @(8.0);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[animation,animation1,animation2];
    group.fillMode = kCAFillModeBackwards;
    group.duration = 4.0;
    [layer addAnimation:group forKey:nil];
}


//CATransition ，过渡动画，可以针对非动画属性，比如image，（动画属性包括了position,scale,rotation,translate,backgroundColor,etc）

- (void)layoutTransitionAnimation
{
    imgArr = @[[UIImage imageNamed:@"1.jpg"],
               [UIImage imageNamed:@"4"],
               [UIImage imageNamed:@"416"],
               [UIImage imageNamed:@"5"]
              ];
    
    
    im = [[UIImageView alloc]init];
    im.frame = CGRectMake(100, 100, 100, 100);
    im.image = [UIImage imageNamed:@"1.jpg"];
    [self.view addSubview:im];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"点击" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor cyanColor]];
    btn.frame = CGRectMake(100, 250, 50, 25);
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)click
{
//    CATransition *transition = [CATransition animation];
//    transition.type = kCATransitionFade;
//    transition.duration = 1.0;
//    [im.layer addAnimation:transition forKey:nil];
//    UIImage *currentImage = im.image;
//    NSUInteger index = [imgArr indexOfObject:currentImage];
//    index = (index +1)%imgArr.count;
//    im.image = imgArr[index];

//      [UIView transitionWithView:im duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
//            UIImage *currentImage = im.image;
//            NSUInteger index = [imgArr indexOfObject:currentImage];
//            index = (index +1)%imgArr.count;
//            im.image = imgArr[index];
//       } completion:nil];
    
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIImageView *coverView = [[UIImageView alloc]initWithImage:img];
    coverView.frame = self.view.bounds;
    [self.view addSubview:coverView];
    
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];

    [UIView animateWithDuration:1.0 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeScale(0.01, 0.01);
        transform = CGAffineTransformRotate(transform, M_PI_2);
        coverView.transform = transform;
        coverView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [coverView removeFromSuperview];
    }];
}

//重复开门关门的动画
- (void)openOrCloseDoor
{
    layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 128, 256);
    layer.position = CGPointMake(150 - 64, 150);
    layer.anchorPoint = CGPointMake(0, 0.5);
    layer.contents = (__bridge id)[UIImage imageNamed:@"1.jpg"].CGImage;
    [self.view.layer addSublayer:layer];
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0/500.0;
    self.view.layer.sublayerTransform = transform;
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation.y";
    animation.toValue = @(-M_PI_2);
    animation.duration = 2.0;
    animation.repeatCount = INFINITY;
    animation.autoreverses = YES;
    [layer addAnimation:animation forKey:nil];
}
//手动控制开门关门的动画
- (void)openOrCloseDoorWithHand
{
    layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 128, 256);
    layer.position = CGPointMake(150, 250);
    layer.anchorPoint = CGPointMake(0, 0.5);
    layer.contents = (__bridge id)[UIImage imageNamed:@"1.jpg"].CGImage;
    [self.view.layer addSublayer:layer];
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0/500.0;
    self.view.layer.sublayerTransform = transform;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]init];
    [pan addTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
    
    layer.speed = 0.0;
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation.y";
    animation.toValue = @(-M_PI_2);
    animation.duration = 1.0;
//    animation.repeatCount = INFINITY;
//    animation.autoreverses = YES;
    [layer addAnimation:animation forKey:nil];
}
- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGFloat x = [pan translationInView:self.view].x;
    x/=200.0f;

    CFTimeInterval timeOffset = layer.timeOffset;
    timeOffset = MIN(0.999, MAX(0.0, timeOffset - x));
    layer.timeOffset = timeOffset;
    
    [pan setTranslation:CGPointZero inView:self.view];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
