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
    UIImageView *iv = [[UIImageView alloc]initWithImage:[self drawImage:CGSizeMake(ScreenWidth, ScreenHeight - 100)]];
    iv.frame = CGRectMake(0, 100, ScreenWidth, ScreenHeight - 100);
    
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
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGContextRef con = UIGraphicsGetCurrentContext();
    
    // 在上下文裁剪区域中挖一个三角形状的孔
    
    CGContextMoveToPoint(con, 90, 100);
    
    CGContextAddLineToPoint(con, 100, 90);
    
    CGContextAddLineToPoint(con, 110, 100);
    
    CGContextClosePath(con);
    
    CGContextAddRect(con, CGContextGetClipBoundingBox(con));
    
    // 使用奇偶规则，裁剪区域为矩形减去三角形区域
    
    CGContextEOClip(con);
    
    // 绘制垂线
    
    CGContextMoveToPoint(con, 100, 100);
    
    CGContextAddLineToPoint(con, 100, 19);
    
    CGContextSetLineWidth(con, 20);
    
    CGContextStrokePath(con);
    
    // 画红色箭头
    
    CGContextSetFillColorWithColor(con, [[UIColor redColor] CGColor]);
    
    CGContextMoveToPoint(con, 80, 25);
    
    CGContextAddLineToPoint(con, 100, 0); 
    
    CGContextAddLineToPoint(con, 120, 25); 
    
    CGContextFillPath(con);  
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
