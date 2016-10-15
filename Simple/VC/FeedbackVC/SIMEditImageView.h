//
//  HYScratchCardView.h
//  Test
//
//  Created by Shadow on 14-5-23.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString *const SIMEditTouchEndNotification;

typedef NS_ENUM(NSUInteger,SIMImageEditTool)
{
    SIMImageEditToolMasic   = 1000,
    SIMImageEditToolLine,
};

@interface SIMEditImageView : UIView
/**
 要刮的底图.
 */
@property (nonatomic, strong) UIImage *image;
/**
 涂层图片.
 */
@property (nonatomic, strong) UIImage *surfaceImage;

@property (nonatomic)SIMImageEditTool simImageEditTool;

- (void)touchBack;

- (void)touchEnd;

@end


@interface SIMEditPathItem : NSObject
@property (nonatomic, assign) CGMutablePathRef path;

@end
