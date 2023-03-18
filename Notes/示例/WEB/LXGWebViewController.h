//
//  LXGWebViewController.h
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/5.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN
@interface LXGWebViewController : BaseViewController
+ (instancetype)webViewController:(NSString *)url andIsNeedShared:(BOOL)isNeedShared;
+ (instancetype)webViewController:(NSString *)url title:(NSString *)title andIsNeedShared:(BOOL)isNeedShared;
@end

NS_ASSUME_NONNULL_END
