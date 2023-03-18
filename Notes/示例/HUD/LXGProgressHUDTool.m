//
//  LXGProgressHUDTool.m
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/22.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGProgressHUDTool.h"
#import "LXGProgressHUD.h"
//+ (void)load;的时候 并没有wind
@implementation LXGProgressHUDTool
//父视图 默认[UIApplication sharedApplication].keyWindow
+ (void)showSuperView:(UIView *)superView{
    [LXGProgressHUD showSuperView:superView];
}
//纯文字 中间
+ (void)showHudCenterText:(NSString *)text{
    [self showHudCenterImage:@"" andShowText:text andIsRotation:NO];
}
//纯文字 底部
+ (void)showHudBottomText:(NSString *)text{
    [self showHudBottomImage:@"" andShowText:text andIsRotation:NO];
}
//纯图片 中间
+ (void)showHudCenterCImage:(NSString *)imageName{
    [self showHudCenterImage:imageName andShowText:@"" andIsRotation:NO];
}
//纯图片 底部
+ (void)showHudBottomImage:(NSString *)imageName{
    [self showHudBottomImage:imageName andShowText:@"" andIsRotation:NO];
}
//图片加文字 hud中间
+ (void)showHudCenterImage:(NSString *)imageName andShowText:(NSString *)text{
    [self showHudCenterImage:imageName andShowText:text andIsRotation:NO];
}
//图片加文字 hud底部
+ (void)showHudBottomImage:(NSString *)imageName andShowText:(NSString *)text{
     [self showHudBottomImage:imageName andShowText:text andIsRotation:NO];
}
//图片加文字 hud中间 image左边
+ (void)showHudCenterImageLeftImage:(NSString *)imageName andShowText:(NSString *)text{
    [LXGProgressHUD showImageType:LXGProgressHUDImageType_Left];
    [self showHudCenterImage:imageName andShowText:text andIsRotation:NO];
}
//图片加文字 hud底部 image左边
+ (void)showHudBottomImageLeftImage:(NSString *)imageName andShowText:(NSString *)text{
     [LXGProgressHUD showImageType:LXGProgressHUDImageType_Left];
     [self showHudBottomImage:imageName andShowText:text andIsRotation:NO];
}
//图片加文字 hud中间 image上边
+ (void)showHudCenterImageTopImage:(NSString *)imageName andShowText:(NSString *)text{
     [LXGProgressHUD showImageType:LXGProgressHUDImageType_Top];
     [self showHudCenterImage:imageName andShowText:text andIsRotation:NO];
}
//图片加文字 hud底部 image上边
+ (void)showHudBottomImageTopImage:(NSString *)imageName andShowText:(NSString *)text{
     [LXGProgressHUD showImageType:LXGProgressHUDImageType_Top];
     [self showHudBottomImage:imageName andShowText:text andIsRotation:NO];
}
//图片加文字加图片旋转 中间
+ (void)showHudCenterImage:(NSString *)imageName andShowText:(NSString *)text andIsRotation:(BOOL)isRotation{
    [LXGProgressHUD showHudType:LXGProgressHUDType_Center];
    [LXGProgressHUD showImage:imageName andShowText:text andIsRotation:isRotation];
}
//图片加文字加图片旋转 底部
+ (void)showHudBottomImage:(NSString *)imageName andShowText:(NSString *)text andIsRotation:(BOOL)isRotation{
    [LXGProgressHUD showHudType:LXGProgressHUDType_Bottom];
    [LXGProgressHUD showImage:imageName andShowText:text andIsRotation:isRotation];
}
/*图片加文字加动画加图片旋转*/
+ (void)showHudImageArray:(NSArray *)imageNameArray andShowText:(NSString *)text andIsRotation:(BOOL)isRotation{
    [LXGProgressHUD showImageArray:imageNameArray andShowText:text andIsRotation:isRotation];
}
//隐藏
+(void)dissMiss{
    [LXGProgressHUD dissMiss];
}
//几秒后隐藏 不传使用默认值
+(void)dissMissWithTime:(double)time{
     [LXGProgressHUD dissMissWithTime:time];
}
@end
