//
//  LXGCountdownButton.h
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/5.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXGCountdownButton : UIButton
/**
 倒计时时间,給值后就开始倒计时
 */
@property (assign , nonatomic) NSTimeInterval countdownTimeInterval ;

/**
 停止倒计时
 */
- (void)stopCountdown;
@end

NS_ASSUME_NONNULL_END
