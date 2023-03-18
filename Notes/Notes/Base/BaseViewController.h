//
//  BaseViewController.h
//  hwweather
//
//  Created by 龙兴国 on 2019/5/13.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface BaseViewController : UIViewController
// 导航栏标题样式
@property (nonatomic, strong) NSDictionary<NSAttributedStringKey, id> *titleTextAttributes;
// 导航栏背景图片
@property (nonatomic, strong) UIImage * navigationBarImage;
// 返回图片
@property (nonatomic, strong) UIImage * navBackImage;
// 显示隐藏导航栏
@property (nonatomic, assign) BOOL navigationBarHidden;
// 侧滑返回手势
@property (nonatomic, assign) BOOL enablePopGesture;
// 将要显示
@property (nonatomic, copy) void(^viewWillAppearInjectBlock)(BaseViewController *viewController, BOOL animated);
// 已经显示
@property (nonatomic, copy) void(^viewDidAppearInjectBlock) (BaseViewController *viewController, BOOL animated);
// 返回按钮事件
- (void)navBackAction;
// 流量或者wifi
- (void)updateViewWhenNetworkChanged;
@end
NS_ASSUME_NONNULL_END
