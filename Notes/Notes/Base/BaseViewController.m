//
//  BaseViewController.m
//  hwweather
//
//  Created by 龙兴国 on 2019/5/13.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "BaseViewController.h"
#import "AFNetworkReachabilityManager.h"
@interface BaseViewController ()
@property (nonatomic, assign) AFNetworkReachabilityStatus reachStatus;
@end
@implementation BaseViewController
//标题样式
- (NSDictionary<NSAttributedStringKey, id> *)titleTextAttributes{
    return @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}
//背景图片
- (UIImage *)navigationBarImage {
    return LColorImage(@"508CF0");
}
//返回按钮图片
- (UIImage *)navBackImage {
    return [UIImage imageNamed:@"icon_nav_back"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.enablePopGesture = YES;
    [self creatleftBarButtonItem];
    [self creatNoti];
}
- (void)creatleftBarButtonItem{
    if (self.navigationController.viewControllers.count > 1){
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame     = CGRectMake(0, 0, 44, 44);
        [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
        [backButton addTarget:self action:@selector(navBackAction) forControlEvents:UIControlEventTouchUpInside];
        [backButton setImage:[self navBackImage] forState:UIControlStateNormal];
        UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backItem;
    }
}
- (void)navBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)creatNoti{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}
- (void)networkDidChanged:(NSNotification *)notification {
    NSDictionary *userInfo       = notification.userInfo;
    NSInteger currentReachStatus = [userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
    if (self.reachStatus == AFNetworkReachabilityStatusNotReachable &&
        (currentReachStatus == AFNetworkReachabilityStatusReachableViaWWAN || currentReachStatus == AFNetworkReachabilityStatusReachableViaWiFi)) {
        [self updateViewWhenNetworkChanged];
    }else{
        [LXGPublicTool alert:@"检测到您当前网络已断开,请检查您的网络设置"];
    }
    self.reachStatus = currentReachStatus;
}
- (void)updateViewWhenNetworkChanged{
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.viewWillAppearInjectBlock) {
        self.viewWillAppearInjectBlock(self, animated);
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.viewDidAppearInjectBlock) {
        self.viewDidAppearInjectBlock(self, animated);
    }
}
@end
