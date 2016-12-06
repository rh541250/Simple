//
//  SIMScreenShotViewController.m
//  Simple
//
//  Created by renhong on 16/9/19.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "SIMScreenShotViewController.h"
#import "SIMScreenShotTool.h"
#import "SIMImageViewEditViewController.h"

@interface SIMScreenShotViewController ()
{
    UIImageView *backgroundImageView;
    SIMScreenShotTool *m_screenShotTool;
}
@end

@implementation SIMScreenShotViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    [self initData];
}

- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"p2.jpg"]];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:backgroundImageView];
    
    WS(ws);
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(ws.view).offset(0);
        make.size.mas_equalTo(ws.view.bounds.size);
    }];
}

- (void)initData
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(screenShotDidTaken:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

- (void)screenShotDidTaken:(NSNotification *)notification
{
    m_screenShotTool = [SIMScreenShotTool handleScreenShotWithViewController:self];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

@end
