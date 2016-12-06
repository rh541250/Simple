//
//  SIMEditImageToolView.m
//  Simple
//
//  Created by hong.ren on 2016/10/28.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "SIMEditImageToolView.h"

#define ColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


static NSString *const SIMEditToolTypeKey              = @"toolType";
static NSString *const SIMEditToolTitleKey             = @"toolTitle";
//特殊的工具，比如返回一步，清空所有操作
static NSString *const SIMEditToolSpicalToolKey        = @"SpicalTool";

static NSString *const SIMEditToolNomalImageKey        = @"nomalImage";
static NSString *const SIMEditToolHightlightedImageKey = @"hightlightedImage";
static NSString *const SIMEditToolDisableImageKey      = @"disableImage";
static NSString *const SIMEditToolSelectedImageKey     = @"selectedImage";

static NSString *const SIMEditToolEnabledKey           = @"enabled";
static NSString *const SIMEditToolSelectedKey          = @"toolSelected";

static CGFloat SIMEditToolButtonImageWidth = 17.0;


@interface SIMEditImageToolView()
{
    NSArray *m_editToolBtns;
    SIMEditImageToolType m_currentToolType;
}

@end

@implementation SIMEditImageToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createToolViewsWithModels];
    }
    return self;
}

- (void)createToolViewsWithModels
{
    self.backgroundColor = [UIColor blackColor];
    m_editToolBtns = [self getToolButtons];
    CGFloat buttonWidth = self.frame.size.width / 4.0;
    for (int i = 0; i < m_editToolBtns.count; i++)
    {
        SIMEditImageToolButton *btn = m_editToolBtns[i];
        btn.frame = CGRectMake(i * buttonWidth, 0, buttonWidth,self.frame.size.height);
        [btn setImageEdgeInsets:UIEdgeInsetsMake(6, (btn.frame.size.width - SIMEditToolButtonImageWidth)/2.0, 0, 0)];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(6+SIMEditToolButtonImageWidth/2.0 + 15.0, 6.0, 0, 0)];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

//返回默认的工具集
- (NSArray *)getToolButtons
{
    NSMutableArray *tools = [NSMutableArray array];
    NSArray *toolDics = [self getEditToolDics];
    for (NSDictionary *dic in toolDics)
    {
        SIMEditImageToolButton *btn = [[SIMEditImageToolButton alloc]initWithDic:dic];
        [tools addObject:btn];
    }
    return [tools copy];
}

//返回编辑工具的数组
- (NSArray *)getEditToolDics
{
    return @[
             @{
                 SIMEditToolTypeKey:@"0",
                 SIMEditToolTitleKey:@"全部清除",
                 SIMEditToolNomalImageKey:@"editImage_clear_normal",
                 SIMEditToolHightlightedImageKey:@"editImage_clear_highlighted",
                 SIMEditToolDisableImageKey:@"editImage_clear_disabled",
                 SIMEditToolSelectedImageKey:@"",
                 SIMEditToolSpicalToolKey:@"1",
                 SIMEditToolEnabledKey:@"0",
                 SIMEditToolSelectedKey:@"0",
                 },
             @{
                 SIMEditToolTypeKey:@"1",
                 SIMEditToolTitleKey:@"后退一步",
                 SIMEditToolNomalImageKey:@"editImage_back_normal",
                 SIMEditToolHightlightedImageKey:@"editImage_back_highlighted",
                 SIMEditToolDisableImageKey:@"editImage_back_disabled",
                 SIMEditToolSelectedImageKey:@"",
                 SIMEditToolSpicalToolKey:@"1",
                 SIMEditToolEnabledKey:@"0",
                 SIMEditToolSelectedKey:@"0",
                 },
             @{
                 SIMEditToolTypeKey:@"2",
                 SIMEditToolTitleKey:@"圈出问题",
                 SIMEditToolNomalImageKey:@"editImage_brush_normal",
                 SIMEditToolHightlightedImageKey:@"",
                 SIMEditToolDisableImageKey:@"",
                 SIMEditToolSelectedImageKey:@"editImage_brush_selected",
                 SIMEditToolSpicalToolKey:@"0",
                 SIMEditToolEnabledKey:@"1",
                 SIMEditToolSelectedKey:@"1",
                 },
             @{
                 SIMEditToolTypeKey:@"3",
                 SIMEditToolTitleKey:@"马赛克",
                 SIMEditToolNomalImageKey:@"editImage_mosaic_normal",
                 SIMEditToolHightlightedImageKey:@"",
                 SIMEditToolDisableImageKey:@"",
                 SIMEditToolSelectedImageKey:@"editImage_mosaic_selected",
                 SIMEditToolSpicalToolKey:@"0",
                 SIMEditToolEnabledKey:@"1",
                 SIMEditToolSelectedKey:@"0",
                 },
             ];
}

- (void)buttonClick:(SIMEditImageToolButton *)toolBtn
{
    //如果没有改变绘图工具，并且当前绘图工具不是后退一步的话，那就直接return
    if (toolBtn.toolType == m_currentToolType && m_currentToolType != SIMEditImageToolTypeBack)
    {
        return;
    }
    
    switch (toolBtn.toolType) {
        case SIMEditImageToolTypeClear:
            {
                if (self.delegate && [self.delegate respondsToSelector:@selector(touchClear)])
                {
                    [self.delegate touchClear];
                }
            }
            break;
        case SIMEditImageToolTypeBack:
            {
                if (self.delegate && [self.delegate respondsToSelector:@selector(touchBack)])
                {
                    [self.delegate touchBack];
                }
            }
            break;
        default:
            {
                for (SIMEditImageToolButton *btn in m_editToolBtns)
                {
                    if (btn.toolType == SIMEditImageToolTypeClear || SIMEditImageToolTypeBack == btn.toolType)
                    {
                        continue;
                    }
                    btn.selected = NO;
                }
                toolBtn.selected = YES;
                if (self.delegate && [self.delegate respondsToSelector:@selector(exchangeEditToolToType:)])
                {
                    [self.delegate exchangeEditToolToType:toolBtn.toolType];
                }
                m_currentToolType = toolBtn.toolType;
            }
            break;
    }
}

#pragma mark - public method
- (void)backBtnShouldBeUseable:(BOOL)need
{
    for (SIMEditImageToolButton *btn in m_editToolBtns)
    {
        if (btn.toolType == SIMEditImageToolTypeClear || SIMEditImageToolTypeBack == btn.toolType)
        {
            btn.enabled = need;
        }
    }
}

@end

@interface SIMEditImageToolButton ()
{
    SIMEditImageToolType m_toolType;
}

@end

@implementation SIMEditImageToolButton
@synthesize toolType=m_toolType;

- (instancetype)initWithDic:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        m_toolType = [[dictionary objectForKey:SIMEditToolTypeKey] integerValue];
        self.enabled = [[dictionary objectForKey:SIMEditToolEnabledKey] boolValue];
        self.selected = [[dictionary objectForKey:SIMEditToolSelectedKey] boolValue];
        
        [self setTitle:[dictionary objectForKey:SIMEditToolTitleKey] forState:UIControlStateNormal];
        [self setTitleColor:ColorFromRGB(0xf3f3f3) forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:[dictionary objectForKey:SIMEditToolNomalImageKey]] forState:UIControlStateNormal];
        if (YES == [[dictionary objectForKey:SIMEditToolSpicalToolKey] boolValue])
        {
            [self setTitleColor:ColorFromRGB(0x666666) forState:UIControlStateDisabled];
            [self setTitleColor:ColorFromRGB(0xd1d1d1) forState:UIControlStateHighlighted];
            [self setImage:[UIImage imageNamed:[dictionary objectForKey:SIMEditToolDisableImageKey]] forState:UIControlStateDisabled];
            [self setImage:[UIImage imageNamed:[dictionary objectForKey:SIMEditToolHightlightedImageKey]] forState:UIControlStateHighlighted];
        }
        else
        {
            [self setTitleColor:ColorFromRGB(0x43b149) forState:UIControlStateSelected];
            [self setImage:[UIImage imageNamed:[dictionary objectForKey:SIMEditToolSelectedImageKey]] forState:UIControlStateSelected];
        }
        [self setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        [self.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    }
    return self;
}

@end



