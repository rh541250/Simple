//
//  SIMScreenShotOverLayView.m
//  Simple
//
//  Created by hong.ren on 2016/12/5.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "SIMScreenShotOverLayView.h"
@interface SIMScreenShotOverLayView()
{
    __weak id<SIMScreenShotOperationProtocol> m_delegate;
}
@end

@implementation SIMScreenShotOverLayView
@synthesize delegate = m_delegate;

- (instancetype)initWithScreenShotImage:(UIImage *)screenShotImage
{
    self = [super init];
    if (self)
    {
        [self createViewsWithImage:screenShotImage];
    }
    return self;
}

- (void)createViewsWithImage:(UIImage *)image
{    
    self.frame = CGRectMake(0,0, 100, 180);
    self.layer.cornerRadius = 2.0;
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    
    //截图imageView
    UIImageView *photoImageView = [[UIImageView alloc]initWithImage:image];
    photoImageView.frame = CGRectMake(4, 4, 100 - 8, 100 - 8);
    photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    photoImageView.clipsToBounds = YES;
    [self addSubview:photoImageView];
    
    UIButton *adviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    adviceButton.frame = CGRectMake(4, CGRectGetMaxY(photoImageView.frame) + 4, 100 - 8, 40);
    [adviceButton setTitle:@"反馈" forState:UIControlStateNormal];
    [adviceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    adviceButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [adviceButton addTarget:self action:@selector(feedback:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:adviceButton];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(4, CGRectGetMaxY(adviceButton.frame) + 4, 100 - 8, 40);
    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shareButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:shareButton];
}

- (void)feedback:(UIButton *)sender
{
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(screenShotShouldFeedback)])
    {
        [self.delegate screenShotShouldFeedback];
    }
}

- (void)share:(UIButton *)sender
{
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(screenShotShouldShare)])
    {
        [self.delegate screenShotShouldShare];
    }
}

@end
