//
//  LXGRollingViewController.m
//  Notes
//
//  Created by 龙兴国 on 2019/9/11.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGRollingViewController.h"
#import "LXGRollingView.h"
@interface LXGRollingViewController ()
@property (nonatomic, strong) LXGRollingView * cycleScrollView;
@end
@implementation LXGRollingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.cycleScrollView                  = [[LXGRollingView alloc] initWithFrame:CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width - 40, 40)];
    self.cycleScrollView.time             = 2;
    self.cycleScrollView.backgroundColor  = [UIColor orangeColor];
    self.cycleScrollView.titleColor       = [UIColor blackColor];
    self.cycleScrollView.titleFont        = [UIFont systemFontOfSize:13];
    [self.view addSubview:self.cycleScrollView];
    self.cycleScrollView.titleArray = [NSArray arrayWithObjects:
                                       @"微软CEO：我们没有放弃智能手机 会来点不一样的",
                                       @"李彦宏发内部信，再次强调人工智能战略",
                                       @"iPhone 8会亮相6月WWDC吗？分析师为此互相打脸",
                                       @"孙宏斌：乐视汽车贾跃亭该怎么弄怎么弄，其他的该卖的卖掉",
                                       nil];
    
    [self.cycleScrollView setSelectedBlock:^(NSInteger index, NSString *title) {
        NSLog(@"%zd-----%@",index,title);
    }];
    UIButton * button  = [[UIButton alloc]initWithFrame:CGRectMake(20, 200, 50, 50)];
    [button setTitle:@"暂停" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
-(void)buttonClick{
    [self.cycleScrollView removeTimer];
    [self.cycleScrollView removeFromSuperview];
    self.cycleScrollView  = nil;
}
@end
