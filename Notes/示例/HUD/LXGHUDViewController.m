//
//  LXGHUDViewController.m
//  Notes
//
//  Created by 龙兴国 on 2019/9/12.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGHUDViewController.h"
#import "LXGProgressHUDTool.h"
#import "XLDouYinLoading.h"
@interface LXGHUDViewController ()

@end

@implementation LXGHUDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[LXGProgressHUDTool showHudCenterText:@"恢复后返回回复后付费"];
    NSArray * array = @[@"icon_hud_1",@"icon_hud_2",@"icon_hud_3",@"icon_hud_4",@"icon_hud_5",@"icon_hud_6",@"icon_hud_7",@"icon_hud_8",@"icon_hud_9"];
    [LXGProgressHUDTool showHudImageArray:array andShowText:@"恢复后返回回复后付费" andIsRotation:NO];
//     [XLDouYinLoading showInView:self.view];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [XLDouYinLoading hideInView:self.view];
//    });
}
@end
