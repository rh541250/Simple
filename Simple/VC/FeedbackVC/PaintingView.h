//
//  PaintingView.h
//  AutoLayoutAnimation
//
//  Created by Rafael Fantini da Costa on 9/15/15.
//  Copyright © 2015 Rafael Fantini da Costa. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const SIMEditTouchEndNotification;

@interface PaintingView : UIView

@property (nonatomic) UIColor *strokeColor;
@property (nonatomic, getter=isErasing) BOOL erasing;

@property (nonatomic) CGFloat lineWidth;
@property (nonatomic,strong)NSMutableArray *arr;


- (void)back;

- (void)clear;

- (void)touchBeginWithPoint:(CGPoint)point;

- (void)touchMoveWithPoint:(CGPoint)point;

- (void)addOffscreenImageToArr;
@end


@interface SIMEditImageItem : NSObject
@property (nonatomic,assign)CGImageRef cgimage;
@end
