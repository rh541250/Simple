//
//  MasonryAnimateViewController.m
//  Simple
//
//  Created by ehsy on 16/4/26.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "MasonryAnimateViewController.h"

@interface MasonryAnimateViewController ()

@end

@implementation MasonryAnimateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    
    UIView *subView = [UIView new];
    subView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:subView];
    
    WS(ws);
    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).with.offset(100);
        make.left.equalTo(ws.view).with.offset(50);
        make.right.equalTo(ws.view).with.offset(-50);
        make.height.equalTo(@1);
    }];
    
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:3.0 animations:^{
       [subView mas_updateConstraints:^(MASConstraintMaker *make) {
           make.height.equalTo(@300);
       }];
        
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
