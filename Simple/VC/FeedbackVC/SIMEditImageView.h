//
//  HYScratchCardView.h
//  Test
//
//  Created by Shadow on 14-5-23.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString *const SIMEditTouchEndNotification;

/**
 * 绘图工具枚举
 */
typedef NS_ENUM(NSUInteger,SIMImageEditTool)
{
    SIMImageEditToolMasic   = 1000,//画马赛克
    SIMImageEditToolLine,          //画路径
};

@class SIMEditToolTypeItem;
@interface SIMEditImageView : UIView
/**
 要刮的底图.
 */
@property (nonatomic, strong) UIImage *image;
/**
 涂层图片.
 */
@property (nonatomic, strong) UIImage *surfaceImage;

/**
 * 当前选定的绘图工具
 */
@property (nonatomic, assign)SIMImageEditTool currentEditTool;

- (void)touchBack;

- (void)touchClear;

@end


@interface SIMEditToolTypeItem : NSObject
@property (nonatomic)SIMImageEditTool toolType;
@end

@interface SIMEditPathItem : NSObject
@property (nonatomic, assign) CGMutablePathRef path;

@end


