//
//  ViewController.h
//  masaike
//
//  Created by ZJF on 16/8/16.
//  Copyright © 2016年 ZJF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIMImageViewEditViewController : UIViewController

- (instancetype)initWithImage:(UIImage *)image;

@end

@interface UIImage (mosaic)

/**
 * 对image做马赛克处理
 * @return 马赛克图片
 * @param originImage 原始图片
 * @param level       马赛克化程度
 */
+ (UIImage *)transToMosaicImage:(UIImage*)originImage blockLevel:(NSUInteger)level;

@end

@interface UIView (snapshot)

/**
 * 从当前的UIView中获取image，类似于截屏
 */
- (UIImage *)snapshot;

@end
