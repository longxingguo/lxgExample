//
//  LXGBorderLabel.m
//  LXGDemo
//
//  Created by 龙兴国 on 2019/9/6.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGBorderLabel.h"
@implementation LXGBorderLabel
- (instancetype)init{
    if (self = [super init]) {
        self.backColor  = [UIColor whiteColor];
        self.frontColor = [UIColor blackColor];
    }
    return self;
}
-(void)setBackColor:(UIColor *)backColor{
    _backColor  = backColor;
    [self setNeedsDisplay];
}
-(void)setFrontColor:(UIColor *)frontColor{
    _frontColor = frontColor;
    [self setNeedsDisplay];
}
- (void)drawTextInRect:(CGRect)rect{
    CGContextRef c = UIGraphicsGetCurrentContext();
    // 设置描边宽度
    CGContextSetLineWidth(c, 2);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    // 描边颜色
    self.textColor = self.backColor;
    [super drawTextInRect:rect];
    // 文本颜色
    self.textColor = self.frontColor;
    CGContextSetTextDrawingMode(c, kCGTextFill);
    [super drawTextInRect:rect];
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    return [super hitTest:point withEvent:event];
}
@end
