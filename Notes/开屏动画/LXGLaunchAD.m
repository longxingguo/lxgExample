//
//  LXGLaunchAD.m
//  Notes
//
//  Created by 龙兴国 on 2019/9/11.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGLaunchAD.h"
@interface LXGLaunchAD ()
//全局 防止释放
@property (nonatomic, strong) UIWindow * window;
//按钮
@property (nonatomic, strong) UIButton * downCountButton;
//倒计时
@property (nonatomic, assign) NSInteger  downCount;
@end
@implementation LXGLaunchAD
+ (void)load{
    [self shareLXGLaunchAD];
}
+ (instancetype)shareLXGLaunchAD{
    static LXGLaunchAD   * launchAD;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        launchAD = [[self alloc] init];
    });
    return launchAD;
}
- (instancetype)init{
    if (self = [super init]) {
        ///应用启动, 首次开屏广告  如果是没啥经验的开发，请不要在初始化的代码里面做别的事，防止对主线程的卡顿，和 其他情况
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            ///要等DidFinished方法结束后才能初始化UIWindow，不然会检测是否有rootViewController
             [self checkAD];
        }];
        ///进入后台
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [self requestAD];
        }];
        ///后台启动,二次开屏广告
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
             [self checkAD];
        }];
    }
    return self;
}
- (void)checkAD{
    //检查广告 数据存在 显示
    [self show];
}
- (void)show{
    ///初始化一个Window， 做到对业务视图无干扰。
    self.window                                          = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController                       = [UIViewController new];
    self.window.rootViewController.view.backgroundColor  = [UIColor clearColor];
    ///设置为最顶层，防止 AlertView 等弹窗的覆盖
    self.window.windowLevel                              = UIWindowLevelStatusBar + 1;
    ///默认为YES，当你设置为NO时，这个Window就会显示了
    self.window.hidden                                   = NO;
    self.window.alpha                                    = 1;
    ///广告布局
    [self setupSubviews:self.window];
}
- (void)setupSubviews:(UIWindow*)window{
    //图片
    UIImageView * imageView          = [[UIImageView alloc] initWithFrame:window.bounds];
    imageView.image                  = [UIImage imageNamed:@"timg.jpg"];
    imageView.userInteractionEnabled = YES;
    [window addSubview:imageView];
    UITapGestureRecognizer * tap     = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(letGo)];
    [imageView addGestureRecognizer:tap];
    //
    self.downCount       = 5;
    self.downCountButton = [[UIButton alloc] initWithFrame:CGRectMake(window.bounds.size.width - 100 - 20, 20, 100, 60)];
    [self.downCountButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:self.downCountButton];
    [self timer];
}
- (void)letGo{
    ///不直接取KeyWindow 是因为当有AlertView 或者有键盘弹出时， 取到的KeyWindow是错误的。
    UIViewController * rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    [[self getNavigationController:rootVC] pushViewController:[UIViewController new] animated:NO];
    [self hide];
}
- (void)timer{
    [self.downCountButton setTitle:[NSString stringWithFormat:@"跳过：%ld",(long)self.downCount] forState:UIControlStateNormal];
    if (self.downCount <= 0) {
        [self hide];
    }else {
        self.downCount --;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self timer];
        });
    }
}
- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.window.alpha  = 0;
    } completion:^(BOOL finished) {
        [self.window.subviews.copy enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        self.window.hidden = YES;
        self.window        = nil;
    }];
}
- (void)requestAD{
    
}
- (UINavigationController *)getNavigationController:(UIViewController *)root{
    UINavigationController * nav = nil;
    if ([root isKindOfClass:[UINavigationController class]]) {
            nav = (id)root;
    }else {
        if ([root isKindOfClass:[UITabBarController class]]){
            nav = [self getNavigationController:((UITabBarController*)root).selectedViewController];
        }else {
            nav = root.navigationController;
        }
    }
    return nav;
}
@end
/*
 1、window需要定义为全局变量。它才不会在方法结束后被销毁。实例化多个window 所有的window都会被加在界面上。
 2、不需要将window add到某个view或window上去。只要alloc了一个window,并且window.hiden = NO,则这个window就会显示
 3、UIWindow显示的时候会根据UIWindowLevel进行排序(keywind是Normal)，Level高的将排在最前面(最顶层) 优先级相等的情况下，谁后实例化谁先显示
 4、UIWindowLevel的值不仅仅只有 Normal 0、 Alert 2000.0、StatusBar 1000.0这三个，可以是自定义的随意值,哪怕是负数
 5、如果将当前KeyWindow对象设置为nil 则该对象会从Windows数组中移除,并且最后实例化的Window对象将成为KeyWindow 。
 */
