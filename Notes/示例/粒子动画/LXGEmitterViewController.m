//
//  LXGEmitterViewController.m
//  Notes
//
//  Created by 龙兴国 on 2019/9/12.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGEmitterViewController.h"
#import "LXGEmitterView.h"
#import "LXGWaterView.h"
@interface LXGEmitterViewController ()
@property (nonatomic ,strong)LXGWaterView * waterView;
@property (nonatomic, strong) CAEmitterLayer *caELayer;
@end

@implementation LXGEmitterViewController
-(void)creatUI2{
    
    self.view.backgroundColor       = [UIColor blackColor];
    //
    self.caELayer                   = [CAEmitterLayer layer];
    // 发射源
    self.caELayer.emitterPosition   = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 50);
    // 发射源尺寸大小
    self.caELayer.emitterSize       = CGSizeMake(50, 0);
    // 发射源模式
    self.caELayer.emitterMode       = kCAEmitterLayerOutline;
    // 发射源的形状
    self.caELayer.emitterShape      = kCAEmitterLayerLine;
    // 渲染模式
    self.caELayer.renderMode        = kCAEmitterLayerAdditive;
    // 发射方向
    self.caELayer.velocity          = 1;
    // 随机产生粒子
    self.caELayer.seed              = (arc4random() % 100) + 1;
       
    // 子弹粒子
    CAEmitterCell *cell             = [CAEmitterCell emitterCell];
    // 速率
    cell.birthRate                  = 1.0;
    // 发射的角度
    cell.emissionRange              = 0.11 * M_PI;
    // 速度
    cell.velocity                   = 300;
    // 范围
    cell.velocityRange              = 150;
    // Y轴 加速度分量
    cell.yAcceleration              = 75;
    // 声明周期
    cell.lifetime                   = 2.04;
    //是个CGImageRef的对象,既粒子要展现的图片
    cell.contents                   = (id)
    [[UIImage imageNamed:@"Weather_heat"] CGImage];
    // 缩放比例
    cell.scale                      = 0.2;
    // 粒子的颜色
    cell.color                      = [[UIColor colorWithRed:0.6
                                                       green:0.6
                                                        blue:0.6
                                                       alpha:1.0] CGColor];
    // 一个粒子的颜色green 能改变的范围
    cell.greenRange                 = 1.0;
    // 一个粒子的颜色red 能改变的范围
    cell.redRange                   = 1.0;
    // 一个粒子的颜色blue 能改变的范围
    cell.blueRange                  = 1.0;
    // 子旋转角度范围
    cell.spinRange                  = M_PI;
    
    
    // 爆炸
    CAEmitterCell *burst            = [CAEmitterCell emitterCell];
    // 粒子产生系数
    burst.birthRate                 = 1.0;
    // 速度
    burst.velocity                  = 0;
    // 缩放比例
    burst.scale                     = 2.5;
    // shifting粒子red在生命周期内的改变速度
    burst.redSpeed                  = -1.5;
    // shifting粒子blue在生命周期内的改变速度
    burst.blueSpeed                 = +1.5;
    // shifting粒子green在生命周期内的改变速度
    burst.greenSpeed                = +1.0;
    //生命周期
    burst.lifetime                  = 0.35;
    
    // 火花
    CAEmitterCell *spark            = [CAEmitterCell emitterCell];
    //粒子产生系数，默认为1.0
    spark.birthRate                 = 400;
    //速度
    spark.velocity                  = 125;
    // 360 deg//周围发射角度
    spark.emissionRange             = 2 * M_PI;
    // gravity//y方向上的加速度分量
    spark.yAcceleration             = 75;
    //粒子生命周期
    spark.lifetime                  = 3;
    //是个CGImageRef的对象,既粒子要展现的图片
    spark.contents                  = (id)
    [[UIImage imageNamed:@"Weather_heat"] CGImage];
    //缩放比例速度
    spark.scaleSpeed                = -0.2;
    //粒子green在生命周期内的改变速度
    spark.greenSpeed                = -0.1;
    //粒子red在生命周期内的改变速度
    spark.redSpeed                  = 0.4;
    //粒子blue在生命周期内的改变速度
    spark.blueSpeed                 = -0.1;
    //粒子透明度在生命周期内的改变速度
    spark.alphaSpeed                = -0.25;
    //子旋转角度
    spark.spin                      = 2* M_PI;
    //子旋转角度范围
    spark.spinRange                 = 2* M_PI;
    // 3种粒子组合，可以根据顺序，依次烟花弹－烟花弹粒子爆炸－爆炸散开粒子
    self.caELayer.emitterCells = [NSArray arrayWithObject:cell];
    cell.emitterCells          = [NSArray arrayWithObjects:burst, nil];
    burst.emitterCells         = [NSArray arrayWithObject:spark];
    [self.view.layer addSublayer:self.caELayer];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //[self creatUI1];
    [self creatUI2];
}
-(void)creatUI1{
        LXGEmitterView *  EmitterView = [[LXGEmitterView alloc]initWithFrame:CGRectMake(100, 200, 100, 100)];
        [self.view addSubview:EmitterView];
        //
        self.waterView = [[LXGWaterView alloc] initWithFrame:CGRectMake(100, 300, 200,200)];
        [self.view addSubview:self.waterView];
        [self.waterView beginAnimation];
        
        UIButton * button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 500, 50, 50)];
        button1.backgroundColor = [UIColor redColor];
        [button1 addTarget:self action:@selector(button1Click) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button1];
        //
        UIButton * button2 = [[UIButton alloc]initWithFrame:CGRectMake(60, 500, 50, 50)];
        button2.backgroundColor = [UIColor redColor];
        [button2 addTarget:self action:@selector(button2Click) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button2];
        //
        UIButton * button3      = [[UIButton alloc]initWithFrame:CGRectMake(120, 500, 100, 50)];
        button3.backgroundColor = [UIColor redColor];
    //    [button3 setImage:[UIImage imageNamed:@"icon_hud_9"] forState:UIControlStateNormal];
        [button3 setTitle:@"123456" forState:UIControlStateNormal];
        [button3 addTarget:self action:@selector(button3Click) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button3];
        NSLog(@"%@ 文字",NSStringFromUIEdgeInsets(button3.titleEdgeInsets));
        NSLog(@"%@ 图片",NSStringFromUIEdgeInsets(button3.imageEdgeInsets));
        NSLog(@"%@",button3.titleLabel.font);
}
-(void)button1Click{
    self.waterView.type = LXGBorderPathType_heart;
}
-(void)button2Click{
    self.waterView.type = LXGBorderPathType_circle;
}
-(void)button3Click{
    self.waterView.type = LXGBorderPathType_stars;
}
@end
/*
 如果options参数为NSStringDrawingUsesLineFragmentOrigin，那么整个文本将以每行组成的矩形为单位计算整个文本的尺寸。
 （在这里有点奇怪，因为字体高度大概是13.8，textView中大概有10行文字，此时用该选项计算出来的只有5行，即高度为69。
 
 而同时使用
 NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin却可以得出文字刚好有10行，即高度为138，这里要等iOS7官方的文档出来再看看选项的说明，因为毕竟以上文档是iOS6的东西）
 
 如果为
 NSStringDrawingTruncatesLastVisibleLine
 或者NSStringDrawingUsesDeviceMetric，那么计算文本尺寸时将以每个字或字形为单位来计算。
 
 如果为
 NSStringDrawingUsesFontLeading则以字体间的行距（leading，行距：从一行文字的底部到另一行文字底部的间距。）来计算。
 各个参数是可以组合使用的，如NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine。
 根据该方法调整一下Reader的分页方法：（主要是将被iOS7 Deprecated的sizeWithFont:constrainedToSize:lineBreakMode:方法改成了boudingRectWithSize:options:attributes:context:方法来计算文本尺寸）*/
