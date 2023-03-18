//
//  LXGPublicTool.m
//  Notes
//
//  Created by 龙兴国 on 2019/9/10.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGPublicTool.h"
#import "AppDelegate.h"
@implementation LXGPublicTool
/// 返回状态栏高度
+(CGFloat)statusBarHeight{
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}
/// 返回屏幕大小
+(CGRect)screenBounds{
    return [UIScreen mainScreen].bounds;
}
/// 返回屏幕宽
+(CGFloat)screenWidth{
    return [UIScreen mainScreen].bounds.size.width;
}
/// 返回屏幕高
+(CGFloat)screenHeight{
     return [UIScreen mainScreen].bounds.size.height;
}
/// 返回比例
+(CGFloat)screenScale{
    return MIN(self.screenWidth, self.screenHeight)/375.0;
}
/// 返回按比例缩放后的值
+(CGFloat)screenScaleX:(CGFloat)x{
    return x * self.screenScale;
}
///tabBar高度
+(CGFloat)tabBarHeight{
    UIViewController * rootViewController = LKeyWind.rootViewController;
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController * tabbarVC = (UITabBarController *)rootViewController;
        return tabbarVC.tabBar.frame.size.height;
    }else{
        return 0;
    }
}
///当前显示的wind
+(UIWindow *)currentWind{
     UIWindow * window = nil;
    if (@available(iOS 13.0, *)){
        for (UIWindowScene * windowScene in [UIApplication sharedApplication].connectedScenes){
            if (windowScene.activationState == UISceneActivationStateForegroundActive){
                window = windowScene.windows.firstObject;
                break;
            }
        }
    }else{
        AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        window                 = delegate.window;
    }
    return window;
}
///当前控制器
+(UIViewController *)currentViewController{
    UIViewController * rootViewController = LKeyWind.rootViewController;
    UIViewController * topVC              = [self deepestPresentedViewControllerOf:rootViewController];
    if ([topVC isKindOfClass:[UITabBarController class]]) {
        UIViewController * tabSelectedVC = ((UITabBarController *)topVC).selectedViewController;
        if (tabSelectedVC) {
            topVC = [self deepestPresentedViewControllerOf:tabSelectedVC];
        }
    }
    if ([topVC isKindOfClass:[UINavigationController class]]) {
        UIViewController * navTopVC      = ((UINavigationController *)topVC).topViewController;
        if (navTopVC) {
            topVC = [self deepestPresentedViewControllerOf:navTopVC];
        }
    }
    return topVC;
}
+ (UIViewController *)deepestPresentedViewControllerOf:(UIViewController *)viewController {
    UIViewController * deepestViewController = viewController;
    Class alertVC0                           = [UIAlertController class];
    Class alertVC1                           = NSClassFromString(@"_UIAlertShimPresentingViewController");
    while (YES) {
        UIViewController * presentedVC       = deepestViewController.presentedViewController;
        if (presentedVC && ![presentedVC isKindOfClass:alertVC0] && ![presentedVC isKindOfClass:alertVC1]) {
            deepestViewController = deepestViewController.presentedViewController;
        } else {
            break;
        }
    }
    return deepestViewController;
}
///系统提示框不做操作
+(void)alert:(NSString *)string{
    [self alert:string andOpenSet:NO andSure:nil];
}
///系统提示框 打开设置
+(void)alertOpenSetting:(NSString *)string{
    [self alert:string andOpenSet:YES andSure:nil];
}
///系统提示框 返回确定事件
+(void)alert:(NSString *)string andSure:(void(^)(void))sure{
    [self alert:string andOpenSet:NO andSure:sure];
}
+(void)alert:(NSString *)string andOpenSet:(BOOL)openSet andSure:(void(^)(void))sure{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"" message:string preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (openSet) {
             NSURL * privacyUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                   if ([[UIApplication sharedApplication] canOpenURL:privacyUrl]) {
                       [[UIApplication sharedApplication] openURL:privacyUrl];
                   }
        }
       if (sure) {
           sure();
       }
    }]];
    [LCurrentVC presentViewController:alertController animated:YES completion:nil];
    //修改title     [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
    //修改message   [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    //修改按钮的颜色  [cancelAction setValue:[UIColor orangeColor] forKey:@"titleTextColor"];
    /*
     UIView * subView1 = alertController.view.subviews[0];
     NSLog(@"%@",subView1.subviews);
     UIView *subView2 = subView1.subviews[0];
     NSLog(@"%@",subView2.subviews);
     UIView *subView3 = subView2.subviews[0];
     NSLog(@"%@",subView3.subviews);
     UIView *subView4 = subView3.subviews[0];
     NSLog(@"%@",subView4.subviews);
     UIView *subView5 = subView4.subviews[0];
     NSLog(@"%@",subView5.subviews);
     //取title和message：
     //UILabel *title   = subView5.subviews[0];
     //UILabel *message = subView5.subviews[1];
     */
}
/// 截图
/// @param view 需要截图的视图
+(UIImage *)shotView:(UIView *)view{
    //WKWebView不支持renderInContext 返回nil  只能用drawViewHierarchyInRect
    //renderInContext 高斯模糊蒙版会失真失效 不失效只能用drawViewHierarchyInRect
    /*ios13 状态栏
     if (@available(iOS 13.0, *)) {
                 UIView *_localStatusBar = [[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager performSelector:@selector(createLocalStatusBar)];
                 UIView * statusBar = [_localStatusBar performSelector:@selector(statusBar)];
     // 注意此代码不生效
     //           [statusBar drawViewHierarchyInRect:statusBar.bounds afterScreenUpdates:NO];
                 [statusBar.layer renderInContext:context];

             } else {
                 // Fallback on earlier versions
             }
     */
//    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
//        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
//    }else{
//        [view.layer renderInContext:context];
//    }
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/// 高斯模糊
/// @param surperView 需要模糊的视图
/// @param style UIBlurEffectStyle 模糊类型
+(void)effectView:(UIView *)surperView andStyle:(UIBlurEffectStyle)style{
    UIBlurEffect       * blurEffect   = [UIBlurEffect effectWithStyle:style];
    UIVisualEffectView * blurView     = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    blurView.frame                    = surperView.bounds;
    [surperView addSubview:blurView];
    blurView.alpha = 0.5;
}
@end
