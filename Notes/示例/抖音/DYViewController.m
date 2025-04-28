//
//  DYViewController.m
//  Notes
//
//  Created by 龙兴国 on 2024/3/13.
//  Copyright © 2024 龙兴国. All rights reserved.
//

#import "DYViewController.h"

@interface DYViewController ()
@property (nonatomic, strong) UIView * playLoadingView;
@end

@implementation DYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playLoadingView = [[UIView alloc]init];
    self.playLoadingView.backgroundColor = [UIColor redColor];
    //[self.playLoadingView setHidden:YES];
    [self.view addSubview:self.playLoadingView];

    //make constraintes
    [self.playLoadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(5.0);
        make.height.mas_equalTo(2.5);
    }];

    [self startLoadingPlayAnimation:YES]; //调用动画代码
}
- (void)startLoadingPlayAnimation:(BOOL)isStart {
    if (isStart) {
        self.playLoadingView.backgroundColor = [UIColor redColor];
        self.playLoadingView.hidden = NO;
        [self.playLoadingView.layer removeAllAnimations];

        CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc] init];
        animationGroup.duration = 1;
        animationGroup.beginTime = CACurrentMediaTime() + 0.5;
        animationGroup.repeatCount = MAXFLOAT;
        animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

        CABasicAnimation *scaleAnimation = [CABasicAnimation animation];
        scaleAnimation.keyPath = @"transform.scale.x";
        scaleAnimation.fromValue = @(5.0f);
        scaleAnimation.toValue = @(5.0f * LScreenWidth);

        CABasicAnimation *alphaAnimation = [CABasicAnimation animation];
        alphaAnimation.keyPath = @"opacity";
        alphaAnimation.fromValue = @(5.0f);
        alphaAnimation.toValue = @(2.5f);

        [animationGroup setAnimations:@[scaleAnimation, alphaAnimation]];
        [self.playLoadingView.layer addAnimation:animationGroup forKey:nil];
    } else {
        [self.playLoadingView.layer removeAllAnimations];
        self.playLoadingView.hidden = YES;
    }
}
@end
