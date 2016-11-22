//
//  SIMEditImageToolView.h
//  Simple
//
//  Created by hong.ren on 2016/10/28.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIMImageEditDefine.h"

@protocol SIMEditImageToolProtocol <NSObject>

//清空所有操作，回到最初的状态
- (void)touchClear;
//后退一步
- (void)touchBack;
//选择编辑工具
- (void)exchangeEditToolToType:(SIMEditImageToolType)simEditImageToolType;

@end

@interface SIMEditImageToolView : UIView
@property (nonatomic,weak)id<SIMEditImageToolProtocol>delegate;
//后退一步和清空按钮是否可用
- (void)backBtnShouldBeUseable:(BOOL)need;

@end

@interface SIMEditImageToolButton : UIButton
@property (nonatomic,assign)SIMEditImageToolType toolType;
- (instancetype)initWithDic:(NSDictionary *)dictionary;

@end
