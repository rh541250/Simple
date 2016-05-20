//
//  CAAnimationViewController.m
//  Simple
//
//  Created by ehsy on 16/5/20.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "CAAnimationViewController.h"

@interface CAAnimationViewController ()
{
    CALayer *layer;
}

@end

@implementation CAAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layerOutViews];
}

- (void)layerOutViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    layer = [CALayer layer];
    layer.frame = CGRectMake(50, 100, 100, 100);
    layer.backgroundColor = [UIColor blueColor].CGColor;
    [self.view.layer addSublayer:layer];
    
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromLeft;
    layer.actions = @{@"backgroundColor":transition};
//
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"点击" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor cyanColor]];
    btn.frame = CGRectMake(50, 250, 50, 25);
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)clickBtn
{
//    [CATransaction begin];    
//    [CATransaction setAnimationDuration:1.0];
    
//    [CATransaction setCompletionBlock:^{
    
//        [CATransaction begin];
//        [CATransaction setAnimationDuration:1.0];
//        CGAffineTransform transform = layer.affineTransform;
//        transform = CGAffineTransformRotate(transform, M_PI_2);
//        layer.affineTransform =  transform;
//        [CATransaction commit];
//    }];
    
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
//    [CATransaction commit];
    
    CABasicAnimation *ani = [CABasicAnimation animation];
    ani.keyPath = @"backgroundColor";
    ani.toValue = (__bridge id)color.CGColor;
    ani.delegate = self;
    [layer addAnimation:ani forKey:nil];
}


- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    layer.backgroundColor = (__bridge CGColorRef)anim.toValue;
    [CATransaction commit];
    
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    CGPoint point = [[touches anyObject] locationInView:self.view];
//    if ([layer.presentationLayer hitTest:point]) {
//        CGFloat red = arc4random() / (CGFloat)INT_MAX;
//        CGFloat green = arc4random() / (CGFloat)INT_MAX;
//        CGFloat blue = arc4random() / (CGFloat)INT_MAX;
//        layer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
//    }else{
//        [CATransaction begin];
//        [CATransaction setAnimationDuration:4.0];
//        layer.position = point;
//        [CATransaction commit];
//    }
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
