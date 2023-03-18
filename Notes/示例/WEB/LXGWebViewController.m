//
//  LXGWebViewController.m
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/5.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGWebViewController.h"
#import <WebKit/WebKit.h>
#import "LXGWebViewModel.h"
@interface LXGWebViewController ()<WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView       *  webView;
@property (nonatomic, strong) UIProgressView  *  webprogress;
@property (nonatomic, copy  ) NSString        *  URL;
@property (nonatomic, strong) LXGWebViewModel *  viewModel;
@property (nonatomic, assign) BOOL               isNeedShared;
@end
@implementation LXGWebViewController
+ (instancetype)webViewController:(NSString *)url andIsNeedShared:(BOOL)isNeedShared{
    return [LXGWebViewController webViewController:url title:@"" andIsNeedShared:isNeedShared];
}
+ (instancetype)webViewController:(NSString *)url title:(NSString *)title andIsNeedShared:(BOOL)isNeedShared{
    LXGWebViewController *webVC = [LXGWebViewController new];
    webVC.navigationItem.title  = title;
    webVC.URL                   = url;
    webVC.isNeedShared          = isNeedShared;
    return webVC;
}
- (void)dealloc {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.URL = @"http://weizhan.fzqxj.cn:800/pacy";
    [self creatUI];
    [self detectionUrl];
}
-(void)creatUI{
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.mas_topLayoutGuideTop);
        }
    }];
    [self.view addSubview:self.webprogress];
    [self.webprogress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.mas_topLayoutGuideTop);
        }
        make.height.equalTo(@(2));
    }];
}
- (void)detectionUrl{
    if ([self validationWithUrl:self.URL]){
        NSURL * loadURL = [NSURL URLWithString:self.URL];
        [self.webView loadRequest:[NSURLRequest requestWithURL:loadURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15]];
    }else{
        LAlert(@"当前不是h5地址");
    }
}
- (BOOL)validationWithUrl:(NSString *)url {
    if(url.length <= 0) {
        return NO;
    }
    NSString    * regulaStr =  @"^((https|http|ftp|rtsp|mms)?:\\/\\/)[^\\s]+";
    NSPredicate * emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regulaStr];
    return [emailTest evaluateWithObject:url];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel addAllScriptMessageHandle:self webView:self.webView];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.viewModel removeAllScriptMessageHandleWithWebView:self.webView];
}
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
//页面开始加载时调用
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
//当内容开始返回时调用
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
//页面加载完成之后调用
//    //修改字体大小（方法一）
//       NSString *fontSize = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'",125];
//       [ webView evaluateJavaScript:fontSize completionHandler:nil];
//
//
//       //修改字体颜色
//       NSString *colorString = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#364857'"];
    //   [webView evaluateJavaScript:colorString completionHandler:nil];
}
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
//接收到服务器跳转请求之后调用
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
//在收到响应后，决定是否跳转
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL * URL = navigationAction.request.URL;
    NSLog(@"请求地址===%@",URL.absoluteString);
    if ([URL.scheme isEqualToString:@"tel"]) {
        NSString *resourceSpecifier = [URL resourceSpecifier];
        NSString *callPhone         = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
        //防止iOS10及其之后拨打电话系统弹出框延迟出现
        dispatch_async(dispatch_get_main_queue(), ^{
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
            }
        });
        decisionHandler(WKNavigationActionPolicyCancel);
    } else if ([URL.host isEqualToString:@"itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
//在发送请求之前，决定是否跳转
}
//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
////处理证书
//}
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
//加载页面失败
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
//页面加载失败时调用
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [self.viewModel didReceiveScriptMessage:message webView:self.webView];
//收到的脚本信息
}
//监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]){
        if (object == self.webView) {
            CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
            if (newprogress == 1) {
                [self.webprogress setProgress:newprogress animated:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.25 animations:^{
                        self.webprogress.alpha = 0.0f;
                    } completion:^(BOOL finished) {
                        self.webprogress.hidden = YES;
                        [self.webprogress setProgress:0 animated:NO];
                    }];
                });
            }else {
                self.webprogress.alpha  = 1.0f;
                self.webprogress.hidden = NO;
                [self.webprogress setProgress:newprogress animated:YES];
            }
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView) {
            self.navigationItem.title = self.webView.title;
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
-(WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration * configuration          = [[WKWebViewConfiguration alloc] init];
        configuration.preferences                       = [[WKPreferences alloc] init];
        configuration.preferences.javaScriptEnabled     = YES;//是否支持JavaScript
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = NO;//不通过用户交互，是否可以打开窗口
        //WKUserContentController * userContentController  = [[WKUserContentController alloc] init];
        //configuration.userContentController              = userContentController;
        // 设置字体大小(最小的字体大小)
        configuration.preferences.minimumFontSize         = 14 ;
        configuration.processPool                        = [[WKProcessPool alloc] init];
        configuration.allowsInlineMediaPlayback          = YES;
        _webView                                         = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        _webView.navigationDelegate                      = self;
        _webView.allowsBackForwardNavigationGestures     = YES;
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return _webView;
}
- (UIProgressView *)webprogress{
    if (!_webprogress) {
        _webprogress                   = [[UIProgressView alloc] initWithFrame:CGRectZero];
        _webprogress.progressTintColor = [UIColor redColor];
        _webprogress.trackTintColor    = [UIColor clearColor];
        _webprogress.progress          = 0.01;
    }
    return _webprogress;
}
-(LXGWebViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[LXGWebViewModel alloc]init];
    }
    return _viewModel;
}
@end
/*
 - (void)backClick{
 // 获取当前导航栏下所有控制器个数
 NSArray * viewcontrollers = self.navigationController.viewControllers;
 if (viewcontrollers.count > 1) {
 if ([viewcontrollers objectAtIndex:viewcontrollers.count - 1] == self) {
 [self.navigationController popViewControllerAnimated:YES];
 }
 } else {
 [self.navigationController dismissViewControllerAnimated:YES completion:nil];
 }
 }
 */
