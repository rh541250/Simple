//
//  PaintingView.h
//  AutoLayoutAnimation
//
//  Created by Rafael Fantini da Costa on 9/15/15.
//  Copyright © 2015 Rafael Fantini da Costa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaintingView : UIView

@property (nonatomic) UIColor *strokeColor;
@property (nonatomic, getter=isErasing) BOOL erasing;

@property (nonatomic) CGFloat lineWidth;

- (void)back;


- (void)eraserTouchBeginWithPoint:(CGPoint)point;

- (void)eraserTouchMoveWithPoint:(CGPoint)point;

@end


@interface CAImageItem : NSObject
@property (nonatomic,assign)CGImageRef cgimage;
@end
