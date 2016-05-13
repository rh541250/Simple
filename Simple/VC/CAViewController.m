//
//  CAViewController.m
//  Simple
//
//  Created by ehsy on 16/5/11.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "CAViewController.h"

@interface CAViewController ()

@end

@implementation CAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self layoutViews];
    [self layoutLayers];
}

- (void)layoutViews
{
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIView *layerView = [[UIView alloc]init];
    layerView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:layerView];
    
    WS(ws);
    [layerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.view).with.offset(-100);
        make.centerX.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
    
    UIImage *image = [UIImage imageNamed:@"4"];
    layerView.layer.contents = (__bridge id _Nullable)(image.CGImage);
    layerView.layer.contentsScale = image.scale;
    layerView.layer.contentsCenter = CGRectMake(0, 0, 0.5, 0.5);
}


- (void)layoutLayers
{
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIView *layerView = [[UIView alloc]init];
    layerView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:layerView];
    
    WS(ws);
    [layerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.view).with.offset(-100);
        make.centerX.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
    
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50, 50, 100, 100);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    
    blueLayer.delegate = self;
    blueLayer.contentsScale = [UIScreen mainScreen].scale;
    [layerView.layer addSublayer:blueLayer];
    
    [blueLayer display];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    CGContextSetLineWidth(ctx, 10.0f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
