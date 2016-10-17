//
//  NextWebViewController.m
//  Simple
//
//  Created by Tim on 16/9/4.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "NextWebViewController.h"

@interface NextWebViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
}
@end

@implementation NextWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置title
    self.title=@"原文";
    
    
    _webView=[[UIWebView alloc] init];
    _webView.frame=[[UIScreen mainScreen] bounds];
    _webView.delegate =self;
    
    [self.view addSubview:_webView];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.originUrl]]];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"---%@",request.URL.absoluteString);
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
