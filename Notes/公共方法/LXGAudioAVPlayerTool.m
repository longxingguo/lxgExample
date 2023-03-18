//
//  LXGAudioAVPlayerTool.m
//  Notes
//
//  Created by 龙兴国 on 2019/9/12.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGAudioAVPlayerTool.h"
#import <AVFoundation/AVFoundation.h>
@interface LXGAudioAVPlayerTool ()
@property (nonatomic, strong) AVPlayer * avplayer;
@property (nonatomic, copy  ) void(^success)(BOOL isSuccess,NSString *errNsg);
@end
@implementation LXGAudioAVPlayerTool
+ (LXGAudioAVPlayerTool *)sharedAudioAVPlayerTool{
    static LXGAudioAVPlayerTool * audioAVPlayerTool;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        audioAVPlayerTool = [[LXGAudioAVPlayerTool alloc] init];
        [[NSNotificationCenter defaultCenter]addObserver:audioAVPlayerTool selector:@selector(interruption:) name:AVAudioSessionInterruptionNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:audioAVPlayerTool selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
    });
    return audioAVPlayerTool;
}
//监听中断
-(void)interruption:(NSNotification *)noti{
    NSDictionary * info                 = noti.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey]unsignedIntegerValue];
    if (type == AVAudioSessionInterruptionTypeBegan){
        [self stopPlayer];
    }
}
//监听输出改变
- (void)routeChange:(NSNotification*)noti{
    NSDictionary * info                  = noti.userInfo;
    AVAudioSessionRouteChangeReason type = [info[AVAudioSessionRouteChangeReasonKey]unsignedIntegerValue];
    if (type == AVAudioSessionRouteChangeReasonOldDeviceUnavailable){
        AVAudioSessionRouteDescription * route = info[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription  * port  = [route.outputs firstObject];
        if ([port.portType isEqualToString:@"Headphones"]){//拔出耳机
            [self stopPlayer];
        }
    }
}
#pragma mark -------------------------------------------------------------------------------------- 播放
- (void)playerWithString:(NSString *)url andSuccessBlock:(void(^)(BOOL isSuccess,NSString *errNsg))success{
    [self removeObserver];
    self.success             = success;
    AVPlayerItem * songItem  = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:url]];
    [self.avplayer replaceCurrentItemWithPlayerItem:songItem];
    [self.avplayer play];
    [self.avplayer.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.avplayer.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinish) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}
//播放结束
- (void)playFinish{
    if (self.success) {
        self.success(YES, @"播放结束");
    }
}
//监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] intValue];
        switch (status) {
            case AVPlayerItemStatusFailed: {
                if (self.success) {
                    self.success(NO, @"解析数据失败");
                }
            } break;
            case AVPlayerItemStatusReadyToPlay: {
                [self.avplayer play];
            } break;
            case AVPlayerItemStatusUnknown: {
                if (self.success) {
                    self.success(NO, @"资源出现未知错误");
                }
            } break;
            default: break;
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray   * array          = self.avplayer.currentItem.loadedTimeRanges;
        // 本次缓冲的时间范围
        CMTimeRange timeRange      = [array.firstObject CMTimeRangeValue];
        // 缓冲总长度
        NSTimeInterval totalBuffer = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration);
        // 音乐的总时间
        NSTimeInterval duration    = CMTimeGetSeconds(self.avplayer.currentItem.duration);
        // 计算缓冲百分比例
        NSTimeInterval scale = totalBuffer / duration;
        NSLog(@"总时长：%f, 已缓冲：%f, 总进度：%f", duration, totalBuffer, scale);
    }
}
//暂停
- (void)stopPlayer{
    if (self.avplayer) {
        [self.avplayer pause];
    }
}
//播放 从暂停位置继续
- (void)playPlayer{
    if(self.avplayer){
        [self.avplayer play];
    }
}
//释放
-(void)dealloc{
    [self removeObserver];
}
//移除监听
-(void)removeObserver{
    if (self.avplayer) {
        [self.avplayer.currentItem removeObserver:self forKeyPath:@"status"];
        [self.avplayer.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//播放器
- (AVPlayer *)avplayer{
    if (!_avplayer) {
        _avplayer = [[AVPlayer alloc] init];
    }
    return _avplayer;
}
@end
