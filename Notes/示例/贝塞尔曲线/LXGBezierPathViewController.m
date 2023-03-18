//
//  LXGBezierPathViewController.m
//  Notes
//
//  Created by 龙兴国 on 2019/9/12.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGBezierPathViewController.h"
#import "ProgressBarView.h"
#import "ProgressView.h"
@interface LXGBezierPathViewController ()

@end

@implementation LXGBezierPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIBezierPath];
    [self UIBezierPath1];
    [self UIBezierPath2];
}
- (void)UIBezierPath{
    ProgressBarView *  BarView = [[ProgressBarView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200)];
    BarView.underColor         = [UIColor colorWithRed:173/255.0 green:213/255.0 blue:255/255.0 alpha:1];
    BarView.upperColor         = [UIColor colorWithRed:61/255.0 green:153/255.0 blue:252/255.0 alpha:1];
    BarView.lineWidth          = 15;
    BarView.proGress           = 0.6;
    [self.view addSubview:BarView];
}
- (void)UIBezierPath1{
    //以中心为起点 根据半径绘制  坐标系中 左是π  上是3/2π  右是0或者2π  下是π/2
    UIBezierPath *path    = [UIBezierPath bezierPathWithArcCenter:CGPointMake(200, 450) radius:100 startAngle:M_PI endAngle: M_PI * 2  clockwise:YES];
    CAShapeLayer * layer  = [[CAShapeLayer alloc]init];
    layer.path            = path.CGPath;
    layer.lineCap         = kCALineCapButt;
    layer.lineJoin        = kCALineJoinRound;
    layer.lineWidth       = 20;
    layer.strokeColor     = [UIColor blackColor].CGColor;
    layer.fillColor       = [UIColor clearColor].CGColor;
    layer.strokeEnd       = 0.7;
    layer.lineDashPattern = @[@2, @5, @10];
    [self.view.layer addSublayer:layer];
}
- (void)UIBezierPath2{
    ProgressView * BarView = [[ProgressView alloc]initWithFrame:CGRectMake(0, 600, self.view.frame.size.width, 100)];
    BarView.underColor     = [UIColor colorWithRed:61/255.0 green:177/255.0 blue:237/255.0 alpha:1];
    BarView.underFillColor = [UIColor clearColor];
    BarView.upperColor     = [UIColor whiteColor];
    BarView.upperFillColor = [UIColor colorWithRed:49/255.0 green:144/255.0 blue:250/255.0 alpha:1];
    BarView.unlineWidth    = 10;
    BarView.uplineWidth    = 5;
    BarView.proGress       = 0.6;
    [self.view addSubview:BarView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         BarView.proGress       = 0.7;
    });
}

@end
