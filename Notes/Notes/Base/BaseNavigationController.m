//
//  BaseNavigationController.m
//  hwweather
//
//  Created by 龙兴国 on 2019/5/13.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "BaseNavigationController.h"
#import "BaseViewController.h"
@interface BaseNavigationController ()
@end
@implementation BaseNavigationController
- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = (id)weakSelf;
    }
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    } else {
        viewController.hidesBottomBarWhenPushed = NO;
    }
    //将要显示
    __weak typeof(self) wSelf = self;
    void (^viewWillAppearInjectBlock)(BaseViewController *viewController, BOOL animated) = ^(BaseViewController *viewController, BOOL animated) {
        __strong typeof(wSelf) sSelf = wSelf;
        if (sSelf) {
            [sSelf setNavigationBarHidden:viewController.navigationBarHidden animated:animated];
            if (viewController.titleTextAttributes) {
                [self.navigationBar setTitleTextAttributes:viewController.titleTextAttributes];
            }
            if (viewController.navigationBarImage) {
                [self.navigationBar setBackgroundImage:viewController.navigationBarImage forBarMetrics:UIBarMetricsDefault];
            }
        }
    };
    if ([viewController isKindOfClass:[BaseViewController class]]) {
        [(BaseViewController *)viewController setViewWillAppearInjectBlock:viewWillAppearInjectBlock];
    }
    if ([self.topViewController isKindOfClass:[BaseViewController class]]) {
        BaseViewController *topViewController = (BaseViewController *)self.topViewController;
        if (!topViewController.viewWillAppearInjectBlock) {
            [topViewController setViewWillAppearInjectBlock:viewWillAppearInjectBlock];
        }
    }
    //已经显示
    void (^viewDidAppearInjectBlock)(BaseViewController *viewController, BOOL animated) = ^(BaseViewController *viewController, BOOL animated) {
        __strong typeof(wSelf) sSelf = wSelf;
        if (sSelf) {
            sSelf.interactivePopGestureRecognizer.enabled = viewController.enablePopGesture;
        }
    };
    if ([viewController isKindOfClass:[BaseViewController class]]) {
        [(BaseViewController *)viewController setViewDidAppearInjectBlock:viewDidAppearInjectBlock];
    }
    [super pushViewController:viewController animated:animated];
}
//状态栏
- (UIStatusBarStyle)preferredStatusBarStyle{
    return [self.topViewController preferredStatusBarStyle];
}
//是否能手势返回
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        if (self.viewControllers.count < 2 || self.visibleViewController == self.viewControllers.firstObject) {
            return NO;
        }
    }
    return YES;
}
@end
