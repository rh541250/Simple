//
//  SIMNavigationController.m
//  Simple
//
//  Created by ehsy on 16/4/22.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "SIMNavigationController.h"

@interface SIMNavigationController ()

@end

@implementation SIMNavigationController


- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self navigationBarPearance];
    }
    return self;
}

#pragma - mark  praivate method
- (void)navigationBarPearance
{
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:21],NSFontAttributeName, nil]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
