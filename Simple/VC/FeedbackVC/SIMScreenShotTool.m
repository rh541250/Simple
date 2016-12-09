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
#import <libkern/OSAtomic.h>

@interface SIMScreenShotTool ()<SIMScreenShotOperationProtocol>
{
    UIImage *m_screenShotImage;
    __weak UIViewController *m_weakViewController;
    UIWindow *m_window;
    dispatch_source_t m_timer;
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
        [self startTimer];
    }
}

#pragma mark - overLayView
- (void)addOverLayView
{
    m_window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    coverBtn.frame = m_window.bounds;
    coverBtn.backgroundColor = [UIColor clearColor];
    [coverBtn addTarget:self action:@selector(removeCustomWindow) forControlEvents:UIControlEventTouchUpInside];
    [m_window addSubview:coverBtn];
    
    SIMScreenShotOverLayView *overLayView = [[SIMScreenShotOverLayView alloc]initWithScreenShotImage:m_screenShotImage];
    overLayView.frame = CGRectMake(m_window.frame.size.width - 100, m_window.frame.size.height/2 - 90, 100, 180);
    overLayView.delegate = self;
    overLayView.tag = SIMViewTagOverLayerTag;
    [m_window addSubview:overLayView];
    [m_window makeKeyAndVisible];
}

- (void)startTimer
{
    __block int32_t timeOutCount = 5;
    m_timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    
    dispatch_source_set_timer(m_timer, DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(m_timer, ^{
        OSAtomicDecrement32(&timeOutCount);
        if (timeOutCount == 0)
        {
            dispatch_source_cancel(m_timer);
        }
    });
    
    dispatch_source_set_cancel_handler(m_timer, ^{
        [self removeCustomWindow];
    });
    
    dispatch_resume(m_timer);
}

- (void)removeCustomWindow
{
    [m_window resignKeyWindow];
    m_window = nil;
}

#pragma mark - overlayView delegate
- (void)screenShotShouldFeedback
{
    [self removeCustomWindow];
    if (nil != m_weakViewController)
    {
        SIMImageViewEditViewController *imageViewEditVC = [[SIMImageViewEditViewController alloc] initWithImage:m_screenShotImage];
        [m_weakViewController.navigationController pushViewController:imageViewEditVC animated:YES];
    }
}

- (void)screenShotShouldShare
{
    [self removeCustomWindow];
    
    if (nil != m_screenShotImage)
    {
        UIImage *shareImage = [SIMScreenShotTool imageForShare:m_screenShotImage];
        if (self.setImageBlock)
        {
            self.setImageBlock(shareImage);
        }
    }
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

+ (UIImage *)imageForShare:(UIImage *)image
{
    CGFloat scale = [UIScreen mainScreen].scale;
    UIImage *bgImage = [UIImage imageNamed:@"share_bg"];
    CGSize sz = CGSizeMake(bgImage.size.width * scale, bgImage.size.height *scale);
    
    UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
    [bgImage drawInRect:CGRectMake(0, 0, sz.width,sz.height)];
    
    [image drawInRect:CGRectMake(20*scale,0, sz.width - (20+18)*scale, sz.height - 100*scale)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

@end
