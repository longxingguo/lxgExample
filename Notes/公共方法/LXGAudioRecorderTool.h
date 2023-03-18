//
//  LXGAudioRecorderTool.h
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/29.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface LXGAudioRecorderTool : NSObject
/**
 单例
 @return LXGAudioRecorderTool
 */
+(instancetype)shareAudioRecorderTool;
/**
 开始录音
 @param volume 音量强度
 @param complete 录制完成
 @param cancel 取消录制
 @param ismMp3 是否转mp3
 */
-(void)startRecorder:(void (^)(CGFloat volume))volume complete:(void (^)(NSString * path, CGFloat time))complete cancel:(void (^)(void))cancel andIsmMp3:(BOOL)ismMp3;
/**
 停止录音
 */
- (void)stopRecording;
/**
 取消录音
 */
- (void)cancelRecording;
@end
NS_ASSUME_NONNULL_END
