//
//  CACustomViewController.m
//  Simple
//
//  Created by ehsy on 16/6/23.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "CACustomViewController.h"
#import "UIViewController+AnimateAlertView.h"


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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
