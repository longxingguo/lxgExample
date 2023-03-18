//
//  LXGTableView.m
//  Notes
//
//  Created by 龙兴国 on 2019/10/17.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGTableView.h"
@implementation LXGTableView
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    NSLog(@"point=%@",NSStringFromCGPoint(point));//相对偏移量吗?
    NSLog(@"y=%f",self.contentOffset.y);
    if (point.y<0) {
        return nil;
    }
    return  [super hitTest:point withEvent:event];
}
@end
/*
 1，hitTest:withEvent:方法忽略隐藏的视图（hidden＝yes），禁止用户操作的视图（userInteractionEnable=yes）,以及alpha<0.01的视图

 2，子视图的区域超过父视图的bounds的区域，clipsToBounds=no,超过父视图bound区域的子视图内容也会显示，正常情况下触摸父视图区域之外的子视图区域不会被识别，因为父视图的pointInside:withEvent:方法会返回no，停止向下访问子视图。可以重写pointInside:withEvent:方法来处理这种情况
 点击屏幕，此方法会调用3次，前两次是对上一次触摸事件的终结，第3次是当次点击的处理。
 */
