//
//  SIMScreenShotOverLayView.h
//  Simple
//
//  Created by hong.ren on 2016/12/5.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SIMScreenShotOperationProtocol <NSObject>

- (void)screenShotShouldFeedback;

- (void)screenShotShouldShare;

@end

@interface SIMScreenShotOverLayView : UIView
@property (nonatomic,weak)id<SIMScreenShotOperationProtocol> delegate;

- (instancetype)initWithScreenShotImage:(UIImage *)screenShotImage;

@end
