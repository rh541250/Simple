//
//  UIImage+Rotate.h
//  Simple
//
//  Created by ehsy on 16/4/28.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  NS_ENUM(NSInteger,SvCropMode) {
    SvCropModeClip,
    SvCropModeExpand
};


@interface UIImage (Rotate)

- (UIImage *)rotateImageWithRadian:(CGFloat)radian cropMode:(SvCropMode)cropMode;


@end
