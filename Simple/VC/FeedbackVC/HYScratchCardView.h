//
//  HYScratchCardView.h
//  Test
//
//  Created by Shadow on 14-5-23.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger,CATool)
{
    CAToolLine = 1001,
    CAToolMasic,
};


@interface HYScratchCardView : UIView
/**
 要刮的底图.
 */
@property (nonatomic, strong) UIImage *image;
/**
 涂层图片.
 */
@property (nonatomic, strong) UIImage *surfaceImage;

@property (nonatomic) CATool catool;

- (void)back;

@end
