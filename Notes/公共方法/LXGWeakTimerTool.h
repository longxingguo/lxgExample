//
//  LXGWeakTimerTool.h
//  Notes
//
//  Created by 龙兴国 on 2019/9/10.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface LXGWeakTimerTool : NSObject
/**
 创建定时器，防止强引用
 @param time      定时器时长
 @param aTarget   对象来引用
 @param aSelector 执行的方法
 @param userInfo  用户信息
 @param yesOrNo   是否要重复
 @return NSTimer
 */
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)time target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;
@end

NS_ASSUME_NONNULL_END
