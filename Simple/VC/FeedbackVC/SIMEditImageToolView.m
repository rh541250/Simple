//
//  SIMEditImageToolView.m
//  Simple
//
//  Created by hong.ren on 2016/10/28.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "SIMEditImageToolView.h"

@implementation SIMEditImageToolView

- (instancetype)initWithToolModels:(NSArray *)modelsArr
{
    self = [super init];
    if (self) {
        _toolArr = modelsArr;
        [self createToolViewsWithModels];
    }
    return self;
}

- (void)createToolViewsWithModels
{
    for (int i = 0; i < _toolArr.count; i++) {
        SIMEditImageToolModel *toolModel = _toolArr[i];
        UIButton *toolBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 7,60, 30)];
        [toolBtn setTitle:@"清空" forState:UIControlStateNormal];
        [toolBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [toolBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [toolBtn setTitleColor:[UIColor greenColor] forState:UIControlStateDisabled];
        
        [toolBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [toolBtn addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:toolBtn];
    }
}


@end

@implementation SIMEditImageToolModel
- (instancetype)initWithToolType:(SIMEditImageToolType)toolType toolTitle:(NSString *)toolTitle andToolImageName:(NSString *)toolImageName
{
    if (self = [super init]) {
        self.toolType = toolType;
        self.toolTitle = toolTitle;
        self.toolImageName = toolImageName;
    }
    return self;
}
@end

@implementation SIMEditImageToolButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


@end


