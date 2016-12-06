//
//  SIMMasicImageView.h
//  Simple
//
//  Created by hong.ren on 2016/10/24.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIMMasicImageView : UIImageView
/**
 涂层图片.
 */
@property (nonatomic, strong) UIImage *surfaceImage;


- (void)back;

- (void)clear;

- (void)addPathItem;

@end

@interface SIMMasicPathItem : NSObject
@property (nonatomic, assign) CGMutablePathRef path;

@end
