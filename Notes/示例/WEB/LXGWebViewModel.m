//
//  LXGWebViewModel.m
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/5.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGWebViewModel.h"
@implementation LXGWebViewModel
//添加
- (void)addAllScriptMessageHandle:(id <WKScriptMessageHandler>)handler webView:(WKWebView *)webView{
    [[webView configuration].userContentController addScriptMessageHandler:handler name:@"invokeNativePushSelector"];
    [[webView configuration].userContentController addScriptMessageHandler:handler name:@"invokeNativePopSelector"];
}
//移除
- (void)removeAllScriptMessageHandleWithWebView:(WKWebView *)webView{
    [[webView configuration].userContentController removeScriptMessageHandlerForName:@"invokeNativePushSelector"];
    [[webView configuration].userContentController removeScriptMessageHandlerForName:@"invokeNativePopSelector"];
}
//收到的脚本信息
- (void)didReceiveScriptMessage:(WKScriptMessage *)message webView:(WKWebView *)webView{
    NSLog(@"message:%@name:%@body:%@frameInfo:%@",message,message.name,message.body,message.frameInfo);
}
@end
