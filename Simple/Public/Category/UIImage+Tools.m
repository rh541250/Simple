//
//  UIImage+Tools.m
//  Simple
//
//  Created by ehsy on 16/4/28.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "UIImage+Tools.h"

@implementation UIImage (Tools)


#pragma - mark 图片缩放
- (UIImage *)resizeImageToSize:(CGSize)newSize resizeMode:(SvResizeMode)resizeMode
{
    CGRect rect = [self caculateDrawRect:newSize resizeMode:resizeMode];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, CGRectMake(0, 0, newSize.width, newSize.height));
    
    CGContextSetInterpolationQuality(context, 0.8);
    [self drawInRect:rect blendMode:kCGBlendModeNormal alpha:1];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


- (CGRect)caculateDrawRect:(CGSize)newSize resizeMode:(SvResizeMode)resieMode
{
    CGRect drawRect = CGRectMake(0, 0, newSize.width, newSize.height);
    
    CGFloat imageRatio = self.size.width / self.size.height;
    CGFloat newSizeRatio = newSize.width / newSize.height;
    
    
    switch (resieMode) {
        case SvResizeModeScale:
            
            break;
        case SvResizeModeAspectFit
            :{
                CGFloat newHeight = 0;
                CGFloat newWidth = 0;
                if(newSizeRatio >= imageRatio){
                    newHeight = newSize.height;
                    newWidth = newHeight * imageRatio;
                }else{
                    newWidth = newSize.width;
                    newHeight = newWidth / imageRatio;
                }
                drawRect.size.width = newWidth;
                drawRect.size.height = newHeight;
                
                drawRect.origin.x = newSize.width / 2 - newWidth / 2;
                drawRect.origin.y = newSize.height / 2 - newHeight / 2;
            
            }
            
            break;
        case SvResizeModeAspectFill:{
            CGFloat newHeight = 0;
            CGFloat newWidth = 0;
            if (newSizeRatio >= imageRatio) {
                newWidth = newSize.width;
                newHeight = newWidth / imageRatio;
            }else{
                newHeight = newSize.height;
                newWidth = newHeight * imageRatio;
            }
            drawRect.size.width = newWidth;
            drawRect.size.height = newHeight;
            
            drawRect.origin.x = newSize.width / 2 - newWidth / 2;
            drawRect.origin.y = newSize.height / 2 - newHeight / 2;
        }
            break;
        default:
            break;
    }
    return drawRect;
    
}


#pragma - mark 图片裁剪
- (UIImage *)cropImageWithRect:(CGRect)cropRect
{
    CGRect rect = CGRectMake(-cropRect.origin.x,-cropRect.origin.y , self.size.width * self.scale, self.size.height * self.scale);
    
    UIGraphicsBeginImageContext(cropRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, CGRectMake(0, 0, cropRect.size.width, cropRect.size.height));
    [self drawInRect:rect];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


#pragma  - mark 通过颜色绘纯色图
- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1,1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
