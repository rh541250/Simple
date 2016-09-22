//
//  UINavigationBar+Transform.m
//  Simple
//
//  Created by renhong on 16/9/18.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "UINavigationBar+Transform.h"

@implementation UINavigationBar (Transform)


- (void)setNavBarTranslateWithProgress:(CGFloat)progress
{
    if (progress > 0) {
        self.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -self.bounds.size.height*progress);
    }else {
        self.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    }
    
    UIView *leftView = [self valueForKey:@"_leftViews"];
    if ([leftView isKindOfClass:[UIView class]]) {
        for (UIView *subView in leftView.subviews) {
            subView.alpha = 1 - progress;
        }
    }
    
    UIView *rightView = [self valueForKey:@"_rightViews"];
    if ([rightView isKindOfClass:[UIView class]]) {
        for (UIView *subView in rightView.subviews) {
            subView.alpha = 1 - progress;
        }
    }
    
    UIView *titleView = [self valueForKey:@"_titleView"];
    if ([titleView isKindOfClass:[UIView class]]) {
        titleView.alpha = 1 - progress;
    }
}

@end
