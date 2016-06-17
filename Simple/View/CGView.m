//
//  CGView.m
//  Simple
//
//  Created by ehsy on 16/5/3.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "CGView.h"

@implementation CGView


+(Class)layerClass
{
    return [CAShapeLayer class];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self layoutViews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutViews
{
    self.path = [[UIBezierPath alloc]init];
    
    CAShapeLayer *layer = (CAShapeLayer *)self.layer;
    layer.strokeColor = [UIColor redColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineJoin = kCALineJoinRound;
    layer.lineCap = kCALineCapRound;
    layer.lineWidth = 5.0;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    
    [self.path moveToPoint:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    [self.path addLineToPoint:point];
    
    ((CAShapeLayer *)self.layer).path = self.path.CGPath;
}

@end
