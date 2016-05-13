//
//  NavViewController.m
//  Simple
//
//  Created by ehsy on 16/4/29.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "SIMMainViewController.h"
#import "SIMItem.h"
#import "ViewController.h"
#import "MasonryAnimateViewController.h"
#import "CGViewController.h"
#import "CAViewController.h"

#define NAVBAR_CHANGE_POINT 50

@interface SIMMainViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    UITableView *simTableView;
    
    NSMutableArray *dataArr;
}
@end

@implementation SIMMainViewController
static  NSString *SIMTableViewCellIdentify = @"SIMTableViewCellIdentify";


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initViews];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)initData
{
    dataArr = [NSMutableArray arrayWithCapacity:5];
    
    SIMItem *item = [SIMItem new];
    item.name = @"masonry基础";
    item.VCName = @"ViewController";
    [dataArr addObject:item];
    
    item = [SIMItem new];
    item.name = @"masonry动画";
    item.VCName = @"MasonryAnimateViewController";
    [dataArr addObject:item];
    
    item = [SIMItem new];
    item.name = @"绘图";
    item.VCName = @"CGViewController";
    [dataArr addObject:item];
    
    item = [SIMItem new];
    item.name = @"动画";
    item.VCName = @"CAViewController";
    [dataArr addObject:item];
}

- (void)initViews
{
//    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    
    self.title = @"MainVC";
    
    simTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    simTableView.delegate = self;
    simTableView.dataSource = self;
    simTableView.tableFooterView = [UIView new];
    simTableView.rowHeight = 44.0;
    [self.view addSubview:simTableView];
    
    WS(ws);
    [simTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(ws.view.bounds.size);
        make.top.equalTo(ws.view).with.offset(0);
        make.left.equalTo(ws.view).with.offset(0);
    }];
}

#pragma  - mark tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SIMTableViewCellIdentify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SIMTableViewCellIdentify];
        cell.backgroundColor = [UIColor whiteColor];
    }
    SIMItem *item = dataArr[indexPath.row];
    cell.textLabel.text = item.name;
    return cell;
}

#pragma - mark tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SIMItem *item = dataArr[indexPath.row];
    if (item.VCName) {
        UIViewController *vc = [[NSClassFromString(item.VCName) alloc] init];
        vc.navigationItem.title = item.name;
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma - mark - scrollView delegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    UIColor *color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
//    CGFloat offset = scrollView.contentOffset.y;
//    if (offset > 0) {
//        CGFloat alpha = 1 - (64-offset)/64;
//        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
//    }else{
//        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
//    }
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
