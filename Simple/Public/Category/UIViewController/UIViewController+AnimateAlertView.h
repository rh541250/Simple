//
//  UIViewController+AnimateAlertView.h
//  Simple
//
//  Created by ehsy on 16/6/27.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString  *AnimationShow;
extern NSString  *AnimationHide;

/**
 *  方向暂时没有加，只有从顶部弹出，从底部消失的动画
 */
typedef NS_ENUM(NSUInteger,E_Direction){
    E_Direction_Top = 0,
    E_Direction_Bottom,
};

@interface UIViewController (AnimateAlertView)

@property (nonatomic,strong)UIView *alertView;
@property (nonatomic,strong)UIView *backView;

//默认是邮箱链接已发送
- (void)alertViewShow;

- (void)alertViewShowWithTitle:(NSString *)title;

- (void)alertViewShowWithDirection:(E_Direction)direction title:(NSString *)title;


@end
