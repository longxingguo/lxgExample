//
//  LXGEnvironmentWindow.m
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/1.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGEnvironmentWindow.h"
#import "LXGEnvironmentViewController.h"
@implementation LXGEnvironmentWindow
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    [super motionBegan:motion withEvent:event];
    if(motion == UIEventSubtypeMotionShake){
        if (![LCurrentVC isKindOfClass:[LXGEnvironmentViewController class]]){
            UINavigationController * nvc = [[UINavigationController alloc] initWithRootViewController:[[LXGEnvironmentViewController alloc] init]];
            nvc.modalPresentationStyle   = UIModalPresentationFullScreen;
            [LCurrentVC presentViewController:nvc animated:YES completion:nil];
        }
    }
}
@end
