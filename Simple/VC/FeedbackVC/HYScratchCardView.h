//
//  HYScratchCardView.h
//  Test
//
//  Created by Shadow on 14-5-23.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,SIMImageEditTool)
{
    SIMImageEditToolMasic   = 1000,
    SIMImageEditToolRedLine,
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



- (void)back;

- (void)setEditTool:(SIMImageEditTool)editTool;

@end


@interface HYPathItem : NSObject
@property (nonatomic, assign) CGMutablePathRef path;

@property (nonatomic, assign) SIMImageEditTool editTool;

@end