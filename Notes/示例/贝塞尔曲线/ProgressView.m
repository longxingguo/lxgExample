//
//  ProgressView.m
//  LXGDemo合集
//
//  Created by onecar on 2018/11/30.
//  Copyright © 2018年 onecar. All rights reserved.
//

#import "ProgressView.h"
@interface ProgressView ()
//贝塞尔曲线
@property (nonatomic ,strong)UIBezierPath * Bepath;
//底层
@property (nonatomic ,strong)CAShapeLayer * underlayer;
//上层
@property (nonatomic ,strong)CAShapeLayer * upperlayer;
@end
@implementation ProgressView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    //
    self.Bepath  = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0) radius:self.frame.size.height/2.0 + 10 startAngle:M_PI endAngle: M_PI * 2  clockwise:YES];
    //底层
    self.underlayer                = [[CAShapeLayer alloc]init];
    self.underlayer.path           = self.Bepath.CGPath;
    self.underlayer.strokeEnd      = 1;
    [self.layer addSublayer:self.underlayer];
    //上层
    self.upperlayer                = [[CAShapeLayer alloc]init];
    self.upperlayer.path           = self.Bepath.CGPath;
    self.upperlayer.strokeEnd      = 0;
    self.upperlayer.lineDashPattern= @[@10, @5];
    [self.layer addSublayer:self.upperlayer];
}
-(void)setUnderColor:(UIColor *)underColor{
    _underColor                 = underColor;
    self.underlayer.strokeColor = _underColor.CGColor;
}
-(void)setUnderFillColor:(UIColor *)underFillColor{
    _underFillColor           = underFillColor;
    self.underlayer.fillColor = _underFillColor.CGColor;
}
-(void)setUpperColor:(UIColor *)upperColor{
    _upperColor                 = upperColor;
    self.upperlayer.strokeColor = _upperColor.CGColor;
}
-(void)setUpperFillColor:(UIColor *)upperFillColor{
    _upperFillColor           = upperFillColor;
    self.upperlayer.fillColor = _upperFillColor.CGColor;
}
-(void)setUnlineWidth:(CGFloat)unlineWidth{
    _unlineWidth              = unlineWidth;
    self.underlayer.lineWidth = _unlineWidth;
}
-(void)setUplineWidth:(CGFloat)uplineWidth{
    _uplineWidth              = uplineWidth;
    self.upperlayer.lineWidth = _uplineWidth;
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
