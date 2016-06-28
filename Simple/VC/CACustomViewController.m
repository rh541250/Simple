//
//  CACustomViewController.m
//  Simple
//
//  Created by ehsy on 16/6/23.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "CACustomViewController.h"
#import "UIViewController+AnimateAlertView.h"
//#define angle(x) (((x)/180.0)* M_PI)
//
//#define dampValue 1.0
//#define initialVelocityValue 0.1
//
//NSString  *AnimationShow = @"animShow";
//NSString  *AnimationHide = @"animHide";


@interface CACustomViewController ()

@end

@implementation CACustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
}

- (void)initView
{
    [self alertViewShow];
//    _backView = [[UIView alloc]initWithFrame:self.view.bounds];
//    _backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
//    [self.view addSubview:_backView];
//    
//    [self createEmailView];
//
//    [self ShowAnimation];
}

//- (void)createEmailView
//{
//    _emailView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 240, 310)];
//    _emailView.backgroundColor = [UIColor whiteColor];
//    _emailView.layer.cornerRadius = 1.5;
//    [self.view addSubview:_emailView];
//    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.backgroundColor = [UIColor colorWithRed:29/255.0 green:190/255.0 blue:75/255.0 alpha:1];
//    [btn setTitle:@"确定" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
//    [btn addTarget:self action:@selector(HideAnimation) forControlEvents:UIControlEventTouchUpInside];
//    btn.frame = CGRectMake(0, _emailView.frame.size.height - 40,_emailView.frame.size.width, 40);
//    
//    [_emailView addSubview:btn];
//
//    
//    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, btn.frame.origin.y - 100, 120, 70)];
//    lb.text = @"验证链接已发送到您的邮箱内";
//    lb.textAlignment = NSTextAlignmentCenter;
//    lb.textColor = [UIColor colorWithRed:29/255.0 green:190/255.0 blue:75/255.0 alpha:1];
//    lb.numberOfLines = 0;
//    lb.font = [UIFont systemFontOfSize:16.0];
//    CGPoint lbCenter = lb.center;
//    lbCenter.x = _emailView.center.x;
//    lb.center = lbCenter;
//    [_emailView addSubview:lb];
//    
//    UIView *okView = [[UIView alloc]initWithFrame:CGRectMake(0, 55, 80, 80)];
//    okView.layer.contents = (__bridge id)([self okViewImg].CGImage);
//    CGPoint okViewCenter = okView.center;
//    okViewCenter.x = _emailView.center.x;
//    okView.center = okViewCenter;
//    [_emailView addSubview:okView];
//
//    
//    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [closeBtn setBackgroundImage:[self closeImg] forState:UIControlStateNormal];
//    [closeBtn setBackgroundColor:[UIColor whiteColor]];
//    closeBtn.frame = CGRectMake(_emailView.frame.size.width - 28, 8, 20, 20);
//    [closeBtn addTarget:self action:@selector(HideAnimation) forControlEvents:UIControlEventTouchUpInside];
//    [_emailView addSubview:closeBtn];
//    
//    CGPoint centerPoint = _emailView.center;
//    centerPoint.x = self.view.center.x;
//    _emailView.center = centerPoint;
//    
//    CGRect rect = _emailView.frame;
//    rect.origin.y = -_emailView.frame.size.height - 30;
//    _emailView.frame = rect;
//    
//    
//    CGAffineTransform transform = _emailView.transform;
//    _emailView.transform = CGAffineTransformRotate(transform, angle(30));
//}
//
//- (UIImage *)okViewImg
//{
//    CGSize size = CGSizeMake(160, 160);
//    UIGraphicsBeginImageContext(size);
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//
//    CGContextAddArc(ctx, 80, 80, 80, 0, 2*M_PI, 0);
//    CGContextSetRGBFillColor(ctx, 29/255.0, 190/255.0, 75/255.0, 1);
//    CGContextFillPath(ctx);
//    
//    CGContextMoveToPoint(ctx, 20, 70);
//    CGContextAddLineToPoint(ctx, 45, 120);
//    CGContextAddLineToPoint(ctx, 140,70);
//    CGContextSetLineWidth(ctx, 10);
//    CGContextSetLineCap(ctx, kCGLineCapRound);
//    CGContextSetLineJoin(ctx, kCGLineJoinRound);
//    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
//    CGContextStrokePath(ctx);
//    
//    
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    return img;
//}
//
//- (UIImage *)closeImg
//{
//    CGSize size = CGSizeMake(60,60);
//    UIGraphicsBeginImageContext(size);
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    
//    CGContextMoveToPoint(ctx, 0, 0);
//    CGContextAddLineToPoint(ctx, 60, 60);
//    CGContextMoveToPoint(ctx, 0, 60);
//    CGContextAddLineToPoint(ctx, 60, 0);
//    
//    CGContextSetLineWidth(ctx, 4);
//    CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
//    CGContextSetLineCap(ctx, kCGLineCapRound);
//    
//    CGContextStrokePath(ctx);
//    
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    return img;
//}
//
//
//- (void)ShowAnimation
//{
//    if (!_emailView) {
//        return;
//    }
//    
//    CAAnimationGroup *group = [CAAnimationGroup animation];
//    
//    CABasicAnimation *anim1 = [CABasicAnimation animation];
//    anim1.keyPath = @"position.y";
//    anim1.toValue = @(self.view.center.y);
//    
//    CABasicAnimation *anim2 = [CABasicAnimation animation];
//    anim2.keyPath = @"transform.rotation";
//    anim2.toValue = @(angle(0));
//
//    group.animations = @[anim1,anim2];
//    group.duration = 0.7;
//    
//    group.delegate = self;
//    
//    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    group.removedOnCompletion = NO;
//    group.fillMode = kCAFillModeBoth;
//    
//    [_emailView.layer addAnimation:group forKey:AnimationShow];
//}
//
//- (void)HideAnimation
//{
//    if (!_emailView) {
//        return;
//    }
//    CAAnimationGroup *group = [CAAnimationGroup animation];
//    
//    CABasicAnimation *anim1 = [CABasicAnimation animation];
//    anim1.keyPath = @"position.y";
//    anim1.toValue = @(self.view.frame.size.height+_emailView.frame.size.height);
//    
//    CABasicAnimation *anim2 = [CABasicAnimation animation];
//    anim2.keyPath = @"transform.rotation";
//    anim2.byValue = @(angle(-30));
//    
//    group.animations = @[anim1,anim2];
//    group.duration = 0.7;
//    
//    group.delegate = self;
//    
//    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    group.removedOnCompletion = NO;
//    group.fillMode = kCAFillModeBoth;
//    
//    [_emailView.layer addAnimation:group forKey:AnimationHide];
//}
//
//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
//{
//    CAAnimation *animShow = [_emailView.layer animationForKey:AnimationShow];
//    CAAnimation *animHide = [_emailView.layer animationForKey:AnimationHide];
//    if (anim == animShow) {
//        _emailView.center = self.view.center;
//        _emailView.transform = CGAffineTransformMakeRotation(angle(0));
//        if (flag) {
//            [_emailView.layer removeAnimationForKey:AnimationShow];
//        }
//    }else if (anim == animHide){
//        CGRect rect = _emailView.frame;
//        rect.origin.y = self.view.frame.size.height;
//        _emailView.frame = rect;
//        _emailView.transform = CGAffineTransformMakeRotation(angle(-30));
//        if (flag) {
//            [_emailView.layer removeAnimationForKey:AnimationHide];
//            [_emailView removeFromSuperview];
//        }
//    }
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
