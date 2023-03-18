//
//  LXGProgressHUDTool.h
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/22.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface LXGProgressHUDTool : NSObject
/*父视图 默认[UIApplication sharedApplication].keyWindow*/
+ (void)showSuperView:(UIView *)superView;
/*纯文字 中间*/
+ (void)showHudCenterText:(NSString *)text;
/*纯文字 底部*/
+ (void)showHudBottomText:(NSString *)text;
/*纯图片 中间*/
+ (void)showHudCenterCImage:(NSString *)imageName;
/*纯图片 底部*/
+ (void)showHudBottomImage:(NSString *)imageName;
/*图片加文字 hud中间*/
+ (void)showHudCenterImage:(NSString *)imageName andShowText:(NSString *)text;
/*图片加文字 hud底部*/
+ (void)showHudBottomImage:(NSString *)imageName andShowText:(NSString *)text;
/*图片加文字 hud中间 image左边*/
+ (void)showHudCenterImageLeftImage:(NSString *)imageName andShowText:(NSString *)text;
/*图片加文字 hud底部 image左边*/
+ (void)showHudBottomImageLeftImage:(NSString *)imageName andShowText:(NSString *)text;
/*图片加文字 hud中间 image上边*/
+ (void)showHudCenterImageTopImage:(NSString *)imageName andShowText:(NSString *)text;
/*图片加文字 hud底部 image上边*/
+ (void)showHudBottomImageTopImage:(NSString *)imageName andShowText:(NSString *)text;
/*图片加文字加图片旋转 中间*/
+ (void)showHudCenterImage:(NSString *)imageName andShowText:(NSString *)text andIsRotation:(BOOL)isRotation;
/*图片加文字加图片旋转 底部*/
+ (void)showHudBottomImage:(NSString *)imageName andShowText:(NSString *)text andIsRotation:(BOOL)isRotation;
/*图片加文字加动画加图片旋转*/
+ (void)showHudImageArray:(NSArray *)imageNameArray andShowText:(NSString *)text andIsRotation:(BOOL)isRotation;
/*隐藏*/
+(void)dissMiss;
/*几秒后隐藏 不传使用默认值*/
+(void)dissMissWithTime:(double)time;
@end
NS_ASSUME_NONNULL_END
