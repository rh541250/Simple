//
//  JSPatchTestViewController.m
//  Simple
//
//  Created by hong.ren on 2016/12/1.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "JSPatchTestViewController.h"
#import "CGViewController.h"

@interface JSPatchTestViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray *dataSource;
@end

@implementation JSPatchTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITableView* tv = [[UITableView alloc]initWithFrame:self.view.bounds
                                                  style:UITableViewStylePlain];
    tv.delegate = self;
    tv.dataSource = self;
    [self.view addSubview:tv];
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* i=  @"cell";
    UITableViewCell* cell = [tableView  dequeueReusableCellWithIdentifier:i];
    if (cell == nil ) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:i];
    }
    cell.textLabel.text = @"meiqing";
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 肯定会超出数组范围导致 crash
//    NSString *content = self.dataSource[indexPath.row];
    
}

- (NSArray *)dataSource
{
    return @[@"JSPatch", @"is"];
}
- (void)customMethod
{
    NSLog(@"callCustom method");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
