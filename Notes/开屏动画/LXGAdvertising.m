//
//  LXGAdvertising.m
//  ShanXiWeather
//
//  Created by 龙兴国 on 2019/7/31.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGAdvertising.h"
#import "XHLaunchAd.h"
@interface LXGAdvertising ()<XHLaunchAdDelegate>
@end
@implementation LXGAdvertising
+(void)load{
    //[self shareManager];
}
+(LXGAdvertising *)shareManager{
    static LXGAdvertising *instance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken,^{
        instance = [[LXGAdvertising alloc] init];
    });
    return instance;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        //在UIApplicationDidFinishLaunching时初始化开屏广告,做到对业务层无干扰,当然你也可以直接在AppDelegate didFinishLaunchingWithOptions方法中初始化
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            //初始化开屏广告
            [self settingAdvertising];
        }];
    }
    return self;
}
- (void)settingAdvertising{
    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
    [XHLaunchAd setLaunchSourceType:SourceTypeLaunchImage];
    //配置类
    XHLaunchImageAdConfiguration *imageAdconfiguration = [[XHLaunchImageAdConfiguration alloc]init];
    //广告停留时间
    imageAdconfiguration.duration = 5;
    //广告frame
    imageAdconfiguration.frame    = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 0.8);
    //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
    imageAdconfiguration.imageNameOrURLString = @"ShanXiWeatherAdvertising.png";
    //设置GIF动图是否只循环播放一次(仅对动图设置有效)
    imageAdconfiguration.GIFImageCycleOnce = NO;
    //图片填充模式
    imageAdconfiguration.contentMode = UIViewContentModeScaleAspectFill;
    //广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
    //imageAdconfiguration.openModel = @"https://www.baidu.com";//打开的h5地址
    //广告显示完成动画
    imageAdconfiguration.showFinishAnimate = ShowFinishAnimateFlipFromLeft;
    //广告显示完成动画时间
    imageAdconfiguration.showFinishAnimateTime = 0.8;
    //跳过按钮类型
    imageAdconfiguration.skipButtonType = SkipTypeRoundText;
    //后台返回时,是否显示广告
    imageAdconfiguration.showEnterForeground = NO;
    //显示开屏广告
    [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
}
#pragma mark - XHLaunchAd delegate
//MARK:广告计时回调
-(void)xhLaunchAd:(XHLaunchAd *)launchAd customSkipView:(UIView *)customSkipView duration:(NSInteger)duration{
    NSLog(@"广告时间%ld",(long)duration);
}
//MARK: 广告点击事件回调
-(void)xhLaunchAd:(XHLaunchAd *)launchAd clickAndOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint{
    if(openModel == nil){//广告需要打开的模型不存在
        return;
    }
}
//MARK:广告图片下载完成
-(void)xhLaunchAd:(XHLaunchAd *)launchAd imageDownLoadFinish:(UIImage *)image imageData:(NSData *)imageData{
    NSLog(@"图片下载完成/或本地图片读取完成回调");
}
//MARK:广告视频下载完成
-(void)xhLaunchAd:(XHLaunchAd *)launchAd videoDownLoadFinish:(NSURL *)pathURL{
    //video下载/加载完成  存放地址pathURL.absoluteString
      NSLog(@"video下载/加载完成 path = %@",pathURL.absoluteString);
}
//MARK:广告视频下载进度
-(void)xhLaunchAd:(XHLaunchAd *)launchAd videoDownLoadProgress:(float)progress total:(unsigned long long)total current:(unsigned long long)current{
   NSLog(@"总大小=%lld,已下载大小=%lld,下载进度=%f",total,current,progress);
}
//MARK:广告显示完成
-(void)xhLaunchAdShowFinish:(XHLaunchAd *)launchAd{
     NSLog(@"广告显示完成");
}
@end
