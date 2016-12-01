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
#import "SIMScreenShotTool.h"

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
    [self setNavigationItem];
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

- (void)setNavigationItem
{
    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    leftLabel.text = @"取消";
    leftLabel.font = [UIFont systemFontOfSize:16.0];
    [leftLabel setTextColor:[UIColor whiteColor]];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftLabel];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 150)];
    [rightButton setTitle:@"下一步：描述问题" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [rightButton.titleLabel setTextColor:[UIColor whiteColor]];
    [rightButton addTarget:self action:@selector(toQuestionDescribe:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.leftBarButtonItem = rightItem;
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

#pragma mark - target selector
- (void)toQuestionDescribe:(id)sender
{
    
}

- (UIView *)createQuestionDescribeView
{
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
//    containerView.tag = SIMViewTagQuestionViewTag;
//    containerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
//    [window addSubview:containerView];
    
    //添加对话框
//    UIView *dialogView = [[UIView alloc]initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, 295, 246)];
    return nil;
    
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
