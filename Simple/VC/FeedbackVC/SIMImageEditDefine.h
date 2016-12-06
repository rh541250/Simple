//
//  SIMImageEditDefine.h
//  Simple
//
//  Created by hong.ren on 2016/11/22.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#ifndef SIMImageEditDefine_h
#define SIMImageEditDefine_h


static NSString * const SIMEditTouchEndNotification = @"SIMEditTouchEndNotificationKey";

/**
 * 绘图工具枚举
 */
typedef NS_ENUM(NSUInteger,SIMEditImageToolType)
{
    SIMEditImageToolTypeClear  = 0,
    SIMEditImageToolTypeBack   = 1,
    SIMEditImageToolTypeLine   = 2,
    SIMEditImageToolTypeMosaic = 3,
};

typedef NS_ENUM(NSUInteger,SIMViewTag)
{
    SIMViewTagOverLayerTag = 998,
    SIMViewTagQuestionViewTag = 1001,
};

#endif /* SIMImageEditDefine_h */
