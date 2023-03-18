//
//  LXGAudioPlayerTool.h
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/29.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface LXGAudioPlayerTool : NSObject
/**
 单例
 @return LXGAudioPlayerTool
 */
+(instancetype)shareAudioPlayerTool;
/**
 开始播放
 @param path 地址
 @param complete 播放完成
 @param error 解码失败
 */
- (void)play:(NSString *)path complete:(void (^)(BOOL complete))complete error:(void(^)(NSError * error))error;
/**
 播放 从暂停位置继续
 */
- (void)play;
/**
 暂停
 */
- (void)stop;
/**
 是否正在播放
 @return YES NO
 */
- (BOOL)isPlaying;
@end
NS_ASSUME_NONNULL_END
