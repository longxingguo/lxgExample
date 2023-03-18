//
//  LXGPublicTool.h
//  Notes
//
//  Created by 龙兴国 on 2019/9/10.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
///状态栏高度
#define LStatusBarHeight             [LXGPublicTool statusBarHeight]
///屏幕大小
#define LScreenBounds                [LXGPublicTool screenBounds]
///屏幕宽
#define LScreenWidth                 [LXGPublicTool screenWidth]
///屏幕高
#define LScreenHeight                [LXGPublicTool screenHeight]
///比例系数 375为基值
#define LScale                       [LXGPublicTool screenScale]
///比例缩放值
#define LScaleX(x)                   [LXGPublicTool screenScaleX:x]
///
#define LTabBarHeight                [LXGPublicTool tabBarHeight]
///当前窗口
#define LKeyWind                     [LXGPublicTool currentWind]
///当前控制器
#define LCurrentVC                   [LXGPublicTool currentViewController]
///提示框
#define LAlert(string)               [LXGPublicTool alert:string]
///提示框 打开设置
#define LAlertOpenSetting(string)    [LXGPublicTool alertOpenSetting:string]
///截图 view视图
#define LShotView(view)              [LXGPublicTool shotView:view]
///模糊 view视图 style模糊类型
#define LEffectView(view,style)      [LXGPublicTool effectView:view andStyle:style]
NS_ASSUME_NONNULL_BEGIN
@interface LXGPublicTool : NSObject
/// 返回状态栏高度
+(CGFloat)statusBarHeight;
/// 返回屏幕大小
+(CGRect )screenBounds;
/// 返回屏幕宽
+(CGFloat)screenWidth;
/// 返回屏幕高
+(CGFloat)screenHeight;
/// 返回比例系数
+(CGFloat)screenScale;
/// 返回按比例缩放后的值
+(CGFloat)screenScaleX:(CGFloat)x;
///tabBar高度
+(CGFloat)tabBarHeight;
///当前显示的wind
+(UIWindow *)currentWind;
/// 当前控制器
+(UIViewController *)currentViewController;
/// 系统提示框 不做操作
/// @param string 提示文字
+(void)alert:(NSString *)string;
/// 系统提示框 打开设置
/// @param string 提示文字
+(void)alertOpenSetting:(NSString *)string;
/// 系统提示框 返回确定事件
/// @param string 提示文字
/// @param sure 事件
+(void)alert:(NSString *)string andSure:(void(^)(void))sure;
/// 截图
/// @param view 需要截图的视图
+(UIImage *)shotView:(UIView *)view;
/// 高斯模糊
/// @param surperView 需要模糊的视图
/// @param style UIBlurEffectStyle 模糊类型
+(void)effectView:(UIView *)surperView andStyle:(UIBlurEffectStyle)style;
@end
NS_ASSUME_NONNULL_END
