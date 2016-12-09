//
//  ViewController.m
//  masaike
//
//  Created by ZJF on 16/8/16.
//  Copyright © 2016年 ZJF. All rights reserved.
//
#import "SIMImageViewEditViewController.h"
#import "SIMEditImageView.h"
#import "SIMEditImageToolView.h"
#import "FLFCommitQuestionView.h"

static CGFloat SIMImageEditToolBarHeight = 50.0;

@interface SIMImageViewEditViewController ()<SIMEditImageToolProtocol>
{
    UIImage              *m_image;
    SIMEditImageView     *m_editImageView;
    SIMEditImageToolView *m_editImageToolView;
}
@end

@implementation SIMImageViewEditViewController

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self)
    {
        m_image = image;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self initViews];
    [self initNavigationItem];
    //添加引导图
    [self addFeedbackGuideView];
}

- (void)initViews
{
    m_editImageView = [[SIMEditImageView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64 - SIMImageEditToolBarHeight)];
    //顶部原始图
    m_editImageView.surfaceImage = m_image;
    //马赛克图
    m_editImageView.image = [UIImage transToMosaicImage:m_image blockLevel:self.view.bounds.size.width/20];

    [self.view addSubview:m_editImageView];
    
    m_editImageToolView = [[SIMEditImageToolView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - SIMImageEditToolBarHeight, self.view.frame.size.width,SIMImageEditToolBarHeight)];
    m_editImageToolView.delegate = self;
    [self.view addSubview:m_editImageToolView];
    
    __weak typeof(m_editImageToolView) weakToolView = m_editImageToolView;
    m_editImageView.editBlock = ^(BOOL isNeed){
        [weakToolView backBtnShouldBeUseable:isNeed];
    };
}

- (void)initNavigationItem
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 50, 30);
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [leftBtn.titleLabel setTextColor:[UIColor whiteColor]];
    [leftBtn addTarget:self action:@selector(doCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 140, 30)];
    [rightButton setTitle:@"下一步：描述问题" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [rightButton.titleLabel setTextColor:[UIColor whiteColor]];
    [rightButton addTarget:self action:@selector(doNext:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)addFeedbackGuideView
{
    NSString *hadInFeedBack = [[NSUserDefaults standardUserDefaults] objectForKey:@"hadInFeedBack"];
    if (!hadInFeedBack)
    {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        UIImageView *feedbackGuideImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"feedback_guide"]];
        feedbackGuideImageView.frame = window.bounds;
        feedbackGuideImageView.tag = SIMViewTagFeedbackGuideImageViewTag;
        [feedbackGuideImageView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(feedbackGuideViewTaped)];
        [feedbackGuideImageView addGestureRecognizer:tapGes];
        [window addSubview:feedbackGuideImageView];
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"hadInFeedBack"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)feedbackGuideViewTaped
{
    UIImageView *feedbackGuideImageView = (UIImageView *)[[[UIApplication sharedApplication] keyWindow] viewWithTag:SIMViewTagFeedbackGuideImageViewTag];
    [feedbackGuideImageView removeFromSuperview];
}

- (void)doCancel:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doNext:(UIButton *)sender
{
    [FLFCommitQuestionView addCommitQuestionViewWithImage:[m_editImageView snapshot]];
}

#pragma mark - SIMEditImageToolProtocol
- (void)touchClear
{
    [m_editImageView touchClear];
}

- (void)touchBack
{
    [m_editImageView touchBack];
}

- (void)exchangeEditToolToType:(SIMEditImageToolType)simEditImageToolType
{
    m_editImageView.currentEditTool = simEditImageToolType;;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

#define kBitsPerComponent (8)
#define kBitsPerPixel (32)
#define kPixelChannelCount (4)

@implementation UIImage (mosaic)

+ (UIImage *)transToMosaicImage:(UIImage*)originImage blockLevel:(NSUInteger)level
{
    //获取BitmapData
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef imgRef = originImage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  kBitsPerComponent,        //每个颜色值8bit
                                                  width*kPixelChannelCount, //每一行的像素点占用的字节数，每个像素点的ARGB四个通道各占8个bit
                                                  colorSpace,
                                                  kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);
    unsigned char *bitmapData = CGBitmapContextGetData (context);
    
    //这里把BitmapData进行马赛克转换,就是用一个点的颜色填充一个level*level的正方形
    unsigned char pixel[kPixelChannelCount] = {0};
    NSUInteger index,preIndex;
    for (NSUInteger i = 0; i < height - 1 ; i++) {
        for (NSUInteger j = 0; j < width - 1; j++) {
            index = i * width + j;
            if (i % level == 0) {
                if (j % level == 0) {
                    memcpy(pixel, bitmapData + kPixelChannelCount*index, kPixelChannelCount);
                }else{
                    memcpy(bitmapData + kPixelChannelCount*index, pixel, kPixelChannelCount);
                }
            } else {
                preIndex = (i-1)*width +j;
                memcpy(bitmapData + kPixelChannelCount*index, bitmapData + kPixelChannelCount*preIndex, kPixelChannelCount);
            }
        }
    }
    
    NSInteger dataLength = width*height* kPixelChannelCount;
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, bitmapData, dataLength, NULL);
    //创建要输出的图像
    CGImageRef mosaicImageRef = CGImageCreate(width, height,
                                              kBitsPerComponent,
                                              kBitsPerPixel,
                                              width*kPixelChannelCount ,
                                              colorSpace,
                                              kCGBitmapByteOrderDefault,
                                              provider,
                                              NULL, NO,
                                              kCGRenderingIntentDefault);
    CGContextRef outputContext = CGBitmapContextCreate(nil,
                                                       width,
                                                       height,
                                                       kBitsPerComponent,
                                                       width*kPixelChannelCount,
                                                       colorSpace,
                                                       kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(outputContext, CGRectMake(0.0f, 0.0f, width, height), mosaicImageRef);
    CGImageRef resultImageRef = CGBitmapContextCreateImage(outputContext);
    UIImage *resultImage = nil;
    if([UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)]) {
        float scale = [[UIScreen mainScreen] scale];
        resultImage = [UIImage imageWithCGImage:resultImageRef scale:scale orientation:UIImageOrientationUp];
    } else {
        resultImage = [UIImage imageWithCGImage:resultImageRef];
    }
    //释放
    if(resultImageRef){
        CFRelease(resultImageRef);
    }
    if(mosaicImageRef){
        CFRelease(mosaicImageRef);
    }
    if(colorSpace){
        CGColorSpaceRelease(colorSpace);
    }
    if(provider){
        CGDataProviderRelease(provider);
    }
    if(context){
        CGContextRelease(context);
    }
    if(outputContext){
        CGContextRelease(outputContext);
    }
    return resultImage ;
    
}
@end

@implementation UIView (snapshot)

- (UIImage *)snapshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
