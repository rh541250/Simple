//
//  ViewController.m
//  masaike
//
//  Created by ZJF on 16/8/16.
//  Copyright © 2016年 ZJF. All rights reserved.
//

#define kScreenWidth     [UIScreen mainScreen].bounds.size.width

static CGFloat SIMImageEditToolBarHeight = 44.0;

#import "SIMImageViewEditViewController.h"
#import "SIMEditImageView.h"
#import "SIMEditImageToolView.h"
#import "SIMScreenShotManager.h"
#import "UIImage+mosaic.h"

@interface SIMImageViewEditViewController ()
{
    SIMEditImageView *m_editImageView;
}
@end

@implementation SIMImageViewEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self createImageEditImageView];
    [self createImageEditToolBar];
    
    UIView *toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44)];
    toolBar.backgroundColor = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:toolBar];
    
    UIButton *clearBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 7,60, 30)];
    [clearBtn setTitle:@"清空" forState:UIControlStateNormal];
    clearBtn.backgroundColor = [UIColor redColor];
    [clearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clearBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [clearBtn addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:clearBtn];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(clearBtn.frame) +20, 7,60, 30)];
    [backBtn setTitle:@"后退一步" forState:UIControlStateNormal];
    backBtn.backgroundColor = [UIColor redColor];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:backBtn];
    
    UIButton *redLineButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(backBtn.frame) + 20, 7,60, 30)];
    [redLineButton setTitle:@"画红线" forState:UIControlStateNormal];
    redLineButton.backgroundColor = [UIColor redColor];
    [redLineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [redLineButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [redLineButton addTarget:self action:@selector(toolButtonDidClick:)
            forControlEvents:UIControlEventTouchUpInside];
    redLineButton.tag = SIMImageEditToolLine;
    [toolBar addSubview:redLineButton];
    
    UIButton *masicButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(redLineButton.frame) + 20, 7,60, 30)];
    [masicButton setTitle:@"画马赛克" forState:UIControlStateNormal];
    masicButton.backgroundColor = [UIColor redColor];
    [masicButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [masicButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [masicButton addTarget:self action:@selector(toolButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    masicButton.tag = SIMImageEditToolMasic;
    [toolBar addSubview:masicButton];
}

- (void)createImageEditImageView
{
    m_editImageView = [[SIMEditImageView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64 - SIMImageEditToolBarHeight)];
    UIImage * image = [[SIMScreenShotManager sharedScreenShotManager] screenShotImage];
    
    //顶部原始图
    m_editImageView.surfaceImage = image;
    //马赛克图
    m_editImageView.image = [UIImage transToMosaicImage:image blockLevel:kScreenWidth/20];
    [self.view addSubview:m_editImageView];
}

- (void)createImageEditToolBar
{
    NSMutableArray *modelsArr = [NSMutableArray arrayWithCapacity:toolsNum];
    for (int i = 0 ; i < toolsNum; i++) {
        static SIMEditImageToolType toolType = 0;
        static NSString *toolTitle = nil;
        static NSString *toolImageName = nil;
        if (i == 0)
        {
            toolType = SIMEditImageToolTypeClear;
            toolTitle = @"全部清除";
            toolImageName = @"edit_image_tool_clear";
        }
        else if(i == 1)
        {
            toolType = SIMEditImageToolTypeBack;
            toolTitle = @"后退一步";
            toolImageName = @"edit_image_tool_back";
        }
        else if(i == 2)
        {
            toolType = SIMEditImageToolTypeLine;
            toolTitle = @"圈出问题";
            toolImageName = @"edit_image_tool_line";
        }
        else if(i == 3)
        {
            toolType = SIMEditImageToolTypeMosaic;
            toolTitle = @"马赛克";
            toolImageName = @"edit_image_tool_mosaic";
        }
        else
        {}
        
        SIMEditImageToolModel *model = [[SIMEditImageToolModel alloc]initWithToolType:toolType toolTitle:toolTitle andToolImageName:toolImageName];
        [modelsArr addObject:model];
    }
    
    
    SIMEditImageToolView *toolView = [[SIMEditImageToolView alloc]initWithToolModels:modelsArr];
//    SIMEditImageToolView *toolView = [[SIMEditImageToolView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44)];
    toolView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:toolView];
}


- (void)back:(UIButton *)btn
{
//    [_hys touchBack];
}

- (void)clear:(UIButton *)btn
{
//    [_hys touchClear];
}

- (void)toolButtonDidClick:(UIButton *)btn
{
//    _hys.currentEditTool = btn.tag;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
