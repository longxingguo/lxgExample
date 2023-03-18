//
//  LXGWeakTimerTool.m
//  Notes
//
//  Created by 龙兴国 on 2019/9/10.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGWeakTimerTool.h"
@interface LXGWeakTimerTool ()
@property (weak   , nonatomic) id  aTarget;
@property (assign , nonatomic) SEL aSelector;
@end
@implementation LXGWeakTimerTool
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)time target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo{
    LXGWeakTimerTool * object = [[LXGWeakTimerTool alloc] init];
    object.aTarget            = aTarget;
    object.aSelector          = aSelector;
    return [NSTimer scheduledTimerWithTimeInterval:time target:object selector:@selector(fire:) userInfo:userInfo repeats:yesOrNo];
}
- (void)fire:(id)object {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.aTarget performSelector:self.aSelector withObject:object];
#pragma clang diagnostic pop
}
@end
