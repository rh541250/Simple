//
//  UIViewController+AnimateAlertView.m
//  Simple
//
//  Created by ehsy on 16/6/27.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "UIViewController+AnimateAlertView.h"
#import <objc/runtime.h>

#define angle(x) (((x)/180.0)* M_PI)

#define dampValue 1.0
#define initialVelocityValue 0.1

NSString  *AnimationShow = @"animShow";
NSString  *AnimationHide = @"animHide";

static char kAlertView;
static char kBackView;

@implementation UIViewController (AnimateAlertView)

@dynamic alertView;
@dynamic backView;


#pragma associate Method
- (void)setAlertView:(UIView *)alertView
{
    objc_setAssociatedObject(self, &kAlertView, alertView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)alertView
{
    return objc_getAssociatedObject(self, &kAlertView);
}

- (void)setBackView:(UIView *)backView
{
    objc_setAssociatedObject(self, &kBackView, backView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)backView
{
    return objc_getAssociatedObject(self, &kBackView);
}

#pragma alert method
- (void)alertViewShow
{
    [self alertViewShowWithTitle:@"验证链接已发送到您的邮箱内"];
}

- (void)alertViewShowWithTitle:(NSString *)title
{
    //默认是从头部弹出
    [self alertViewShowWithDirection:E_Direction_Top title:title];
}


- (void)alertViewShowWithDirection:(E_Direction)direction title:(NSString *)title
{
    if (!self.backView) {
        self.backView = [[UIView alloc]initWithFrame:self.view.bounds];
        self.backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [self.view addSubview:self.backView];
    }

    if (!self.alertView) {
        self.alertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 240, 310)];
        self.alertView.backgroundColor = [UIColor whiteColor];
        self.alertView.layer.cornerRadius = 1.5;
        [self.view addSubview:self.alertView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor colorWithRed:29/255.0 green:190/255.0 blue:75/255.0 alpha:1];
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [btn addTarget:self action:@selector(HideAnimation) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(0, self.alertView.frame.size.height - 40,self.alertView.frame.size.width, 40);
        
        [self.alertView addSubview:btn];
        
        
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, btn.frame.origin.y - 100, 120, 70)];
        lb.text = title;
        lb.textAlignment = NSTextAlignmentCenter;
        lb.textColor = [UIColor colorWithRed:29/255.0 green:190/255.0 blue:75/255.0 alpha:1];
        lb.numberOfLines = 0;
        lb.font = [UIFont systemFontOfSize:16.0];
        CGPoint lbCenter = lb.center;
        lbCenter.x = self.alertView.center.x;
        lb.center = lbCenter;
        [self.alertView addSubview:lb];
        
        UIView *okView = [[UIView alloc]initWithFrame:CGRectMake(0, 55, 80, 80)];
        okView.layer.contents = (__bridge id)([self okViewImg].CGImage);
        CGPoint okViewCenter = okView.center;
        okViewCenter.x = self.alertView.center.x;
        okView.center = okViewCenter;
        [self.alertView addSubview:okView];
        
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setBackgroundImage:[self closeImg] forState:UIControlStateNormal];
        [closeBtn setBackgroundColor:[UIColor whiteColor]];
        closeBtn.frame = CGRectMake(self.alertView.frame.size.width - 28, 8, 20, 20);
        [closeBtn addTarget:self action:@selector(HideAnimation) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView addSubview:closeBtn];
        
        CGPoint centerPoint = self.alertView.center;
        centerPoint.x = self.view.center.x;
        self.alertView.center = centerPoint;
        
        CGRect rect = self.alertView.frame;
        rect.origin.y = -self.alertView.frame.size.height - 30;
        self.alertView.frame = rect;
        
        
        CGAffineTransform transform = self.alertView.transform;
        self.alertView.transform = CGAffineTransformRotate(transform, angle(30));
    }
    
    [self ShowAnimationWithDirection:direction];
}

#pragma private method

- (UIImage *)okViewImg
{
    CGSize size = CGSizeMake(160, 160);
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextAddArc(ctx, 80, 80, 80, 0, 2*M_PI, 0);
    CGContextSetRGBFillColor(ctx, 29/255.0, 190/255.0, 75/255.0, 1);
    CGContextFillPath(ctx);
    
    CGContextMoveToPoint(ctx, 20, 70);
    CGContextAddLineToPoint(ctx, 45, 120);
    CGContextAddLineToPoint(ctx, 140,70);
    CGContextSetLineWidth(ctx, 10);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextStrokePath(ctx);
    
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    return img;
}

- (UIImage *)closeImg
{
    CGSize size = CGSizeMake(60,60);
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, 60, 60);
    CGContextMoveToPoint(ctx, 0, 60);
    CGContextAddLineToPoint(ctx, 60, 0);
    
    CGContextSetLineWidth(ctx, 4);
    CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    CGContextStrokePath(ctx);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    return img;
}


- (void)ShowAnimationWithDirection:(E_Direction)direction
{
    if (!self.alertView) {
        return;
    }
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    
    CABasicAnimation *anim1 = [CABasicAnimation animation];
    anim1.keyPath = @"position.y";
    anim1.toValue = @(self.view.center.y);
    
    CABasicAnimation *anim2 = [CABasicAnimation animation];
    anim2.keyPath = @"transform.rotation";
    anim2.toValue = @(angle(0));
    
    group.animations = @[anim1,anim2];
    group.duration = 0.7;
    
    group.delegate = self;
    
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeBoth;
    
    [self.alertView.layer addAnimation:group forKey:AnimationShow];
}

- (void)HideAnimation
{
    if (!self.alertView) {
        return;
    }
    CAAnimationGroup *group = [CAAnimationGroup animation];
    
    CABasicAnimation *anim1 = [CABasicAnimation animation];
    anim1.keyPath = @"position.y";
    anim1.toValue = @(self.view.frame.size.height+self.alertView.frame.size.height);
    
    CABasicAnimation *anim2 = [CABasicAnimation animation];
    anim2.keyPath = @"transform.rotation";
    anim2.byValue = @(angle(-30));
    
    group.animations = @[anim1,anim2];
    group.duration = 0.7;
    
    group.delegate = self;
    
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeBoth;
    
    [self.alertView.layer addAnimation:group forKey:AnimationHide];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    CAAnimation *animShow = [self.alertView.layer animationForKey:AnimationShow];
    CAAnimation *animHide = [self.alertView.layer animationForKey:AnimationHide];
    if (anim == animShow) {
        self.alertView.center = self.view.center;
        self.alertView.transform = CGAffineTransformMakeRotation(angle(0));
        if (flag) {
            [self.alertView.layer removeAnimationForKey:AnimationShow];
        }
    }else if (anim == animHide){
        CGRect rect = self.alertView.frame;
        rect.origin.y = self.view.frame.size.height;
        self.alertView.frame = rect;
        self.alertView.transform = CGAffineTransformMakeRotation(angle(-30));
        if (flag) {
            [self.alertView.layer removeAnimationForKey:AnimationHide];
            [self.alertView removeFromSuperview];
            [self.backView removeFromSuperview];
        }
    }
}


@end
