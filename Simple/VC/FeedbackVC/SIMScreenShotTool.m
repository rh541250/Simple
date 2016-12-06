//
//  SIMScreenShotManager.m
//  Simple
//
//  Created by renhong on 16/9/20.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "SIMScreenShotTool.h"
#import "SIMImageEditDefine.h"
#import "SIMScreenShotOverLayView.h"
#import "SIMImageViewEditViewController.h"

@interface SIMScreenShotTool ()<SIMScreenShotOperationProtocol>
{
    UIImage *m_screenShotImage;
    __weak UIViewController *m_weakViewController;
}

@end

@implementation SIMScreenShotTool
+ (instancetype)handleScreenShotWithViewController:(UIViewController *)vc
{
    SIMScreenShotTool *m_screenShotTool = [[SIMScreenShotTool alloc]initWithViewController:vc];
    return m_screenShotTool;
}

- (instancetype)initWithViewController:(UIViewController *)vc
{
    self = [super init];
    if (self)
    {
        m_weakViewController = vc;
        [self handleScreenShotWithViewController];
    }
    return self;
}

- (void)handleScreenShotWithViewController
{
    NSLog(@"检测到截屏");
    m_screenShotImage = [SIMScreenShotTool imageFromScreenshot];
    if (m_screenShotImage)
    {
        [self addOverLayView];
    }
}

#pragma mark - overLayView
- (void)addOverLayView
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    SIMScreenShotOverLayView *overLayView = [[SIMScreenShotOverLayView alloc]initWithScreenShotImage:m_screenShotImage];
    overLayView.frame = CGRectMake(window.frame.size.width - 100, window.frame.size.height/2 - 90, 100, 180);
    overLayView.delegate = self;
    overLayView.tag = SIMViewTagOverLayerTag;
    [window addSubview:overLayView];
}

- (void)removeOverLayerView
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *overLayerView = [window viewWithTag:SIMViewTagOverLayerTag];
    [overLayerView removeFromSuperview];
}

- (void)dealloc
{
    [self removeOverLayerView];
}

#pragma mark - overlayView delegate
- (void)screenShotShouldFeedback
{
    [self removeOverLayerView];
    if (nil != m_weakViewController)
    {
        SIMImageViewEditViewController *imageViewEditVC = [[SIMImageViewEditViewController alloc] initWithImage:m_screenShotImage];
        [m_weakViewController.navigationController pushViewController:imageViewEditVC animated:YES];
    }
}

- (void)screenShotShouldShare
{
    [self removeOverLayerView];
}

/**
 *  截取当前屏幕
 *
 *  @return UIImage
 */
+ (UIImage *)imageFromScreenshot
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
    
    NSData *imageData = UIImageJPEGRepresentation(image,0.1);
    return [UIImage imageWithData:imageData];
}

@end
