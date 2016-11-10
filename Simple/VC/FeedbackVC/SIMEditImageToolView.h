//
//  SIMEditImageToolView.h
//  Simple
//
//  Created by hong.ren on 2016/10/28.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import <UIKit/UIKit.h>

//总共多少个工具
NSUInteger toolsNum = 4;

@interface SIMEditImageToolView : UIView

@property (nonatomic,readonly)NSArray *toolArr;

- (instancetype)initWithToolModels:(NSArray *)modelsArr;

@end

typedef NS_ENUM(NSUInteger,SIMEditImageToolType)
{
    SIMEditImageToolTypeClear  = 0,
    SIMEditImageToolTypeBack   = 1,
    SIMEditImageToolTypeLine   = 2,
    SIMEditImageToolTypeMosaic = 3,
};

@interface SIMEditImageToolModel : NSObject

@property (nonatomic,assign)SIMEditImageToolType toolType;
@property (nonatomic,  copy)NSString *toolTitle;
@property (nonatomic,  copy)NSString *toolImageName;

- (instancetype)initWithToolType:(SIMEditImageToolType)toolType toolTitle:(NSString *)toolTitle andToolImageName:(NSString *)toolImageName;

@end

@interface SIMEditImageToolButton : UIButton


@end
