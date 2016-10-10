//
//  SmoothLineView.h
//  Simple
//
//  Created by renhong on 16/9/29.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmoothLineView : UIView
{
    @private
        CGPoint currentPoint;
        CGPoint previousPoint1;
        CGPoint previousPoint2;
        CGFloat lineWidth;
        UIColor *lineColor;
        UIImage *curImage;
        BOOL isErase;
        CGContextRef context;
        NSUndoManager *undoManager;
}
@property (nonatomic, retain) UIColor *lineColor;
@property (readwrite) CGFloat lineWidth;
@property (nonatomic,assign)BOOL isErase;
@property (nonatomic, retain)NSUndoManager *undoManager;

-(void)clear;
-(void)undo;
- (UIImage *)imageRepresentation;
@end
