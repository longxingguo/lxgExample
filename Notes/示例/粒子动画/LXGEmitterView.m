//
//  LXGEmitterView.m
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/30.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGEmitterView.h"
@interface LXGEmitterView ()
@property (nonatomic ,assign) CGSize size;
@property (nonatomic ,assign) CGRect cirframe;
@end
@implementation LXGEmitterView
- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.size     = frame.size;
        self.cirframe = frame;
        [self createCA];
    }return self;
}
- (void)createCA{
    UIBezierPath * path     = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    CAShapeLayer * cirLayer = [CAShapeLayer layer];
    cirLayer.path           = path.CGPath;
    cirLayer.fillColor      = [UIColor redColor].CGColor;
    //渐变layer
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame             = CGRectMake(0, 0, self.size.width, self.size.height);
    gradientLayer.colors            = @[(__bridge id)[UIColor colorWithRed:29/255.0f green:204/255.0f blue:140/255.0f alpha:1].CGColor,
                                        (__bridge id)[UIColor colorWithRed:171/255.0f green:243/255.0f blue:131/255.0f alpha:1].CGColor];
    gradientLayer.startPoint = CGPointMake(0.5f,1);
    gradientLayer.endPoint   = CGPointMake(0.5f, 0);
    [self.layer addSublayer:gradientLayer];
    self.layer.mask = cirLayer;
    //emitterLayer
    CAEmitterLayer * emitterLayer    = [CAEmitterLayer layer];
    emitterLayer.emitterShape        = kCAEmitterLayerPoint;
    emitterLayer.renderMode          = kCAEmitterLayerVolume;
    emitterLayer.emitterSize         = self.size;
    emitterLayer.emitterPosition     = CGPointMake(self.size.width/2, self.size.height);
    //emitterCell
    CAEmitterCell * emitterCell      = [CAEmitterCell emitterCell];
    emitterCell.contents             = (__bridge id)[UIImage imageNamed:@"Weather_heat"].CGImage;
    emitterCell.birthRate            = 5;
    emitterCell.lifetime             = 8.f;
    //粒子向屏幕右方(+)向偏移及偏移范围大小
    emitterCell.velocity             = 10;
    emitterCell.velocityRange        = -10;
    //粒子沿y轴方向发射加速度分量
    emitterCell.yAcceleration        = -40;
    //粒子在发射点可以发射的角度
    emitterCell.emissionRange        = -M_PI;
    //粒子大小/范围/变化速率
    emitterCell.scale                = 0.1;
    emitterCell.scaleRange           = 0.1;
    emitterCell.scaleSpeed           = 0.2;
    //粒子过滤器放大模式
    emitterCell.magnificationFilter  = kCAFilterNearest;
    emitterCell.minificationFilter   = kCAFilterTrilinear;
    emitterLayer.emitterCells        = @[emitterCell];
    [self.layer addSublayer:emitterLayer];
}
@end
