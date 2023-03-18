//
//  LXGAudioAVPlayerTool.h
//  Notes
//
//  Created by 龙兴国 on 2019/9/12.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXGAudioAVPlayerTool : NSObject
/**
 单例
 @return LXGAudioAVPlayerTool
 */
+ (LXGAudioAVPlayerTool *)sharedAudioAVPlayerTool;
/**
 开始播放
 @param url 地址
 @param success 播放完成
 */
- (void)playerWithString:(NSString *)url andSuccessBlock:(void(^)(BOOL isSuccess,NSString *errNsg))success;
/**
 暂停
 */
- (void)stopPlayer;
/**
 播放 从暂停位置继续
 */
- (void)playPlayer;
@end

NS_ASSUME_NONNULL_END
