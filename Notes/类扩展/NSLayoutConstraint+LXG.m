//
//  NSLayoutConstraint+LXG.m
//  Notes
//
//  Created by 龙兴国 on 2019/9/26.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "NSLayoutConstraint+LXG.h"
#import <objc/runtime.h>
static char * AdapterScreenKey = "AdapterScreenKey";
@implementation NSLayoutConstraint (LXG)
- (BOOL)adapterScreen{
    NSNumber * number = objc_getAssociatedObject(self, AdapterScreenKey);
    return     number.boolValue;
}
- (void)setAdapterScreen:(BOOL)adapterScreen{
    NSNumber *number = @(adapterScreen);
    objc_setAssociatedObject(self, AdapterScreenKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (adapterScreen){
        self.constant = LScaleX(self.constant);
    }
}
@end
