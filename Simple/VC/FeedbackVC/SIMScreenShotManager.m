//
//  SIMScreenShotManager.m
//  Simple
//
//  Created by renhong on 16/9/20.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "SIMScreenShotManager.h"
@interface SIMScreenShotManager ()
{
    BOOL m_isAlerting;//提示框正在显示
    UIImage *m_screenShotImage;
    UIView *m_containerView;
}

@end

@implementation SIMScreenShotManager

+(instancetype)sharedScreenShotManager
{
    static SIMScreenShotManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


- (void)handleScreenShot:(NSNotification *)notification
{
    NSLog(@"检测到截屏");
    //人为截屏, 模拟用户截屏行为, 获取所截图片
    m_screenShotImage = [self imageWithScreenshot];
    [self createTipsViewWithImage:m_screenShotImage];
}

- (UIImage *)screenShotImage
{
    return m_screenShotImage;
}

#pragma mark - private method
/**
 *  返回截取到的图片
 *
 *  @return UIImage *
 */
- (UIImage *)imageWithScreenshot
{
    NSData *imageData = [self dataWithScreenshotInPNGFormat];
    return [UIImage imageWithData:imageData];
}

/**
 *  截取当前屏幕
 *
 *  @return NSData *
 */
- (NSData *)dataWithScreenshotInPNGFormat
{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImageJPEGRepresentation(image,0.1);
}


- (void)createTipsViewWithImage:(UIImage *)image
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    m_containerView = [[UIView alloc]initWithFrame:CGRectMake(window.frame.size.width - 100, window.frame.size.height/2 - 90, 100, 180)];
    m_containerView.layer.cornerRadius = 2.0;
    m_containerView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    
    //添加显示
    UIImageView *imgvPhoto = [[UIImageView alloc]initWithImage:image];
    imgvPhoto.frame = CGRectMake(4, 4, 100 - 8, 100 - 8);
    imgvPhoto.contentMode = UIViewContentModeScaleAspectFill;
    imgvPhoto.clipsToBounds = YES;
    [m_containerView addSubview:imgvPhoto];
    
    UIButton *adviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    adviceButton.frame = CGRectMake(4, CGRectGetMaxY(imgvPhoto.frame) + 4, 100 - 8, 40);
    [adviceButton setTitle:@"咨询建议" forState:UIControlStateNormal];
    [adviceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    adviceButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [adviceButton addTarget:self action:@selector(pushToImageViewEdit:) forControlEvents:UIControlEventTouchUpInside];
    [m_containerView addSubview:adviceButton];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(4, CGRectGetMaxY(adviceButton.frame) + 4, 100 - 8, 40);
    [shareButton setTitle:@"反馈" forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shareButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [m_containerView addSubview:shareButton];
    
    [window addSubview:m_containerView];
}

- (void)pushToImageViewEdit:(UIButton *)sender
{
    [m_containerView removeFromSuperview];
    if (self.pushToEditVCBlock) {
        self.pushToEditVCBlock();
    }
}

@end
