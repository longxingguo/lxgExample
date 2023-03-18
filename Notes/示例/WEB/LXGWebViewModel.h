//
//  LXGWebViewModel.h
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/5.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface LXGWebViewModel : NSObject
//添加
- (void)addAllScriptMessageHandle:(id <WKScriptMessageHandler>)handler webView:(WKWebView *)webView;
//移除
- (void)removeAllScriptMessageHandleWithWebView:(WKWebView *)webView;
//收到的脚本信息
- (void)didReceiveScriptMessage:(WKScriptMessage *)message webView:(WKWebView *)webView;
@end

NS_ASSUME_NONNULL_END
