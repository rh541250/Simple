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
@interface SIMMainViewController ()<UITableViewDelegate,UITableViewDataSource>
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
}

- (void)initViews
{
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
