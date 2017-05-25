//
//  BroserController.m
//  YunShouHu
//
//  Created by WangQiang on 16/3/25.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import "WQBroserController.h"
#import <WebKit/WebKit.h>
#import "WQAPPHELP.h"
@interface WQBroserController ()<UIWebViewDelegate,WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
//@property (strong, nonatomic) WKWebView *webView;
@end

@implementation WQBroserController
//
//-(WKWebView *)webView{
//    if(!_webView){
//        _webView = [[WKWebView alloc] init];
//        _webView.navigationDelegate = self;
//    }
//    return _webView;
//}
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.URLString]]];
//    [self.view addSubview:self.webView];
//}
//-(void)viewDidLayoutSubviews{
//    [super viewDidLayoutSubviews];
//    self.webView.frame = self.view.bounds;
//}
//-(WKWebView *)webView{
//    if(!_webView){
//        _webView = [[WKWebView alloc] init];
//        _webView.navigationDelegate = self;
//    }
//    return _webView;
//}
////每一个地址请求准备请求之前的响应方法
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
//     NSLog(@"=====%@",navigationAction.request.URL.absoluteString);
//    decisionHandler(WKNavigationActionPolicyAllow);
//}
////每一个地址请求成功响应方法
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
//    NSLog(@"------%@",navigationResponse.response.URL.absoluteString);
//    decisionHandler(WKNavigationResponsePolicyAllow);
//
//}
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.URLString]];
//    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
//
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.URLString]]];
//
//    [self.view addSubview:self.webView];
//}
//-(void)viewDidLayoutSubviews{
//    [super viewDidLayoutSubviews];
//    self.webView.frame = self.view.bounds;
//}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"request:%@",request.URL.absoluteString);
    //    NSLog(@"=====schem:%@ ==== resource:%@",request.URL.scheme,request.URL.resourceSpecifier);
    if([request.URL.scheme compare:@"tel" options:NSCaseInsensitiveSearch] == NSOrderedSame){
        [WQAPPHELP callNumber:request.URL.resourceSpecifier];
        return NO;
    }
    return YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    if(!self.title || self.title.length <= 0){
        self.title =  [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.URLString]]];
}
@end
