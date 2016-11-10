//
//  UIImage+mosaic.h
//  Simple
//
//  Created by hong.ren on 2016/10/28.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (mosaic)

/**
 * 对image做马赛克处理
 * @return 马赛克图片
 * @param originImage 原始图片
 * @param level       马赛克化程度
 */
+ (UIImage *)transToMosaicImage:(UIImage*)originImage blockLevel:(NSUInteger)level;

@end
