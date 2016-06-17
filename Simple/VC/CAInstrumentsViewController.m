//
//  CAInstrumentsViewController.m
//  Simple
//
//  Created by ehsy on 16/5/26.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "CAInstrumentsViewController.h"

@interface CAInstrumentsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tView;
    NSMutableArray *dataArr;
}

@end

@implementation CAInstrumentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self initData];
}


- (void)initViews
{
    //    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"MainVC";
    
    tView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tView.delegate = self;
    tView.dataSource = self;
    tView.tableFooterView = [UIView new];
    tView.rowHeight = 44.0;
    [self.view addSubview:tView];
    
    WS(ws);
    [tView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(ws.view.bounds.size);
        make.top.equalTo(ws.view).with.offset(0);
        make.left.equalTo(ws.view).with.offset(0);
    }];
}

- (void)initData
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 1000; i++) {
        //add name
        [array addObject:@{@"name": [self randomName], @"image": [self randomAvatar]}];
    }
    dataArr = array;
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
    static NSString * tableViewCellIdentify = @"tableViewCellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellIdentify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellIdentify];
//        cell.backgroundColor = [UIColor whiteColor];
    }
    
    NSDictionary *item = dataArr[indexPath.row];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:item[@"image"] ofType:@"png"];
    //set image and text
    cell.imageView.image = [UIImage imageWithContentsOfFile:filePath];
    cell.textLabel.text = item[@"name"];
    //set image shadow
    cell.imageView.layer.shadowOffset = CGSizeMake(0, 5);
    cell.imageView.layer.shadowOpacity = 0.75;
    cell.clipsToBounds = YES;
    //set text shadow
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.layer.shadowOffset = CGSizeMake(0, 2);
    cell.textLabel.layer.shadowOpacity = 0.5;
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    

    return cell;
}



- (NSString *)randomName
{
    NSArray *first = @[@"Alice", @"Bob", @"Bill", @"Charles", @"Dan", @"Dave", @"Ethan", @"Frank"];
    NSArray *last = @[@"Appleseed", @"Bandicoot", @"Caravan", @"Dabble", @"Ernest", @"Fortune"];
    NSUInteger index1 = (rand()/(double)INT_MAX) * [first count];
    NSUInteger index2 = (rand()/(double)INT_MAX) * [last count];
    return [NSString stringWithFormat:@"%@ %@", first[index1], last[index2]];
}

- (NSString *)randomAvatar
{
    NSArray *images = @[@"416", @"416", @"4", @"5", @"4", @"5"];
    NSUInteger index = (rand()/(double)INT_MAX) * [images count];
    return images[index];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
