//
//  CALayerViewController.m
//  Simple
//
//  Created by ehsy on 16/5/16.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "CALayerViewController.h"

@interface CALayerViewController ()<UITextFieldDelegate>

@end

@implementation CALayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutViews];
}

- (void)layoutViews
{
    self.view.backgroundColor = [UIColor grayColor];
    
    UIButton *btn1 = [self getBtn];
    btn1.center = CGPointMake(100, 150);
    [self.view addSubview:btn1];
    
    
    UIButton *btn2 = [self getBtn];
    btn2.center = CGPointMake(275, 150);
    [self.view addSubview:btn2];
    btn2.alpha = 0.5;
    
//    btn2.layer.shouldRasterize = YES;
//    btn2.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
}

- (UIButton *)getBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 150 ,50);
    btn.backgroundColor = [UIColor lightGrayColor];
    btn.layer.cornerRadius = 8.0;
    [self.view addSubview:btn];
    
    
    UILabel *lab = [[UILabel alloc]init];
    lab.frame = CGRectMake(20, 10, 110, 30);
    lab.text = @"hello";
    lab.backgroundColor = [UIColor whiteColor];
    lab.textAlignment = NSTextAlignmentCenter;
    [btn addSubview:lab];
    
    return btn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
