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
//    [self initView];
    [self GCDTest];    
}
- (void)GCDTest
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_async(group, queue, ^{
        for (NSInteger i = 0; i < 3; i++) {
            NSLog(@"group-01 - %@", [NSThread currentThread]);
        }
    });
    dispatch_group_async(group, dispatch_get_main_queue(), ^{
        for (NSInteger i = 0; i < 8; i++) {
            NSLog(@"group-02 - %@", [NSThread currentThread]);
        }
    });
    dispatch_group_async(group, queue, ^{
        for (NSInteger i = 0; i < 5; i++) {
            NSLog(@"group-03 - %@", [NSThread currentThread]);
        }
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"完成- %@",[NSThread currentThread]);
    });
    
}

- (void)initView
{
    [self alertViewShow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
