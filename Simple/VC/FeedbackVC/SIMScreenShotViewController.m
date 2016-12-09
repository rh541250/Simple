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
    UIImageView *m_backgroundImageView;
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
    m_backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"p2.jpg"]];
    m_backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:m_backgroundImageView];
    
    WS(ws);
    [m_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(ws.view).offset(0);
        make.top.equalTo(ws.view).offset(64);
        make.height.equalTo(ws.view).offset(-64);
    }];
}

- (void)initData
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(screenShotDidTaken:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

- (void)screenShotDidTaken:(NSNotification *)notification
{
    m_screenShotTool = [SIMScreenShotTool handleScreenShotWithViewController:self];
    __weak typeof(m_backgroundImageView)weakBackgroundImageView = m_backgroundImageView;
    m_screenShotTool.setImageBlock = ^(UIImage *image){
        weakBackgroundImageView.image = image;
    };
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

@end
