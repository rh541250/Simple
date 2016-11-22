//
//  TagViewController.m
//  Simple
//
//  Created by Tim on 16/11/14.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "TagViewController.h"

static CGFloat innerSpaceWidth = 25.0;
static CGFloat innerSpaceHeight = 10.0;
static CGFloat btnTitleFont = 13.0;

#define viewWidth self.view.frame.size.width

@interface ShopMode :NSObject
@property (nonatomic,copy)NSString *placeName;
@property (nonatomic,strong)NSMutableArray *arr;
@end

@implementation ShopMode


@end

@interface TagViewController ()
{
    NSMutableArray *dataArr;
    UITableView *tbView;
}
@end

@implementation TagViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initTableView];
}

- (void)initData
{
    dataArr = [NSMutableArray array];
    
    for (int i = 0; i < 2; i ++)
    {
        NSMutableArray *arr = [NSMutableArray array];
        
        NSString *place = @"咖啡店";
        [arr addObject:place];
        place = @"冰淇淋店";
        [arr addObject:place];
        place = @"冰淇淋店";
        [arr addObject:place];
        place = @"美食车";
        [arr addObject:place];
        place = @"面包店";
        [arr addObject:place];
        place = @"果汁店";
        [arr addObject:place];
        place = @"便利超市adf";
        [arr addObject:place];
        place = @"冰淇淋店fasdfasfd";
        [arr addObject:place];
        place = @"美食车dfasdf";
        [arr addObject:place];
        place = @"面包店";
        [arr addObject:place];
        place = @"果汁店dsfasdf";
        [arr addObject:place];
        place = @"果汁店dsfasdfdfsfDFASFFFS冰淇淋店fasdfasfd冰淇淋店fasdfasfd冰淇淋店fasdfasfd冰淇淋店fasdfasfd";
        [arr addObject:place];

        
        ShopMode *placeMode = [[ShopMode alloc]init];
        placeMode.arr = arr;
        placeMode.placeName = @"餐饮美食";
        [dataArr addObject:placeMode];
    }
}

- (void)initTableView
{
    tbView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.tableFooterView = [UIView new];
    tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tbView];
}

- (UIView *)createSectionHeaderViewWithSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tbView.frame.size.width, 30)];
    CGFloat centerContentViewWidth = 120.0;
    CGFloat centerContentViewHeight = view.frame.size.height;

    CGFloat lineViewWidth = (view.frame.size.width - centerContentViewWidth)/2.0;
    CGFloat lineViewHeight = 0.5;
    
    
    UIView *leftLine = [[UIView alloc]initWithFrame:CGRectMake(0, view.frame.size.height/ 2.0 - lineViewHeight,lineViewWidth,lineViewHeight)];
    leftLine.backgroundColor = [UIColor grayColor];
    [view addSubview:leftLine];
    
    UIView *centerContentView = [[UIView alloc]initWithFrame:CGRectMake(lineViewWidth, 0, centerContentViewWidth, centerContentViewHeight)];
    [view addSubview:centerContentView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 30, centerContentViewHeight)];
    imageView.backgroundColor = [UIColor redColor];
    [centerContentView addSubview:imageView];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, 0, centerContentViewWidth - CGRectGetMaxX(imageView.frame) - 10 - 20, centerContentViewHeight)];
    title.textAlignment = NSTextAlignmentCenter;
    title.lineBreakMode = NSLineBreakByTruncatingMiddle;
    title.font = [UIFont systemFontOfSize:12.0];
    
    if (section < dataArr.count) {
        ShopMode *pm = dataArr[section];
        title.text = pm.placeName;
    }
    [centerContentView addSubview:title];
    
    UIView *rightLine = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(centerContentView.frame), view.frame.size.height/ 2.0 - lineViewHeight,lineViewWidth,lineViewHeight)];
    rightLine.backgroundColor = [UIColor grayColor];
    [view addSubview:rightLine];
    
    return view;
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForSection:indexPath.section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self createSectionHeaderViewWithSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"tableCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section < [dataArr count]) {
        ShopMode *placeMode = dataArr[indexPath.section];

        NSArray *arr = placeMode.arr;
        
        for (int i = 0; i < [arr count]; i ++)
        {
            NSString *name = arr[i];
            static UIButton *recordBtn =nil;
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            btn.titleLabel.font = [UIFont systemFontOfSize:btnTitleFont];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            CGRect rect = [name boundingRectWithSize:CGSizeMake(viewWidth-20, 40) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:btn.titleLabel.font} context:nil];
            
            CGFloat btnWidth = MIN(rect.size.width + innerSpaceWidth, self.view.frame.size.width - 20);
            CGFloat btnHeight = 13.0 + innerSpaceHeight;
            if (i == 0)
            {
                btn.frame =CGRectMake(10, 10, btnWidth, btnHeight);
            }
            else{
                CGFloat yuWidth = viewWidth - 25-recordBtn.frame.origin.x -recordBtn.frame.size.width;
                if (yuWidth >= btnWidth) {
                    btn.frame =CGRectMake(recordBtn.frame.origin.x +recordBtn.frame.size.width + 10, recordBtn.frame.origin.y, btnWidth, btnHeight);
                }else{
                    btn.frame =CGRectMake(10, recordBtn.frame.origin.y+recordBtn.frame.size.height+10, btnWidth, btnHeight);
                }
            }
            btn.backgroundColor = [UIColor blueColor];
            btn.layer.cornerRadius = btn.frame.size.height / 2.0;
            [btn setTitle:name forState:UIControlStateNormal];
            [cell.contentView addSubview:btn];
            btn.tag = indexPath.section * 100 + indexPath.row;
            
            recordBtn = btn;
        }
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"12345");
}

- (CGFloat)heightForSection:(NSUInteger)section
{
        ShopMode *placeMode = dataArr[section];
        
        NSMutableArray *arr = placeMode.arr;
        NSUInteger hNum = 1;
        CGFloat btnHeight = 13.0 + innerSpaceHeight;

    
        for (int i = 0; i < [arr count]; i ++)
        {
            NSString *name = arr[i];
            static UIButton *recordBtn =nil;
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.titleLabel.font = [UIFont systemFontOfSize:btnTitleFont];
            CGRect rect = [name boundingRectWithSize:CGSizeMake(viewWidth-20, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:btn.titleLabel.font} context:nil];
            CGFloat btnWidth = MIN(rect.size.width + innerSpaceWidth, self.view.frame.size.width - 20);
            
            if (i == 0)
            {
                btn.frame =CGRectMake(10, 10, btnWidth, btnHeight);
            }
            else{
                CGFloat yuWidth = viewWidth - 25-recordBtn.frame.origin.x -recordBtn.frame.size.width - innerSpaceWidth;
                if (yuWidth >= btnWidth) {
                    btn.frame =CGRectMake(recordBtn.frame.origin.x +recordBtn.frame.size.width + 10, recordBtn.frame.origin.y, btnWidth, btnHeight);
                }else{
                    btn.frame =CGRectMake(10, recordBtn.frame.origin.y+recordBtn.frame.size.height+10, btnWidth, btnHeight);
                    hNum +=1;
                }
            }
            recordBtn = btn;
        }
    return hNum * btnHeight + ((hNum + 1) *10);
}
@end


