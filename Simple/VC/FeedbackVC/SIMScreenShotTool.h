//
//  SIMScreenShotManager.h
//  Simple
//
//  Created by renhong on 16/9/20.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SetImageBlock)(UIImage *image);
@interface SIMScreenShotTool : NSObject
@property (nonatomic,copy)SetImageBlock setImageBlock;
//处理截屏通知
+ (instancetype)handleScreenShotWithViewController:(UIViewController *)vc;

@end
