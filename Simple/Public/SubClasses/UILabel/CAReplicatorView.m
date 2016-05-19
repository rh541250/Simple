//
//  CAReplicatorView.m
//  Simple
//
//  Created by ehsy on 16/5/19.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "CAReplicatorView.h"

@implementation CAReplicatorView


+(Class)layerClass
{
    return [CAReplicatorLayer class];
}

- (void)setUp
{
    CAReplicatorLayer *layer = (CAReplicatorLayer *)self.layer;
    layer.instanceCount = 2;
    
    CATransform3D transform = CATransform3DIdentity;
    CGFloat verticalOffset = self.bounds.size.height;
    transform = CATransform3DTranslate(transform, 0, verticalOffset, 0);
    transform = CATransform3DScale(transform, 1, -1, 0);
    layer.instanceTransform = transform;
    
    layer.instanceAlphaOffset = -0.6;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setUp];
}



@end
