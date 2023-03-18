//
//  LXGProgressHUD.m
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/21.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGProgressHUD.h"
#import "AppDelegate.h"
//hud背景
@interface LXGProgressHUDbgView : UIView
@end
@implementation LXGProgressHUDbgView
@end
//hud
@interface LXGProgressHUDView : UIView
@property (nonatomic ,strong)UIImageView * imageView;
@property (nonatomic ,strong)UILabel     * titleLable;
@end
@implementation LXGProgressHUDView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self.imageView  = [[UIImageView alloc]init];
        self.titleLable = [[UILabel alloc]init];
        [self addSubview:self.imageView];
        [self addSubview:self.titleLable];
    }
    return self;
}
@end
@interface LXGProgressHUD ()
//父视图(为空将显示在window上)
@property (nonatomic,strong)UIView  * superView;
//显示背景颜色
@property (nonatomic,strong)UIColor * bgColor;
//显示文字颜色
@property (nonatomic,strong)UIColor * titleColor;
//显示文字大小
@property (nonatomic,assign)double    titleFont;
//显示文字的时间
@property (nonatomic,assign)double    titleTime;
//上间距
@property (nonatomic,assign)double    topSpace;
//下间距
@property (nonatomic,assign)double    bottomSpace;
//左间距
@property (nonatomic,assign)double    leftSpace;
//右间距
@property (nonatomic,assign)double    rightSpace;
//图片文字间距
@property (nonatomic,assign)double    itemSpace;
//图片默认大小
@property (nonatomic,assign)double    imageWidthHeight;
//hud在底部时 距离底部多远
@property (nonatomic,assign)double    bottomFarHeight;
//显示期间，父视图是否接受事件 默认不接受
@property (nonatomic,assign)BOOL      superReceiveEvent;
//显示位置（中、下）
@property (nonatomic,assign)LXGProgressHUDType  hudType;
//图片显示位置（中、下）
@property (nonatomic,assign)LXGProgressHUDImageType  imageType;
@end
@implementation LXGProgressHUD
#pragma mark-------------------------------------------------------------配置
+(instancetype)sharedLXGProgressHUD{
    static LXGProgressHUD * progressHUD;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        progressHUD                   = [[LXGProgressHUD alloc]init];
        progressHUD.superView         = [UIApplication sharedApplication].keyWindow;
        progressHUD.bgColor           = [UIColor lightGrayColor];
        progressHUD.titleColor        = [UIColor whiteColor];
        progressHUD.titleFont         = 15.0;
        progressHUD.titleTime         = 2.0;
        progressHUD.topSpace          = 10.0;
        progressHUD.bottomSpace       = 10.0;
        progressHUD.leftSpace         = 10.0;
        progressHUD.rightSpace        = 10.0;
        progressHUD.itemSpace         = 5.0;
        progressHUD.imageWidthHeight  = 30.0;
        progressHUD.bottomFarHeight   = 50.0;
        progressHUD.superReceiveEvent = NO;
        progressHUD.hudType           = LXGProgressHUDType_Center;
        progressHUD.imageType         = LXGProgressHUDImageType_Left;
    });
    return progressHUD;
}
//父视图                   默认[UIApplication sharedApplication].keyWindow
+ (void)showSuperView:(UIView *)superView{
    [LXGProgressHUD sharedLXGProgressHUD].superView = superView;
}
//显示背景颜色              默认[UIColor lightGrayColor]
+ (void)showBgColor:(UIColor *)bgColor{
    [LXGProgressHUD sharedLXGProgressHUD].bgColor = bgColor;
}
//显示文字颜色              默认[UIColor whiteColor]
+ (void)showTitleColor:(UIColor *)titleColor{
    [LXGProgressHUD sharedLXGProgressHUD].titleColor = titleColor;
}
//显示文字大小              默认15.0
+ (void)showTitleFont:(double)titleFont{
    [LXGProgressHUD sharedLXGProgressHUD].titleFont = titleFont;
}
//显示文字的时间             默认2.0
+ (void)showTitleTime:(double)titleTime{
    [LXGProgressHUD sharedLXGProgressHUD].titleTime = titleTime;
}
//内容上间距                默认10.0
+ (void)showTopSpace:(double)topSpace{
    [LXGProgressHUD sharedLXGProgressHUD].topSpace = topSpace;
}
//内容下间距                默认10.0
+ (void)showBottomSpace:(double)bottomSpace{
    [LXGProgressHUD sharedLXGProgressHUD].bottomSpace = bottomSpace;
}
//内容左间距                默认10.0
+ (void)showLeftSpace:(double)leftSpace{
    [LXGProgressHUD sharedLXGProgressHUD].leftSpace = leftSpace;
}
//内容右间距                默认10.0
+ (void)showRightSpace:(double)rightSpace{
    [LXGProgressHUD sharedLXGProgressHUD].rightSpace = rightSpace;
}
//文字和图片的间距           默认5.0
+ (void)showItemSpace:(double)itemSpace{
    [LXGProgressHUD sharedLXGProgressHUD].itemSpace = itemSpace;
}
//图片大小                 默认30.0 * 30.0
+ (void)showImageWidthHeight:(double)imageWidthHeight{
    [LXGProgressHUD sharedLXGProgressHUD].imageWidthHeight = imageWidthHeight;
}
//hud在底部时 距离底部多远   默认50.0
+ (void)showBottomFarHeight:(double)bottomFarHeight{
    [LXGProgressHUD sharedLXGProgressHUD].bottomFarHeight = bottomFarHeight;
}
//显示期间，父视图是否接受事件 默认NO
+ (void)showSuperReceiveEvent:(BOOL)superReceiveEvent{
    [LXGProgressHUD sharedLXGProgressHUD].superReceiveEvent = superReceiveEvent;
}
//HUD显示位置（中、下）      默认LXGProgressHUDType_Center
+ (void)showHudType:(LXGProgressHUDType)hudType{
    [LXGProgressHUD sharedLXGProgressHUD].hudType = hudType;
}
//图片显示位置（左、上）      默认LXGProgressHUDImageType_Left
+ (void)showImageType:(LXGProgressHUDImageType)imageType{
    [LXGProgressHUD sharedLXGProgressHUD].imageType = imageType;
}
#pragma mark-------------------------------------------------------------文字图片显示
//纯文字
+ (void)showText:(NSString *)text{
    [self showImage:@"" andShowText:text andIsRotation:NO];
}
//纯图片
+ (void)showImage:(NSString *)imageName{
    [self showImage:imageName andShowText:@"" andIsRotation:NO];
}
//图片加文字
+ (void)showImage:(NSString *)imageName andShowText:(NSString *)text{
    [self showImage:imageName andShowText:text andIsRotation:NO];
}
//图片加文字加图片旋转
+ (void)showImage:(NSString *)imageName andShowText:(NSString *)text andIsRotation:(BOOL)isRotation{
    [self showImageArray:@[imageName] andShowText:text andIsRotation:isRotation];
}
//图片加文字加图片动画
+ (void)showImageArray:(NSArray *)imageNameArray andShowText:(NSString *)text andIsRotation:(BOOL)isRotation{
    //UIKit不是线程安全 所以要回主线程
    NSAssert([NSThread isMainThread], @"needs to be accessed on the main thread.");
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
        });
    }
    //显示之前隐藏还在显示的视图
    [self dissMiss];
    LXGProgressHUDbgView * bgView  = [[LXGProgressHUDbgView alloc]init];
    bgView.backgroundColor         = [[UIColor blackColor]colorWithAlphaComponent:0.2];
    [[LXGProgressHUD sharedLXGProgressHUD].superView addSubview:bgView];
    LXGProgressHUDView   * hudView = [[LXGProgressHUDView alloc]init];
    hudView.backgroundColor        = [LXGProgressHUD sharedLXGProgressHUD].bgColor;
    [bgView addSubview:hudView];
    [self changeFrameWithBgView:bgView andHudView:hudView andImageArray:imageNameArray.firstObject andShowText:text];
    [self changeFrameWithHudView:hudView andImageArray:imageNameArray andShowText:text andIsRotationR:isRotation];
}
//bgView坐标和hud坐标
+(void)changeFrameWithBgView:(UIView *)bgView andHudView:(UIView *)hudView andImageArray:(NSString *)imageName andShowText:(NSString *)text{
    CGSize bgViewSize  = [self getbgViewSizeWithShowImage:imageName andShowText:text];
    CGSize hudViewSize = [self gethudViewSizeWithShowImage:imageName andShowText:text];
    if([LXGProgressHUD sharedLXGProgressHUD].superReceiveEvent){//背景和hud一样大
        bgView.layer.cornerRadius     = 10.0;
        hudView.layer.cornerRadius    = 10.0;
        CGFloat bgx                   = ([LXGProgressHUD sharedLXGProgressHUD].superView.frame.size.width - bgViewSize.width)/2.0;
        if([LXGProgressHUD sharedLXGProgressHUD].hudType == LXGProgressHUDType_Center){//hud在中间
            bgView.frame     = CGRectMake(bgx, ([LXGProgressHUD sharedLXGProgressHUD].superView.frame.size.height - bgViewSize.height)/2.0, bgViewSize.width, bgViewSize.height);
        }else{//hud在底部
            if(@available(iOS 11.0, *)){
                bgView.frame = CGRectMake(bgx, [LXGProgressHUD sharedLXGProgressHUD].superView.frame.size.height - [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom - bgViewSize.height - [LXGProgressHUD sharedLXGProgressHUD].bottomFarHeight, bgViewSize.width, bgViewSize.height);
            }else{
                bgView.frame = CGRectMake(bgx, [LXGProgressHUD sharedLXGProgressHUD].superView.frame.size.height - [self currentViewController].bottomLayoutGuide.length - bgViewSize.height - [LXGProgressHUD sharedLXGProgressHUD].bottomFarHeight, bgViewSize.width, bgViewSize.height);
            }
        }
        hudView.frame= CGRectMake(0, 0, hudViewSize.width, hudViewSize.height);
    }else{//背景和父视图一样大
        bgView.layer.cornerRadius     = 0.0;
        hudView.layer.cornerRadius    = 10.0;
        bgView.frame                  = CGRectMake(0, 0, bgViewSize.width, bgViewSize.height);
        CGFloat hudx                  = (bgViewSize.width - hudViewSize.width)/2.0;
        if([LXGProgressHUD sharedLXGProgressHUD].hudType == LXGProgressHUDType_Center){//hud在中间
            hudView.frame     = CGRectMake(hudx, (bgViewSize.height - hudViewSize.height)/2.0, hudViewSize.width, hudViewSize.height);
        }else{//hud在底部
            if (@available(iOS 11.0, *)){
                hudView.frame = CGRectMake(hudx, bgViewSize.height - [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom - hudViewSize.height - [LXGProgressHUD sharedLXGProgressHUD].bottomFarHeight, hudViewSize.width, hudViewSize.height);
            }else{
                hudView.frame = CGRectMake(hudx, bgViewSize.height - [self currentViewController].bottomLayoutGuide.length - hudViewSize.height - [LXGProgressHUD sharedLXGProgressHUD].bottomFarHeight, hudViewSize.width, hudViewSize.height);
            }
        }
    }
}
//imageView坐标和titleLable坐标
+(void)changeFrameWithHudView:(LXGProgressHUDView *)hudView andImageArray:(NSArray *)imageNameArray andShowText:(NSString *)text andIsRotationR:(BOOL)isRotation{
    CGSize textSize = [self getWidthWithString:text];
    if (imageNameArray.count && !text.length){//只有图片
        hudView.imageView.frame    = CGRectMake([LXGProgressHUD sharedLXGProgressHUD].leftSpace, [LXGProgressHUD sharedLXGProgressHUD].topSpace, [LXGProgressHUD sharedLXGProgressHUD].imageWidthHeight , [LXGProgressHUD sharedLXGProgressHUD].imageWidthHeight);
        hudView.titleLable.frame   = CGRectMake(0, 0, 0, 0);
        if (imageNameArray.count > 1){//多张图片
            NSMutableArray * images = [NSMutableArray array];
            for (int i = 0; i < imageNameArray.count; i ++) {
                [images addObject:[UIImage imageNamed:imageNameArray[i]]];
            }
            hudView.imageView.animationImages      = images;
            hudView.imageView.animationDuration    = 0.4 ;
            hudView.imageView.animationRepeatCount = 0;
            [hudView.imageView startAnimating];
        }else{
            hudView.imageView.image    = [UIImage imageNamed:imageNameArray.firstObject];
        }
        if (isRotation) {
            [self rotationWithImageView:hudView.imageView];
        }
    }else if (!imageNameArray.count && text.length){//只有文字
        hudView.imageView.frame    = CGRectMake(0, 0, 0, 0);
        hudView.titleLable.text    = text;
        hudView.titleLable.frame   = CGRectMake([LXGProgressHUD sharedLXGProgressHUD].leftSpace, [LXGProgressHUD sharedLXGProgressHUD].topSpace, textSize.width, textSize.height);
        hudView.titleLable.lineBreakMode   = NSLineBreakByWordWrapping;
        hudView.titleLable.textAlignment   = NSTextAlignmentCenter;
        hudView.titleLable.textColor       = [LXGProgressHUD sharedLXGProgressHUD].titleColor;
        hudView.titleLable.font            = [UIFont systemFontOfSize:[LXGProgressHUD sharedLXGProgressHUD].titleFont];
        [self dissMissWithTime:[LXGProgressHUD sharedLXGProgressHUD].titleTime];
    }else{
        if ([LXGProgressHUD sharedLXGProgressHUD].imageType == LXGProgressHUDImageType_Left){//图片在左
            hudView.imageView.frame  = CGRectMake([LXGProgressHUD sharedLXGProgressHUD].leftSpace, [LXGProgressHUD sharedLXGProgressHUD].topSpace, [LXGProgressHUD sharedLXGProgressHUD].imageWidthHeight , [LXGProgressHUD sharedLXGProgressHUD].imageWidthHeight);
            hudView.titleLable.frame = CGRectMake([LXGProgressHUD sharedLXGProgressHUD].leftSpace + [LXGProgressHUD sharedLXGProgressHUD].imageWidthHeight + [LXGProgressHUD sharedLXGProgressHUD].itemSpace, [LXGProgressHUD sharedLXGProgressHUD].topSpace, textSize.width, [LXGProgressHUD sharedLXGProgressHUD].imageWidthHeight);
        }else{//图片在上
            if (textSize.width > [LXGProgressHUD sharedLXGProgressHUD].imageWidthHeight) {//字宽比图片宽 以字为准
                hudView.imageView.frame  = CGRectMake((hudView.frame.size.width - [LXGProgressHUD sharedLXGProgressHUD].imageWidthHeight)/2.0, [LXGProgressHUD sharedLXGProgressHUD].topSpace, [LXGProgressHUD sharedLXGProgressHUD].imageWidthHeight , [LXGProgressHUD sharedLXGProgressHUD].imageWidthHeight);
                hudView.titleLable.frame = CGRectMake([LXGProgressHUD sharedLXGProgressHUD].leftSpace, [LXGProgressHUD sharedLXGProgressHUD].topSpace + [LXGProgressHUD sharedLXGProgressHUD].imageWidthHeight + [LXGProgressHUD sharedLXGProgressHUD].itemSpace, textSize.width, textSize.height);
            }else{//图片比字宽 以图片为准
                hudView.imageView.frame  = CGRectMake([LXGProgressHUD sharedLXGProgressHUD].leftSpace, [LXGProgressHUD sharedLXGProgressHUD].topSpace, [LXGProgressHUD sharedLXGProgressHUD].imageWidthHeight , [LXGProgressHUD sharedLXGProgressHUD].imageWidthHeight);
                hudView.titleLable.frame = CGRectMake([LXGProgressHUD sharedLXGProgressHUD].leftSpace, [LXGProgressHUD sharedLXGProgressHUD].topSpace + [LXGProgressHUD sharedLXGProgressHUD].imageWidthHeight + [LXGProgressHUD sharedLXGProgressHUD].itemSpace, textSize.width, textSize.height);
            }
        }
        if (imageNameArray.count > 1){//多张图片
            NSMutableArray * images = [NSMutableArray array];
            for (int i = 0; i < imageNameArray.count; i ++) {
                [images addObject:[UIImage imageNamed:imageNameArray[i]]];
            }
            hudView.imageView.animationImages      = images;
            hudView.imageView.animationDuration    = 0.4 ;
            hudView.imageView.animationRepeatCount = 0;
            [hudView.imageView startAnimating];
        }else{
            hudView.imageView.image        = [UIImage imageNamed:imageNameArray.firstObject];
        }
        hudView.titleLable.text            = text;
        hudView.titleLable.lineBreakMode   = NSLineBreakByWordWrapping;
        hudView.titleLable.textAlignment   = NSTextAlignmentLeft;
        hudView.titleLable.textColor       = [LXGProgressHUD sharedLXGProgressHUD].titleColor;
        hudView.titleLable.font            = [UIFont systemFontOfSize:[LXGProgressHUD sharedLXGProgressHUD].titleFont];
        if (isRotation) {
            [self rotationWithImageView:hudView.imageView];
        }
    }
}
//得到bgViewSize
+(CGSize)getbgViewSizeWithShowImage:(NSString *)imageName andShowText:(NSString *)text{
    if([LXGProgressHUD sharedLXGProgressHUD].superReceiveEvent){
        return [self gethudViewSizeWithShowImage:imageName andShowText:text];
    }else{
        return [LXGProgressHUD sharedLXGProgressHUD].superView.bounds.size;
    }
}
//得到hudViewSize
+(CGSize)gethudViewSizeWithShowImage:(NSString *)imageName andShowText:(NSString *)text{
    CGFloat hudWidth  = 0;
    CGFloat hudHight  = 0;
    CGSize  textSize  = [self getWidthWithString:text];
    if (imageName.length && !text.length){//只有图片
        hudWidth = [LXGProgressHUD sharedLXGProgressHUD].leftSpace + [LXGProgressHUD sharedLXGProgressHUD].imageWidthHeight + [LXGProgressHUD sharedLXGProgressHUD].rightSpace;
        hudHight = [LXGProgressHUD sharedLXGProgressHUD].topSpace  + [LXGProgressHUD sharedLXGProgressHUD].imageWidthHeight + [LXGProgressHUD sharedLXGProgressHUD].bottomSpace;
    }else if (!imageName.length && text.length){//只有文字
        hudWidth = [LXGProgressHUD sharedLXGProgressHUD].leftSpace + textSize.width  + [LXGProgressHUD sharedLXGProgressHUD].rightSpace;
        hudHight = [LXGProgressHUD sharedLXGProgressHUD].topSpace  + textSize.height + [LXGProgressHUD sharedLXGProgressHUD].bottomSpace;
    }else {//图片文字
        if ([LXGProgressHUD sharedLXGProgressHUD].imageType == LXGProgressHUDImageType_Left) {//图片在左
            hudWidth = [LXGProgressHUD sharedLXGProgressHUD].leftSpace + [LXGProgressHUD sharedLXGProgressHUD].imageWidthHeight + [LXGProgressHUD sharedLXGProgressHUD].itemSpace + textSize.width + [LXGProgressHUD sharedLXGProgressHUD].rightSpace;
            hudHight = [LXGProgressHUD sharedLXGProgressHUD].topSpace  + [LXGProgressHUD sharedLXGProgressHUD].imageWidthHeight + [LXGProgressHUD sharedLXGProgressHUD].bottomSpace;
        }else{//图片在上
            if (textSize.width > [LXGProgressHUD sharedLXGProgressHUD].imageWidthHeight) {
                hudWidth = [LXGProgressHUD sharedLXGProgressHUD].leftSpace + textSize.width + [LXGProgressHUD sharedLXGProgressHUD].rightSpace;
                hudHight = [LXGProgressHUD sharedLXGProgressHUD].topSpace  + [LXGProgressHUD sharedLXGProgressHUD].imageWidthHeight + [LXGProgressHUD sharedLXGProgressHUD].itemSpace + textSize.height + [LXGProgressHUD sharedLXGProgressHUD].bottomSpace;
            }else{
                hudWidth = [LXGProgressHUD sharedLXGProgressHUD].leftSpace + [LXGProgressHUD sharedLXGProgressHUD].imageWidthHeight + [LXGProgressHUD sharedLXGProgressHUD].rightSpace;
                hudHight = [LXGProgressHUD sharedLXGProgressHUD].topSpace  + [LXGProgressHUD sharedLXGProgressHUD].imageWidthHeight + [LXGProgressHUD sharedLXGProgressHUD].itemSpace + textSize.height + [LXGProgressHUD sharedLXGProgressHUD].bottomSpace;
            }
        }
    }
    if (hudWidth > [UIScreen mainScreen].bounds.size.width){
        hudWidth = [UIScreen mainScreen].bounds.size.width;
    }
    return CGSizeMake(hudWidth, hudHight);
}
//文字宽度
+ (CGSize)getWidthWithString:(NSString*)string{
    NSDictionary * dic = @{NSFontAttributeName:[UIFont systemFontOfSize:[LXGProgressHUD sharedLXGProgressHUD].titleFont]};
    CGRect        rect = [string boundingRectWithSize:CGSizeMake(0, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size;
}
//隐藏
+(void)dissMiss{
    [self removeUI];
}
//几秒后隐藏 不传使用默认值
+(void)dissMissWithTime:(double)time{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeUI];
    });
}
//移除
+(void)removeUI{
    NSEnumerator * subviewsEnum = [[LXGProgressHUD sharedLXGProgressHUD].superView.subviews reverseObjectEnumerator];
    for (UIView  * subview in subviewsEnum) {
        if ([subview isKindOfClass:[LXGProgressHUDbgView class]]) {
            LXGProgressHUDbgView * loading = (LXGProgressHUDbgView *)subview;
            [loading removeFromSuperview];
        }
    }
}
//旋转
+ (void)rotationWithImageView:(UIImageView *)imageView{
    CABasicAnimation * rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue          = [NSNumber numberWithFloat: 0];
    rotationAnimation.toValue            = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration           = 1;
    rotationAnimation.cumulative         = YES;
    rotationAnimation.removedOnCompletion= NO;
    rotationAnimation.fillMode           = kCAFillModeForwards;
    rotationAnimation.repeatCount        = HUGE_VALF;
    [imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
//获取当前控制器
+(UIViewController *)currentViewController{
    UIViewController * rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
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
+(UIViewController *)deepestPresentedViewControllerOf:(UIViewController *)viewController{
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
@end
