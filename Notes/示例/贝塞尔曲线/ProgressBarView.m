//
//  ProgressBarView.m
//  LXGDemo合集
//
//  Created by onecar on 2018/11/20.
//  Copyright © 2018年 onecar. All rights reserved.
//

#import "ProgressBarView.h"
@interface ProgressBarView ()
//贝塞尔曲线
@property (nonatomic ,strong)UIBezierPath * Bepath;
//底层
@property (nonatomic ,strong)CAShapeLayer * underlayer;
//上层
@property (nonatomic ,strong)CAShapeLayer * upperlayer;
@end
@implementation ProgressBarView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.Bepath  = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0) radius:self.frame.size.height/2.0 startAngle:M_PI/2 endAngle: M_PI*2+M_PI/2  clockwise:YES];
    //底层
    self.underlayer                = [[CAShapeLayer alloc]init];
    self.underlayer.path           = self.Bepath.CGPath;
    self.underlayer.fillColor      = [UIColor clearColor].CGColor;
    self.underlayer.strokeEnd      = 1;
    [self.layer addSublayer:self.underlayer];
    //上层
    self.upperlayer                = [[CAShapeLayer alloc]init];
    self.upperlayer.path           = self.Bepath.CGPath;
    self.upperlayer.fillColor      = [[UIColor clearColor] CGColor];
    self.upperlayer.strokeEnd      = 0;
    [self.layer addSublayer:self.upperlayer];
}
-(void)setUnderColor:(UIColor *)underColor{
    _underColor = underColor;
    self.underlayer.strokeColor = _underColor.CGColor;
}
-(void)setUpperColor:(UIColor *)upperColor{
    _upperColor = upperColor;
    self.upperlayer.strokeColor =_upperColor.CGColor;
}
-(void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth;
    self.underlayer.lineWidth = _lineWidth;
    self.upperlayer.lineWidth = _lineWidth;
}
-(void)setProGress:(CGFloat)proGress{
    _proGress = proGress;
    CABasicAnimation * pathAnimation  = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration            = 1;
    pathAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.fromValue           = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue             = [NSNumber numberWithFloat:proGress];
    pathAnimation.autoreverses        = NO;
    pathAnimation.fillMode            = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.repeatCount         = 1;
    [self.upperlayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
}
@end
