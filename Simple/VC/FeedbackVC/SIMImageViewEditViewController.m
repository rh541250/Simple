//
//  ViewController.m
//  masaike
//
//  Created by ZJF on 16/8/16.
//  Copyright © 2016年 ZJF. All rights reserved.
//
#define kBitsPerComponent (8)
#define kBitsPerPixel (32)
#define kPixelChannelCount (4)

#define kScreenWidth     [UIScreen mainScreen].bounds.size.width


#import "SIMImageViewEditViewController.h"
#import "SIMEditImageView.h"
#import "SIMScreenShotManager.h"

@interface SIMImageViewEditViewController ()

@property (nonatomic,strong)SIMEditImageView * hys;

@end

@implementation SIMImageViewEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    _hys = [[SIMEditImageView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 108)];
    UIImage * image = [[SIMScreenShotManager sharedScreenShotManager] screenShotImage];
    
    //顶图
    _hys.surfaceImage = image;
    //低图
    _hys.image = [self transToMosaicImage:image blockLevel:kScreenWidth/20];
    
    [self.view addSubview:_hys];
    
    UIView *toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44)];
    toolBar.backgroundColor = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:toolBar];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 7,60, 30)];
    [backBtn setTitle:@"后退一步" forState:UIControlStateNormal];
    backBtn.backgroundColor = [UIColor redColor];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:backBtn];
    
    UIButton *redLineButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(backBtn.frame) + 20, 7,60, 30)];
    [redLineButton setTitle:@"画红线" forState:UIControlStateNormal];
    redLineButton.backgroundColor = [UIColor redColor];
    [redLineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [redLineButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [redLineButton addTarget:self action:@selector(toolButtonDidClick:)
            forControlEvents:UIControlEventTouchUpInside];
    redLineButton.tag = SIMImageEditToolLine;
//    redLineButton.tag = SIMImageEditToolRedLine;
    [toolBar addSubview:redLineButton];
    
    UIButton *masicButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(redLineButton.frame) + 20, 7,60, 30)];
    [masicButton setTitle:@"画马赛克" forState:UIControlStateNormal];
    masicButton.backgroundColor = [UIColor redColor];
    [masicButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [masicButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [masicButton addTarget:self action:@selector(toolButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    masicButton.tag = SIMImageEditToolMasic;

    [toolBar addSubview:masicButton];
}

- (void)back:(UIButton *)btn
{
    [_hys touchBack];
}

- (void)toolButtonDidClick:(UIButton *)btn
{
    _hys.simImageEditTool = btn.tag;
}

- (UIImage *)transToMosaicImage:(UIImage*)orginImage blockLevel:(NSUInteger)level
{
    //获取BitmapData
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef imgRef = orginImage.CGImage;
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
