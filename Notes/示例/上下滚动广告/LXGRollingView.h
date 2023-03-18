//
//  LXGRollingView.h
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/12.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXGRollingView : UIView
/**
 * 定时器间隔时间------------------------------------------优先设置
 */
@property (nonatomic,assign)NSInteger time;
/**
 *  文字数组
 */
@property (nonatomic,strong)NSArray * titleArray;
/**
 *  字体
 */
@property (nonatomic,strong)UIFont  * titleFont;
/**
 *  字体颜色
 */
@property (nonatomic,strong)UIColor * titleColor;
/**
 *  背景颜色
 */
@property (nonatomic,strong)UIColor * backgroundColor;
/**
 *  是否可以拖拽
 */
@property (nonatomic,assign)BOOL      isCanScroll;
/**
 *  block回调
 */
@property (nonatomic,copy) void(^selectedBlock)(NSInteger index,NSString *title);
/**
 *  添加定时器
 */
- (void)addTimer;
/**
 *  关闭定时器
 */
- (void)removeTimer;
@end

NS_ASSUME_NONNULL_END
