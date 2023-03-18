//
//  LXGAudioRecorderTool.m
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/29.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGAudioRecorderTool.h"
#import "lame.h"
#import "LXGWeakTimerTool.h"
#import <AVFoundation/AVFoundation.h>
@interface LXGAudioRecorderTool ()<AVAudioRecorderDelegate>
@property (nonatomic, strong) AVAudioRecorder * audioRecorder;
@property (nonatomic, strong) NSTimer         * timer;
@property (nonatomic, copy  ) void (^volume  )(CGFloat valume);
@property (nonatomic, copy  ) void (^complete)(NSString * path, CGFloat time);
@property (nonatomic, copy  ) void (^cancel  )(void);
@property (nonatomic, assign) BOOL ismMp3;
@end
@implementation LXGAudioRecorderTool
+(instancetype)shareAudioRecorderTool{
    static LXGAudioRecorderTool * audioRecorderTool;
    static dispatch_once_t        onceToken;
    dispatch_once(&onceToken, ^{
        audioRecorderTool = [LXGAudioRecorderTool new];
        [[NSNotificationCenter defaultCenter]addObserver:audioRecorderTool selector:@selector(interruption:) name:AVAudioSessionInterruptionNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:audioRecorderTool selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
    });
    return audioRecorderTool;
}
//监听中断
-(void)interruption:(NSNotification *)noti{
    NSDictionary * info                 = noti.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey]unsignedIntegerValue];
    if (type == AVAudioSessionInterruptionTypeBegan){
        [self cancelRecording];
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
            [self cancelRecording];
        }
    }
}
//释放监听
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -------------------------------------------------------------------------------------- 录音
//开始录音
-(void)startRecorder:(void (^)(CGFloat volume))volume complete:(void (^)(NSString * path, CGFloat time))complete cancel:(void (^)(void))cancel andIsmMp3:(BOOL)ismMp3{
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    [audioSession requestRecordPermission:^(BOOL granted){
        if (granted){
            self.volume            = volume;
            self.complete          = complete;
            self.cancel            = cancel;
            self.ismMp3            = ismMp3;
            [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
            [audioSession setActive:YES error:nil];
            if([[NSFileManager defaultManager] fileExistsAtPath:self.recFilePath]){
                [[NSFileManager defaultManager] removeItemAtPath:self.recFilePath error:nil];
            }
            [self.audioRecorder prepareToRecord];
            [self.audioRecorder record];
            if(self.timer && self.timer.isValid){
                [self.timer invalidate];
            }
            self.timer = [LXGWeakTimerTool scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(volumeRecording) userInfo:nil repeats:YES];
        }else{
            LAlertOpenSetting(@"检测到您当前没有开启麦克风,开启麦克风才可以录音,是否前往设置开启麦克风?");
        }
    }];
}
//获取音量强度
-(void)volumeRecording{
    [self.audioRecorder updateMeters];
    float power     = [self.audioRecorder peakPowerForChannel:0];//取得第一个通道的音频，注意音频强度范围时-160到0
    float peakPower = pow(10, (0.05 * power));
    if(self.volume){
        self.volume(peakPower);
    }
}
//停止录音
- (void)stopRecording{
    if(self.timer){
        [self.timer invalidate];
    }
    if(self.audioRecorder){
        [self.audioRecorder stop];
    }
    if (self.ismMp3){
        [self conversionMp3];
    }else{
        if (self.complete) {
            self.complete(self.recFilePath, self.audioRecorder.currentTime);
            self.complete = nil;
        }
    }
}
//转mp3
-(void)conversionMp3{
    @try {
        int read, write;
        FILE * pcm         = fopen([self.recFilePath cStringUsingEncoding:1], "rb");
        fseek(pcm, 4*1024, SEEK_CUR);//删除头，否则在前一秒钟会有杂音
        FILE * mp3         = fopen([self.mp3FilePath cStringUsingEncoding:1], "wb+");
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE * 2];
        unsigned char mp3_buffer[MP3_SIZE];
        //这里要注意，lame的配置要跟AVAudioRecorder的配置一致，否则会造成转换不成功
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        do {
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0){
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            }else{
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            }
            fwrite(mp3_buffer, write, 1, mp3);
        } while (read != 0);
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }@catch (NSException *exception){//失败
        [self cancelRecording];
    }@finally{//成功
        if (self.complete) {
            self.complete(self.mp3FilePath, self.audioRecorder.currentTime);
            self.complete = nil;
        }
    }
}
//取消录制
- (void)cancelRecording{
    if(self.timer){
        [self.timer invalidate];
    }
    if(self.audioRecorder){
        [self.audioRecorder stop];
    }
    if (self.cancel){
        self.cancel();
        self.cancel = nil;
    }
}
#pragma mark---------------------------------------------------------------get
-(AVAudioRecorder *)audioRecorder{
    if (!_audioRecorder) {
        NSMutableDictionary * setting     = [NSMutableDictionary dictionary];
        setting[AVFormatIDKey]            = @(kAudioFormatLinearPCM);       // 音频格式
        setting[AVSampleRateKey]          = @(11025);                       // 录音采样率(Hz)
        setting[AVNumberOfChannelsKey]    = @(2);                           // 音频通道数 1 或 2
        setting[AVLinearPCMBitDepthKey]   = @(16);                          // 线性音频的位深度
        setting[AVEncoderAudioQualityKey] = @(AVAudioQualityHigh);
        setting[AVLinearPCMIsFloatKey]    = @(YES);
        NSURL * url                       = [NSURL fileURLWithPath:self.recFilePath];
        _audioRecorder                    = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:NULL];
        _audioRecorder.delegate           = self;
        _audioRecorder.meteringEnabled    = YES;
    }
    return _audioRecorder;
}
- (NSString *)recFilePath{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"wavRecord.wav"];
}
- (NSString *)mp3FilePath{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"mp3Record.mp3"];
}
#pragma mark-------------AVAudioRecorderDelegateR
//录制完成
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    if (flag){
    }
}
//编码失败
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error{
}
@end
/*
 知识点1 默认AVAudioRecorder录制后的格式是.caf，而大部分的播放器都是不支持这个格式的
 知识点2 在录制caf文件时，需要使用双通道，否则在转换为MP3格式时，声音不对 采样率必须要设为11025才能使转化成mp3格式后不会失真
 知识点3 系统默认caf格式  如若条件允许，请尽量使用pcm，alaw或者ulaw编码的原始wav音频或者无损音 频压缩编码（FLAC）来录制以及传输音频
 lameClient = lame_init();
 lame_set_in_samplerate(lameClient,sampleRate); //设置输入采样率
 lame_set_out_samplerate(lameClient, sampleRate); //设置输出采样率
 lame_set_num_channels(lameClient, channels); //设置声道数
 lame_set_brate(lameClient, bitRate); //设置码率
 lame_set_quality(lameClient,2);  //设置转码质量高
 lame_init_params(lameClient);   //完成设置
 */
