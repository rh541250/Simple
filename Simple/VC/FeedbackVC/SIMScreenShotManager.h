//
//  SIMScreenShotManager.h
//  Simple
//
//  Created by renhong on 16/9/20.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PushToEditVCBlock)(void);

@interface SIMScreenShotManager : NSObject
@property (nonatomic,copy)PushToEditVCBlock pushToEditVCBlock;

+(SIMScreenShotManager *)sharedScreenShotManager;

- (void)handleScreenShot:(NSNotification *)notification;

- (UIImage *)screenShotImage;

@end
