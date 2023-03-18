//
//  LXGAudioViewController.m
//  Notes
//
//  Created by 龙兴国 on 2019/9/11.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGAudioViewController.h"
@interface LXGAudioViewController ()
@end
@implementation LXGAudioViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 200, 50, 50)];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    //
    UIButton * button1 = [[UIButton alloc]initWithFrame:CGRectMake(100, 200, 50, 50)];
    button1.backgroundColor = [UIColor redColor];
    [button1 addTarget:self action:@selector(button1Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    //
    UIButton * button2 = [[UIButton alloc]initWithFrame:CGRectMake(200, 200, 50, 50)];
    button2.backgroundColor = [UIColor redColor];
    [button2 addTarget:self action:@selector(button2Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
}
-(void)buttonClick{
    NSString * urlStr = [[NSBundle mainBundle]pathForResource:@"方糖泡泡-白日旧梦.mp3" ofType:nil];
    [[LXGAudioPlayerTool shareAudioPlayerTool]play:urlStr complete:^(BOOL finished) {
        
    } error:^(NSError * _Nonnull error) {
        
    }];
}
-(void)button1Click{
    [[LXGAudioPlayerTool shareAudioPlayerTool]stop];
}
-(void)button2Click{
    [[LXGAudioPlayerTool shareAudioPlayerTool]play];
}
@end
