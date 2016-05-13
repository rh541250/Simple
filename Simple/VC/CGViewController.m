//
//  CGViewController.m
//  Simple
//
//  Created by ehsy on 16/5/3.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "CGViewController.h"
#import "CGView.h"
@interface CGViewController ()
{
    CGView *cgView;
}
@end

@implementation CGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initViews];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *iv = [[UIImageView alloc]initWithImage:[self drawImage:CGSizeMake(ScreenWidth, ScreenHeight - 64)]];
    iv.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
    
    [self.view addSubview:iv];
}

- (void)initViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    cgView  = [[CGView alloc]init];
    cgView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:cgView];
    WS(ws);
    [cgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(200, 250));
    }];
}


- (UIImage *)drawImage:(CGSize)size
{
    
    UIImage *image = [UIImage imageNamed:@"4"];
    
    CGSize sz = CGSizeMake(image.size.width * image.scale, image.size.height *image.scale);
    
    CGImageRef imgRef = image.CGImage;
    
    
    
    CGImageRef leftRef = CGImageCreateWithImageInRect(imgRef, CGRectMake(0, 0, sz.width/2.0, sz.height));
    
    CGImageRef rightRef = CGImageCreateWithImageInRect(imgRef, CGRectMake(sz.width/ 2.0, 0, sz.width/2.0, sz.height));
    
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(sz.width *1.5, sz.height), NO, 0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextDrawImage(ctx, CGRectMake(0, 0, sz.width/2.0, sz.height), flip(leftRef));
    CGContextDrawImage(ctx, CGRectMake(sz.width, 0, sz.width/2.0, sz.height), flip(rightRef));
    
    UIImage *im = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    CGImageRelease(leftRef);
    CGImageRelease(rightRef);
    return im;
}

CGImageRef flip (CGImageRef im){

    CGSize sz = CGSizeMake(CGImageGetWidth(im), CGImageGetHeight(im));
    UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, sz.width, sz.height),im);
    CGImageRef result = UIGraphicsGetImageFromCurrentImageContext().CGImage;
    
    UIGraphicsEndImageContext();
    return result;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
