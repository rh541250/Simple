//
//  SIMScreenShotManager.h
//  Simple
//
//  Created by renhong on 16/9/20.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PushToEditVCBlock)(UIImage *);

@interface SIMScreenShotTool : NSObject
@property (nonatomic,strong)UIImage *screenShotImage;
@property (nonatomic,copy)PushToEditVCBlock pushToEditVCBlock;

//处理截屏通知
- (void)handleScreenShot:(NSNotification *)notification;

@end
