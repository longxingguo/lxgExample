//
//  LXGPhotoManger.m
//  LXGDemo合集
//
//  Created by onecar on 2019/4/18.
//  Copyright © 2019 onecar. All rights reserved.
//

#import "LXGPhotoManger.h"
@implementation LXGPhotoManger
+(LXGPhotoManger*)standardPhotoManger {
    static LXGPhotoManger *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LXGPhotoManger alloc] init];
    });
    return manager;
}
#pragma mark - Set方法
-(void)setMaxCount:(NSInteger)maxCount {
    _maxCount           = maxCount;
    self.photoModelList = [NSMutableArray array];
    self.choiceCount    = 0;
}
-(void)setChoiceCount:(NSInteger)choiceCount {
    _choiceCount = choiceCount;
    if (self.choiceCountChange) {
        self.choiceCountChange(choiceCount);
    }
}
@end
