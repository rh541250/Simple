//
//  UIImage+Tools.h
//  Simple
//
//  Created by ehsy on 16/4/28.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,SvResizeMode){
    SvResizeModeScale,      //只填充，不管形变
    SvResizeModeAspectFit,  //按比例填充，不裁剪
    SvResizeModeAspectFill  //按比例填充，进行裁剪
};


@interface UIImage (Tools)

#pragma - mark 图片缩放
- (UIImage *)resizeImageToSize:(CGSize)newSize resizeMode:(SvResizeMode)resizeMode;


#pragma - mark 图片裁剪
- (UIImage *)cropImageWithRect:(CGRect)cropRect;

@end
