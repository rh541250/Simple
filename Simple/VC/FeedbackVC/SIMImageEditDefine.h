//
//  SIMImageEditDefine.h
//  Simple
//
//  Created by hong.ren on 2016/11/22.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#ifndef SIMImageEditDefine_h
#define SIMImageEditDefine_h

static NSUInteger MAXTextCount = 400;
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
    SIMViewTagFeedbackGuideImageViewTag = 999,
    SIMViewTagQuestionViewTag = 1001,
    SIMViewTagCoverViewTag = 1002,
    SIMViewTagTextViewPlaceHolderTag = 2001,
    SIMViewTagTextCountTag = 2002,
};

#endif /* SIMImageEditDefine_h */
