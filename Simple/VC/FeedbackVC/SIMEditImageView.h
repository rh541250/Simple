//
//  HYScratchCardView.h
//  Test
//
//  Created by Shadow on 14-5-23.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIMImageEditDefine.h"

extern NSString *const SIMEditTouchEndNotification;

@class SIMEditToolTypeItem;
typedef void(^EditBlock)(BOOL);
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
@property (nonatomic, assign)SIMEditImageToolType currentEditTool;

@property (nonatomic,   copy)EditBlock editBlock;

- (void)touchBack;

- (void)touchClear;

@end


@interface SIMEditToolTypeItem : NSObject
@property (nonatomic)SIMEditImageToolType toolType;
@end

@interface SIMEditPathItem : NSObject
@property (nonatomic, assign) CGMutablePathRef path;

@end


