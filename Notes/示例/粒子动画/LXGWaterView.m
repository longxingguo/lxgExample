//
//  LXGWaterView.m
//  Notes
//
//  Created by 龙兴国 on 2019/9/16.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGWaterView.h"
@interface LXGWaterView (){
    CGFloat         _wave_offsety;   //根据进度计算(波峰所在位置的y坐标)
    CGFloat         _offsety_scale;  //上升的速度
    CGFloat         _wave_move_width;//移动的距离，配合速率设置
    CGFloat         _wave_offsetx;   //偏移,animation
    CADisplayLink * _waveDisplaylink;//
}
@end
@implementation LXGWaterView
- (void)dealloc {
    if (_waveDisplaylink) {
        [_waveDisplaylink invalidate];
        _waveDisplaylink = nil;
    }
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self creatUI];
    }
    return self;
}
-(void)creatUI{
    self.type              = LXGBorderPathType_normal;
    self.borderFillColor   = [UIColor groupTableViewBackgroundColor];
    self.borderStrokeColor = [UIColor groupTableViewBackgroundColor];
    self.borderWidth       = 0;
    self.topColor          = [UIColor colorWithRed:79/255.0 green:240/255.0 blue:255/255.0 alpha:1];
    self.bottomColor       = [UIColor colorWithRed:79/255.0 green:240/255.0 blue:255/255.0 alpha:.3];
    self.amplitude         = self.frame.size.height/20;
    self.cycle             = 2 * M_PI/(self.frame.size.width * 0.9);
    self.hDistance         = 2 * M_PI/self.cycle * 0.65;
    self.vDistance         = self.amplitude * 0.2;
    self.scale             = 0.5;
    self.progress          = 0.2;
     _wave_move_width      = 0.5;
     _offsety_scale        = 0.01;
     _wave_offsety         = (1-self.progress) * (self.frame.size.height + 2*  self.amplitude);
}
-(void)beginAnimation{
    if (!_waveDisplaylink) {
        _waveDisplaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeoff)];
        [_waveDisplaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}
-(void)endAnimation{
    if (_waveDisplaylink) {
        [_waveDisplaylink invalidate];
        _waveDisplaylink = nil;
    }
}
- (void)changeoff {
    _wave_offsetx += _wave_move_width * self.scale;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    if (self.borderPath) {
        if (self.borderFillColor) {
            [self.borderFillColor setFill];
            [self.borderPath fill];
        }
        if (self.borderStrokeColor) {
            [self.borderStrokeColor setStroke];
            [self.borderPath stroke];
        }
        [self.borderPath addClip];
    }
    [self drawWaveColor:_topColor offsetx:0 offsety:0];
    [self drawWaveColor:_bottomColor offsetx:self.hDistance offsety:self.vDistance];
}
- (void)drawWaveColor:(UIColor *)color offsetx:(CGFloat)offsetx offsety:(CGFloat)offsety {
    //波浪动画，所以进度的实际操作范围是，多加上两个振幅的高度,到达设置进度的位置y坐标
    CGFloat end_offY = (1-self.progress) * (self.frame.size.height + 2*  self.amplitude);
    if (_wave_offsety != end_offY) {
        if (end_offY < _wave_offsety) {//上升
            _wave_offsety = MAX(_wave_offsety-=(_wave_offsety - end_offY)*_offsety_scale, end_offY);
        } else {
            _wave_offsety = MIN(_wave_offsety+=(end_offY-_wave_offsety)*_offsety_scale, end_offY);
        }
    }
    UIBezierPath *wave = [UIBezierPath bezierPath];
    for (float next_x= 0.f; next_x <= self.frame.size.width; next_x ++) {
        //正弦函数
        CGFloat next_y =  self.amplitude * sin(self.cycle*next_x + _wave_offsetx + offsetx/self.bounds.size.width*2*M_PI) + _wave_offsety + offsety;
        if (next_x == 0) {
            [wave moveToPoint:CGPointMake(next_x, next_y -  self.amplitude)];
        } else {
            [wave addLineToPoint:CGPointMake(next_x, next_y -  self.amplitude)];
        }
    }
    [wave addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    [wave addLineToPoint:CGPointMake(0, self.bounds.size.height)];
    [color set];
    [wave fill];
}
//容器类型
-(void)setType:(LXGBorderPathType)type{
    _type               = type;
    if (_type == LXGBorderPathType_normal) {
        self.borderPath = nil;
    }else if (_type == LXGBorderPathType_heart){
        self.borderPath = [self heartPathRect:self.bounds lineWidth:self.borderWidth];
    }else if (_type == LXGBorderPathType_circle){
        self.borderPath = [self circlePathRect:self.bounds lineWidth:self.borderWidth];
    }else if (_type == LXGBorderPathType_stars){
        self.borderPath = [self startPathRect:self.bounds lineWidth:self.borderWidth];
    }
}
//心形
- (UIBezierPath *)heartPathRect:(CGRect)rect lineWidth:(CGFloat)width{
    CGFloat radius      = rect.size.width/4;
    CGPoint center1     = CGPointMake(radius  , radius);
    CGPoint center2     = CGPointMake(3*radius, radius);
    CGPoint bottom      = CGPointMake(2*radius, rect.size.height);
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:center1 radius:radius startAngle:0 endAngle:3*M_PI_4 clockwise:NO];
    [path addLineToPoint:bottom];
    [path addArcWithCenter:center2 radius:radius startAngle:M_PI_4 endAngle:M_PI clockwise:NO];
    [path setLineCapStyle:kCGLineCapRound];
    [path setLineWidth:width];
    return path;
}
//圆形
- (UIBezierPath *)circlePathRect:(CGRect)rect lineWidth:(CGFloat)width{
    UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [path setLineWidth:width];
    return path;
}
//星星
-(UIBezierPath *)startPathRect:(CGRect)rect lineWidth:(CGFloat)width{
    UIBezierPath * star = [UIBezierPath bezierPath];
    //确定中心点
    CGPoint centerPoint = CGPointMake(rect.size.width/2, rect.size.width/2);
    //确定半径
    CGFloat bigRadius   = rect.size.width/2;
    CGFloat smallRadius = bigRadius * sin(2*M_PI/20) / cos(2*M_PI/10);
    //起始点
    CGPoint start       = CGPointMake(rect.size.width/2, 0);
    [star moveToPoint:start];
    //五角星每个顶角与圆心连线的夹角 2π/5，
    CGFloat angle = 2*M_PI/5.0;
    for (int i=1; i<=10; i++) {
        CGFloat x;
        CGFloat y;
        NSInteger c = i/2;
        if (i%2 == 0) {
            x=centerPoint.x-sinf(c*angle)*bigRadius;
            y=centerPoint.y-cosf(c*angle)*bigRadius;
        } else {
            x=centerPoint.x-sinf(c*angle + angle/2)*smallRadius;
            y=centerPoint.y-cosf(c*angle + angle/2)*smallRadius;
        }
        [star addLineToPoint:CGPointMake(x, y)];
    }
    [star setLineWidth:width];
    return star;
}
@end
/*
+ (CADisplayLink *)displayLinkWithTarget:(id)target selector:(SEL)sel;初始化
- (void)addToRunLoop:(NSRunLoop *)runloop forMode:(NSRunLoopMode)mode;添加到RunLoop
- (void)removeFromRunLoop:(NSRunLoop *)runloop forMode:(NSRunLoopMode)mode;从runloop移除
- (void)invalidate;
@property(readonly, nonatomic) CFTimeInterval timestamp;//上一次屏幕刷新时间
@property(readonly, nonatomic) CFTimeInterval duration; //两次屏幕刷新之间的时间间隔
@property(readonly, nonatomic) CFTimeInterval targetTimestamp 下一帧时间
    API_AVAILABLE(ios(10.0), watchos(3.0), tvos(10.0));
@property(getter=isPaused, nonatomic) BOOL paused;//暂停
@property(nonatomic) NSInteger frameInterval 间隔多少帧调用一次selector方法 时间=duration×frameInterval
  API_DEPRECATED("preferredFramesPerSecond", ios(3.1, 10.0),
                 watchos(2.0, 3.0), tvos(9.0, 10.0));
@property(nonatomic) NSInteger preferredFramesPerSecond 每秒刷新次数 默认值为屏幕最大帧率
    API_AVAILABLE(ios(10.0), watchos(3.0), tvos(10.0));
 */
