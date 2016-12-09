//
//  FLFCommitQuestionView.h
//  Fanli
//
//  Created by shaoqing.fan on 2016/11/17.
//  Copyright © 2016年 www.fanli.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLFCommitQuestionView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *screenShot;
//- (void)registFocus;

+ (void)addCommitQuestionViewWithImage:(UIImage *)image;

@end
