//
//  NavViewController.m
//  Simple
//
//  Created by ehsy on 16/4/29.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "SIMMainViewController.h"
#import "SIMItem.h"
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
    [dataArr addObject:item];
    
    item = [SIMItem new];
    item.name = @"masonry动画";
    [dataArr addObject:item];
}

- (void)initViews
{
    simTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    simTableView.delegate = self;
    simTableView.dataSource = self;
    simTableView.tableFooterView = [UIView new];
    simTableView.rowHeight = 40.0;
    [self.view addSubview:simTableView];
    
    WS(ws);
    [simTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(ScreenWidth));
        make.height.equalTo(@(ScreenHeight));
        make.left.equalTo(ws.view).offset(0);
        make.top.equalTo(ws.view).offset(0);
    }];
    
}


#pragma  - mark tableView delegate
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    SIMItem *item = dataArr[indexPath.row];
    cell.textLabel.text = item.name;
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
