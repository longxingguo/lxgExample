//
//  LXGProgressHUD.h
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/21.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//hud位置
typedef NS_ENUM(NSInteger, LXGProgressHUDType){
    LXGProgressHUDType_Center = 0,//中
    LXGProgressHUDType_Bottom = 1,//下
};
//图片位置
typedef NS_ENUM(NSInteger, LXGProgressHUDImageType){
    LXGProgressHUDImageType_Left = 0,//左
    LXGProgressHUDImageType_Top  = 1,//上
};
NS_ASSUME_NONNULL_BEGIN
@interface LXGProgressHUD : NSObject
#pragma mark-------------------------------------------------------------配置
//单例
+ (instancetype)sharedLXGProgressHUD;
//父视图                   默认[UIApplication sharedApplication].keyWindow
+ (void)showSuperView:(UIView *)superView;
//显示背景颜色              默认[UIColor lightGrayColor]
+ (void)showBgColor:(UIColor *)bgColor;
//显示文字颜色              默认[UIColor whiteColor]
+ (void)showTitleColor:(UIColor *)titleColor;
//显示文字大小              默认15.0
+ (void)showTitleFont:(double)titleFont;
//显示文字的时间             默认2.0
+ (void)showTitleTime:(double)titleTime;
//内容上间距                默认10.0
+ (void)showTopSpace:(double)topSpace;
//内容下间距                默认10.0
+ (void)showBottomSpace:(double)bottomSpace;
//内容左间距                默认10.0
+ (void)showLeftSpace:(double)leftSpace;
//内容右间距                默认10.0
+ (void)showRightSpace:(double)rightSpace;
//文字和图片的间距           默认5.0
+ (void)showItemSpace:(double)itemSpace;
//图片大小                 默认30.0 * 30.0
+ (void)showImageWidthHeight:(double)imageWidthHeight;
//hud在底部时 距离底部多远   默认50.0
+ (void)showBottomFarHeight:(double)bottomFarHeight;
//显示期间，父视图是否接受事件 默认NO
+ (void)showSuperReceiveEvent:(BOOL)superReceiveEvent;
//HUD显示位置（中、下）         默认LXGProgressHUDType_Center
+ (void)showHudType:(LXGProgressHUDType)hudType;
//图片显示位置（左、上）      默认LXGProgressHUDImageType_Left
+ (void)showImageType:(LXGProgressHUDImageType)imageType;
#pragma mark-------------------------------------------------------------文字图片显示
//纯文字
+ (void)showText:(NSString *)text;
//纯图片
+ (void)showImage:(NSString *)imageName;
//图片加文字
+ (void)showImage:(NSString *)imageName andShowText:(NSString *)text;
//图片加文字加图片旋转
+ (void)showImage:(NSString *)imageName andShowText:(NSString *)text andIsRotation:(BOOL)isRotation;
//图片加文字加图片动画加图片旋转
+ (void)showImageArray:(NSArray *)imageNameArray andShowText:(NSString *)text andIsRotation:(BOOL)isRotation;
//隐藏
+(void)dissMiss;
//几秒后隐藏 不传使用默认值
+(void)dissMissWithTime:(double)time;
@end
NS_ASSUME_NONNULL_END
