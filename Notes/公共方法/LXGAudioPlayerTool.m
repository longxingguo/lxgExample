//
//  LXGAudioPlayerTool.m
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/29.
//  Copyright © 2019 龙兴国. All rights reserved.
//
#import "LXGAudioPlayerTool.h"
#import <AVFoundation/AVFoundation.h>
@interface LXGAudioPlayerTool ()<AVAudioPlayerDelegate>
@property (nonatomic, strong)AVAudioPlayer * audioPlayer;
@property (nonatomic, copy  )void(^complete)(BOOL complete);
@property (nonatomic, copy  )void(^error   )(NSError * error);
@end
@implementation LXGAudioPlayerTool
+(instancetype)shareAudioPlayerTool{
    static LXGAudioPlayerTool  * audioPlayerTool;
    static dispatch_once_t       onceToken;
    dispatch_once(&onceToken, ^{
        audioPlayerTool = [LXGAudioPlayerTool new];
        [[NSNotificationCenter defaultCenter]addObserver:audioPlayerTool selector:@selector(interruption:) name:AVAudioSessionInterruptionNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:audioPlayerTool selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
    });
    return audioPlayerTool;
}
//监听中断
-(void)interruption:(NSNotification *)noti{
    NSDictionary * info                 = noti.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey]unsignedIntegerValue];
    if (type == AVAudioSessionInterruptionTypeBegan){
        [self stop];
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
            [self stop];
        }
    }
}
//释放监听
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -------------------------------------------------------------------------------------- 播放
//播放 从头开始
- (void)play:(NSString *)path complete:(void (^)(BOOL complete))complete error:(void(^)(NSError * error))error{
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    //原来是否有在播放 有 暂停
    if(self.audioPlayer && self.audioPlayer.isPlaying){
        self.complete         = nil;
        [self stop];
    }
    self.complete             = complete;
    self.error                = error;
    //开启新的播放 当aError不等于nil时 一定要认真检查你的地址
    NSError * aError          = nil;
    NSURL   * url             = [NSURL fileURLWithPath:path];
    self.audioPlayer          = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&aError];
    self.audioPlayer.delegate = self;
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
}
//播放 从暂停位置开始
- (void)play{
    if(![self.audioPlayer isPlaying]){
        [self.audioPlayer play];
    }
}
//暂停
- (void)stop{
    if(self.audioPlayer){
        [self.audioPlayer stop];
        if (self.complete){
            self.complete(NO);
        }
    }
}
//是否正在播放
- (BOOL)isPlaying{
    if(self.audioPlayer){
        return self.audioPlayer.isPlaying;
    }
    return NO;
}
#pragma mark------------- AVAudioPlayerDelegate
//播完
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if(self.complete){
        self.complete(YES);
        self.complete = nil;
    }
}
//解码失败
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    if(self.error){
        self.error(error);
        self.error = nil;
    }
}
@end
/*
 知识点1 后台播放 在plist文件下添加 key ： Required background modes，并设置item0 = App plays audio or streams audio/video using AirPlay
 知识点2 无声音时
        情况1 AVAudioPlayer 没有全局
        情况2 AVAudioPlayer 模拟器有声音，真机耳机有声音，扬音器没有声音解决办法
             设置AVAudioSession的类型为AVAudioSessionCategoryPlayback并且调用setActive::方法启动会话。
 知识点3 pause和stop区别
 pause和stop方法在应用程序外面看来实现的功能都是停止当前播放行为，下一时间我们调用play方法，通过pause和stop方法停止音频会继续播放。这两者最主要的区别在底层处理上。调用stop方法会撤销prepareToPlay时所做的设置，而调用pause方法则不会。
 知识点4 AVAudioPlayer不支持加载网络媒体流，只能播放本地文件
 知识点5 #import <AVFoundation/AVFoundation.h>库的东西 基本需要全局
 */
