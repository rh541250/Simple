//
//  SIMScreenShotManager.m
//  Simple
//
//  Created by renhong on 16/9/20.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "SIMScreenShotTool.h"
#import "SIMImageEditDefine.h"

@interface SIMScreenShotTool ()
{
    UIImage *m_screenShotImage;
}

@end

@implementation SIMScreenShotTool
@synthesize screenShotImage = m_screenShotImage;
- (void)handleScreenShot:(NSNotification *)notification
{
    NSLog(@"检测到截屏");
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        m_screenShotImage = [self imageFromScreenshot];
//        dispatch_async(dispatch_get_main_queue(), ^{
        [self createOverlayerViewWithImage:m_screenShotImage];
//        });
//    });
}

#pragma mark - private method

/**
 *  截取当前屏幕
 *
 *  @return UIImage
 */
- (UIImage *)imageFromScreenshot
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


- (void)createOverlayerViewWithImage:(UIImage *)image
{
    [self removeOverLayerView];

    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *overLayerView = [[UIView alloc]initWithFrame:CGRectMake(window.frame.size.width - 100, window.frame.size.height/2 - 90, 100, 180)];
    overLayerView.layer.cornerRadius = 2.0;
    overLayerView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    
    //截图imageView
    UIImageView *photoImageView = [[UIImageView alloc]initWithImage:image];
    photoImageView.frame = CGRectMake(4, 4, 100 - 8, 100 - 8);
    photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    photoImageView.clipsToBounds = YES;
    [overLayerView addSubview:photoImageView];
    
    UIButton *adviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    adviceButton.frame = CGRectMake(4, CGRectGetMaxY(photoImageView.frame) + 4, 100 - 8, 40);
    [adviceButton setTitle:@"咨询建议" forState:UIControlStateNormal];
    [adviceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    adviceButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [adviceButton addTarget:self action:@selector(pushToImageViewEdit:) forControlEvents:UIControlEventTouchUpInside];
    [overLayerView addSubview:adviceButton];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(4, CGRectGetMaxY(adviceButton.frame) + 4, 100 - 8, 40);
    [shareButton setTitle:@"反馈" forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shareButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [overLayerView addSubview:shareButton];
    
    overLayerView.tag = SIMViewTagOverLayer;
    [window addSubview:overLayerView];
}

- (void)pushToImageViewEdit:(UIButton *)sender
{
    [self removeOverLayerView];
    if(self.pushToEditVCBlock && nil != m_screenShotImage)
    {
        self.pushToEditVCBlock(m_screenShotImage);
    }
}

- (void)dealloc
{
    [self removeOverLayerView];
}

- (void)removeOverLayerView
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *overLayerView = [window viewWithTag:SIMViewTagOverLayer];
    [overLayerView removeFromSuperview];
}

@end
