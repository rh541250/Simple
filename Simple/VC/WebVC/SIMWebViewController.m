//
//  SIMWebViewController.m
//  Simple
//
//  Created by Tim on 16/9/4.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "SIMWebViewController.h"
#import "NextWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol TestJSObjectProtocol <JSExport>

//此处我们测试几种参数的情况
-(void)TestNOParameter;
-(void)TestOneParameter:(NSString *)message;
-(void)TestTowParameter:(NSString *)message1 SecondParameter:(NSString *)message2;

@end

@interface TestJSObject : NSObject<TestJSObjectProtocol>

@end


@interface SIMWebViewController ()<UIWebViewDelegate>
{
    
    UIWebView *m_web;
}

@end


@implementation SIMWebViewController
@synthesize web = m_web;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self countss];
    [self layoutViews];
}

- (void)countss
{
    NSInteger a1 = 1<<3;
    NSInteger a2 = 1 << 5;

    NSInteger a3 = ~a1 & ~a2;
    NSInteger a4 = a1 & a2;
    NSLog(@"%ld--%ld",(long)a3,(long)a4);
}

- (void)layoutViews
{
    m_web = [[UIWebView alloc]initWithFrame:self.view.bounds];
    m_web.delegate = self;
    
    [self.view addSubview:m_web];
//    [self loadMyWebView];
    [self loadLocalHtml];
    
    [self clearWebViewBackground:m_web];
}


- (void)clearWebViewBackground:(UIWebView *)webView
{
    UIWebView *web = webView;
    for (id v in web.subviews) {
        if ([v isKindOfClass:[UIScrollView class]]) {
            [v setBounces:NO];
        }
    }
}


#pragma mark 加载WebView
-(void) loadMyWebView{
    NSString *title=@"韩寒《后会无期》奇葩的吸金3秘籍";
    
    NSString *linkStr=[NSString stringWithFormat:@"<a href='%@'>我的博客</a> <a href='%@'>原文</a>",@"http://blog.csdn.net/wildcatlele",@"http://jincuodao.baijia.baidu.com/article/26059"];
    
    NSString *p1=@"韩寒《后会无期》的吸金能力很让我惊讶！8月12日影片票房已成功冲破6亿大关。而且排片量仍保持10 以上，以日收千万的速度稳步向七亿进军。";
    
    NSString *p2=@"要知道，《后会无期》不是主流类型片，是一个文艺片。不像《小时代》，是一个商业主流的偶像电影。";
    NSString *image1=[NSString stringWithFormat:@"<img src='%@'  height='280' width='300' />",@"http://photo.enterdesk.com/2009-3-6/200903052204416294.jpg"];
    NSString *image2=[NSString stringWithFormat:@"<img src='%@'  height='280' width='300' />",@"http://f.hiphotos.baidu.com/news/w%3D638/sign=78315beeb1fb43161a1f797918a44642/2934349b033b5bb58cb61bdb35d3d539b600bcb5.jpg"];
    
    NSString *p3=@"太奇葩了！有人说，这是中国电影市场的红利，是粉丝电影的成功。但是，有一部投资3000万的粉丝电影《我就是我》，有明星，制作也不错，基本上是惨败。";
    
    NSString *p4=@"《后会无期》卖的不是好故事，是优越感。特别是针对80、90后的人群，你有没有发现，看《后会无期》比看《小时代3》有明显的优越感。故事虽然一般，但是很多人看完后，会在微博、微信上晒照片。所以说，对一个族群靠的不是广度，而是深度。<br>\
    \
    很凶残，值得大家借鉴。韩寒《后会无期》还有什么秘密武器，欢迎《后会无期》团队或相关方爆料，直接留言即可，有料的可以送黎万强亲笔签名的《参与感》一书。";
    
    //初始化和html字符串
    NSString *htmlURlStr=[NSString stringWithFormat:@"<body style='background-color:#EBEBF3'><h2>%@</h2><p>%@</p> <p>%@ </p>%@ <br><p> %@</p> <p>%@</p>%@<p>%@</p></body>",title,linkStr,p1,image1,p2,p3,image2,p4];
    
    [m_web loadHTMLString:htmlURlStr baseURL:nil];
    
}

- (void)loadLocalHtml
{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"1"
                                                          ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    [m_web loadHTMLString:htmlCont baseURL:baseURL];
}

#pragma mark - web delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlStr=request.URL.absoluteString;
    
    NSLog(@"url: %@",urlStr);
    
    //为空，第一次加载本页面
    if ([urlStr isEqualToString:@"about:blank"]) {
        return YES;
    }else if([@"ios" isEqualToString:request.URL.scheme]){
        NSRange range = [urlStr rangeOfString:@":"];
        NSString *method = [urlStr substringFromIndex:range.location + 1];
        SEL selector = NSSelectorFromString(method);
        if([self respondsToSelector:selector]){
            [self performSelector:selector];
        }
        return NO;
    }
    
    //设置点击后的视图控制器
//    NextWebViewController *nextVc=[[NextWebViewController alloc] init];
//    nextVc.originUrl=urlStr; //设置请求连接
//    //跳转到点击后的控制器并加载webview
//    [self.navigationController pushViewController:nextVc animated:YES];
    
    return  YES;
}

- (void)shareToTest
{
    NSLog(@"调用OC");
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    NSInteger height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] intValue];
//    NSString* javascript = [NSString stringWithFormat:@"window.scrollBy(0, %ld);", (long)height];
//    [webView stringByEvaluatingJavaScriptFromString:javascript];
    
//    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
//    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    context[@"test1"] = ^(){
//        NSArray *args = [JSContext currentArguments];
//        for (id obj in args) {
//            NSLog(@"%@",obj);
//        }
//    };
//    
//    NSString *jsFunctStr=@"test1('参数1')";
//    [context evaluateScript:jsFunctStr];
//    
//    //二个参数
//    NSString *jsFunctStr1=@"test1('参数a','参数b')";
//    [context evaluateScript:jsFunctStr1];
    
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //第二种情况，js是通过对象调用的，我们假设js里面有一个对象 testobject 在调用方法
    //首先创建我们新建类的对象，将他赋值给js的对象
    
    TestJSObject *testJO=[TestJSObject new];
    context[@"testobject"]=testJO;
    
    //同样我们也用刚才的方式模拟一下js调用方法
    NSString *jsStr1=@"testobject.TestNOParameter()";
    [context evaluateScript:jsStr1];
    NSString *jsStr2=@"testobject.TestOneParameter('参数1')";
    [context evaluateScript:jsStr2];
    NSString *jsStr3=@"testobject.TestTowParameterSecondParameter('参数A','参数B')";
    [context evaluateScript:jsStr3];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


@implementation TestJSObject

//一下方法都是只是打了个log 等会看log 以及参数能对上就说明js调用了此处的iOS 原生方法
-(void)TestNOParameter
{
    NSLog(@"this is ios TestNOParameter");
}
-(void)TestOneParameter:(NSString *)message
{
    NSLog(@"this is ios TestOneParameter=%@",message);
}
-(void)TestTowParameter:(NSString *)message1 SecondParameter:(NSString *)message2
{
    NSLog(@"this is ios TestTowParameter=%@  Second=%@",message1,message2);
}

@end
