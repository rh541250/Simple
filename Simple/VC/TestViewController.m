//
//  TestViewController.m
//  Simple
//
//  Created by Tim on 16/11/14.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "TestViewController.h"

static NSInteger sectionTag = 10001;

@interface PlaceMode :NSObject
@property (nonatomic,copy)NSString *placeAddress;
@property (nonatomic,copy)NSString *layerNum;//楼层
@property (nonatomic,copy)NSString *unitNum;//单元号
@property (nonatomic,copy)NSString *placeName;
@end

@implementation PlaceMode

- (NSString *)placeAddress
{
    return [NSString stringWithFormat:@"%@ | %@",self.layerNum,self.unitNum];
}

@end

@interface TestViewController ()
{
    NSMutableArray *dataArr;
    NSMutableArray *rowOfSectionArr;
    NSMutableArray *openedInSectionArr;
    UITableView *tbView;
}
@end

@interface TestTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView *leftImageView;
@property (nonatomic,strong)UILabel *titleLB;
@property (nonatomic,strong)UILabel *nameLB;

@end
@implementation TestTableViewCell

@end

@implementation TestViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initTableView];
}

- (void)initData
{
    dataArr = [NSMutableArray array];

    NSMutableArray *arr = [NSMutableArray array];
    PlaceMode *place = [[PlaceMode alloc]init];
    place.layerNum = @"一楼";
    place.unitNum = @"A03";
    place.placeName = @"消防局";
    [arr addObject:place];
    
    place = [[PlaceMode alloc]init];
    place.layerNum = @"一楼";
    place.unitNum = @"A03";
    place.placeName = @"驾驶室训练场";
    [arr addObject:place];
    
    place = [[PlaceMode alloc]init];
    place.layerNum = @"二楼";
    place.unitNum = @"B03";
    place.placeName = @"立秀宝航空公司";
    [arr addObject:place];
    
    place = [[PlaceMode alloc]init];
    place.layerNum = @"一楼";
    place.unitNum = @"A03";
    place.placeName = @"立秀宝博物馆";
    [arr addObject:place];
    
    place = [[PlaceMode alloc]init];
    place.layerNum = @"一楼";
    place.unitNum = @"A03";
    place.placeName = @"消防局";
    [arr addObject:place];
    
    place = [[PlaceMode alloc]init];
    place.layerNum = @"一楼";
    place.unitNum = @"A03";
    place.placeName = @"立秀宝博物馆";
    [arr addObject:place];
    
    [dataArr addObject:arr];
    
    //    每个section中的row个数
    rowOfSectionArr = [[NSMutableArray alloc] initWithObjects:@"6", nil];
    //    每个section展开收起状态标识符
    openedInSectionArr = [[NSMutableArray alloc] initWithObjects:@"1",nil];
}

- (void)initTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    tbView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.tableFooterView = [UIView new];
    tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:tbView];
}

- (UIView *)createSectionHeaderViewWithSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tbView.frame.size.width, 30)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = view.bounds;
    [btn setTitle:@"向下" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(upOrDown:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = section + sectionTag;
    [view addSubview:btn];
    return view;
}

- (void)upOrDown:(UIButton *)sender
{
    if ([[openedInSectionArr objectAtIndex:sender.tag - sectionTag] intValue] == 0) {
        [openedInSectionArr replaceObjectAtIndex:sender.tag - sectionTag withObject:@"1"];
        [sender setTitle:@"向下" forState:UIControlStateNormal];
        
        [UIView transitionWithView:tbView
                          duration:0.4f
                           options:UIViewAnimationOptionCurveEaseInOut animations:^{
                               tbView.frame = CGRectMake(0,64, self.view.frame.size.width, self.view.frame.size.height);
                           } completion:^(BOOL finished) {
                               tbView.frame = CGRectMake(0,64, self.view.frame.size.width, self.view.frame.size.height);
                           }];
    }
    else
    {
        [openedInSectionArr replaceObjectAtIndex:sender.tag - sectionTag withObject:@"0"];
        [sender setTitle:@"向上" forState:UIControlStateNormal];

        CGRect rt = tbView.frame;
        //留2个
        NSUInteger showRowNum = [[rowOfSectionArr objectAtIndex:0] intValue] > 1 ?2:1;
        
        CGFloat height = showRowNum * 44.0 + 30.0;
        
        [UIView transitionWithView:tbView
                          duration:0.4f
                           options:UIViewAnimationOptionCurveEaseInOut animations:^{
                               tbView.frame = CGRectMake(0,rt.size.height - height, rt.size.width, height);
                           } completion:^(BOOL finished) {
                               tbView.frame = CGRectMake(0,rt.size.height - height, rt.size.width, height);
                           }];
    }
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[rowOfSectionArr objectAtIndex:section] intValue];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self createSectionHeaderViewWithSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TestTableViewCellIdentifier";
    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[TestTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        if (indexPath.section < [dataArr[indexPath.section] count])
        {
            PlaceMode *pm = [dataArr[indexPath.section] objectAtIndex:indexPath.row];
            cell.leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 80, 24)];
            cell.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 3, 60, 18)];
            
            cell.titleLB.font = [UIFont systemFontOfSize:12.0];
            cell.titleLB.text = pm.placeAddress;
            cell.titleLB.backgroundColor = [UIColor clearColor];
            cell.titleLB.textColor = [UIColor whiteColor];
            cell.titleLB.lineBreakMode = NSLineBreakByTruncatingTail;
            
            [cell.leftImageView addSubview:cell.titleLB];
            cell.leftImageView.layer.cornerRadius = cell.leftImageView.frame.size.height / 2.0;
            cell.leftImageView.backgroundColor = [UIColor blueColor];
            [cell.contentView addSubview:cell.leftImageView];
            
            cell.nameLB= [[UILabel alloc]initWithFrame:CGRectMake(110, 12, tableView.frame.size.width - 100, 20)];
            cell.nameLB.font = [UIFont systemFontOfSize:14.0];
            cell.nameLB.text = pm.placeName;
            [cell.contentView addSubview:cell.nameLB];
            return cell;
        }
    }
    if (indexPath.section < [dataArr[indexPath.section] count])
    {
        PlaceMode *pm = [dataArr[indexPath.section] objectAtIndex:indexPath.row];
        cell.titleLB.text = pm.placeAddress;
        cell.nameLB.text = pm.placeName;
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"12345");
}

@end


