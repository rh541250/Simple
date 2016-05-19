//
//  SpecialLayer.h
//  Simple
//
//  Created by ehsy on 16/5/18.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
@interface SpecialLayer : NSObject
/*
 *  CAShapeLayer
 */
+ (CALayer *)createCAShapeLayer;



/*
 *  CATextLayer
 */
+ (CALayer *)createCATextLayerWithRect:(CGRect)rect;


/*
 *  CAGradientLayer
 */
+ (CALayer *)createCAGradientLayerWithRect:(CGRect)rect;


/**
 *  CAReplicatorLayer
 */
+(CALayer *)createCAReplicatorLayerWithRect:(CGRect)rect;

/**
 *  CAEmitterLayer
 */
+(CALayer *)createCAEmitterLayerWithRect:(CGRect)rect;
@end
