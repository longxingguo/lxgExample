//
//  LXGCountdownButton.m
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/5.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGCountdownButton.h"
@interface LXGCountdownButton ()
/** 定时器 */
@property (strong , nonatomic) NSTimer  * timer;
/** 倒计时时长 */
@property (assign , nonatomic) NSInteger  number;
/** 原始标题 */
@property (copy ,   nonatomic) NSString * orignaltitle;
/** 是否在倒计时 */
@property (assign , nonatomic) BOOL isCountDown ;
@end
@implementation LXGCountdownButton
- (void)setCountdownTimeInterval:(NSTimeInterval)countdownTimeInterval {
    _countdownTimeInterval = countdownTimeInterval;
    self.number = _countdownTimeInterval;
    self.isCountDown = YES;
    // 保存原始的标题
    self.orignaltitle = self.titleLabel.text;
    if (!self.timer) {
        self.timer = [LXGWeakTimerTool scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(privateCountDown) userInfo:@"" repeats:YES];
    }
}

- (void)stopCountdown {
    self.isCountDown = NO;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self setAttributedTitle:nil forState:UIControlStateNormal];
    [self setTitle:@"获取验证码" forState:UIControlStateNormal];
}

- (void)privateCountDown {
    if (self.number > 0) {
        [self setAttributedTitle:[self GowalkSmsCodeButtonGetCountDownStringWith:self.number] forState:UIControlStateNormal];
    } else {
        [self stopCountdown];
    }
    self.number -- ;
}

- (NSMutableAttributedString *)GowalkSmsCodeButtonGetCountDownStringWith:(NSInteger)count{
    NSString * countstring = [NSString stringWithFormat:@"%lds后重试",(long)count];
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:countstring];
    [attributedString addAttributes:@{NSFontAttributeName:self.titleLabel.font,
                                      NSForegroundColorAttributeName:[UIColor lightGrayColor]} range:NSMakeRange(0, countstring.length)];
    return attributedString;
}

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if (!self.isCountDown) {
        [super sendAction:action to:target forEvent:event];
    }
}

@end
