//
//  UINavigationBar+Transform.m
//  Simple
//
//  Created by Tim on 16/9/15.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "UINavigationBar+Transform.h"

@implementation UINavigationBar (Transform)


/**
 向上隐藏NavigationBar
 
 - parameter progress: 隐藏的进度，默认是0，范围0~1
 
 - returns: 返回UINavigationBar本身
 */

- (void)setWNavBarHideWithProgress:(CGFloat)progress
{
    if (progress > 0.0) {
        self.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -self.bounds.size.height * progress);
    }else{
        self.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    }
    
    NSArray *leftViews = [self valueForKey:@"_leftViews"];
    for (UIView *view in leftViews) {
        view.alpha = 1 - progress;
    }
    
    NSArray *rightViews = [self valueForKey:@"_rightViews"];
    for (UIView *view in rightViews) {
        view.alpha = 1 - progress;
    }
    
    UIView *titleView = [self valueForKey:@"_titleView"];
    titleView.alpha = 1 - progress;
}

- (void)reset
{
    [self setWNavBarHideWithProgress:0];
}

@end
