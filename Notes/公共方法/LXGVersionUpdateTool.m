//
//  LXGVersionUpdateTool.m
//  ShanXiNongYe
//
//  Created by 龙兴国 on 2020/6/29.
//  Copyright © 2020 龙兴国. All rights reserved.
//

#import "LXGVersionUpdateTool.h"
#import "AppDelegate.h"
@implementation LXGVersionUpdateTool
+(instancetype)shareVersionUpdateTool{
    static LXGVersionUpdateTool * versionUpdateTool;
    static dispatch_once_t        onceToken;
    dispatch_once(&onceToken, ^{
        versionUpdateTool        = [[LXGVersionUpdateTool alloc]init];
        versionUpdateTool.isshow = NO;
    });
    return versionUpdateTool;
}
-(void)checkVersionUpdate{
    if (!self.isshow) {
        NSDictionary * infodic          = [[NSBundle mainBundle] infoDictionary];
        NSString     * bundleId         = infodic[@"CFBundleIdentifier"];
        //NSString     * checkidString    = @"https://itunes.apple.com/cn/lookup?id=1490049803";
        NSString     * checkbidString   = [NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?bundleId=%@", bundleId];
        NSURL        * checkurl         = [NSURL URLWithString:checkbidString];
        NSString     * appinfostring    = [NSString stringWithContentsOfURL:checkurl encoding:NSUTF8StringEncoding error:nil];
        if(appinfostring == nil){
            return;
        }
        NSError      * error            = nil;
        NSData       * jsondata         = [appinfostring dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * appinfo          = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableLeaves error:&error];
        if (!error && appinfo) {
            NSArray      * result       = appinfo[@"results"];
            NSDictionary * resultdic    = result.firstObject;
            NSString     * version      = resultdic[@"version"];
            NSString     * downurl      = resultdic[@"trackViewUrl"];
            NSString     * nowVersion   = [infodic objectForKey:@"CFBundleVersion"];
            if (version.floatValue > nowVersion.floatValue) {
                UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"有新版本可以更新" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    self.isshow = YES;
                }]];
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    self.isshow = YES;
                    NSURL* url  = [NSURL URLWithString:downurl];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        if (@available(iOS 10.0, *)) {
                            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                        } else {
                            [[UIApplication sharedApplication] openURL:url];
                        }
                    }
                }]];
                [[self currentViewController] presentViewController:alertController animated:YES completion:nil];
            }
        }
    }
}
-(UIViewController *)currentViewController{
    UIViewController * rootViewController = self.rootWind.rootViewController;
    UIViewController * topVC              = [self deepestPresentedViewControllerOf:rootViewController];
    if([topVC isKindOfClass:[UITabBarController class]]) {
        UIViewController * tabSelectedVC  = ((UITabBarController *)topVC).selectedViewController;
        if (tabSelectedVC){
            topVC = [self deepestPresentedViewControllerOf:tabSelectedVC];
        }
    }
    if([topVC isKindOfClass:[UINavigationController class]]){
        UIViewController * navTopVC       = ((UINavigationController *)topVC).topViewController;
        if (navTopVC) {
            topVC = [self deepestPresentedViewControllerOf:navTopVC];
        }
    }
    return topVC;
}
-(UIViewController *)deepestPresentedViewControllerOf:(UIViewController *)viewController{
    UIViewController * deepestViewController = viewController;
    Class alertVC0                           = [UIAlertController class];
    Class alertVC1                           = NSClassFromString(@"_UIAlertShimPresentingViewController");
    while (YES) {
        UIViewController * presentedVC       = deepestViewController.presentedViewController;
        if (presentedVC && ![presentedVC isKindOfClass:alertVC0] && ![presentedVC isKindOfClass:alertVC1]) {
            deepestViewController = deepestViewController.presentedViewController;
        }else{
            break;
        }
    }
    return deepestViewController;
}
-(UIWindow *)rootWind{
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
@end
