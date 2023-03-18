//
//  GWPlayerView.m
//  takePhotoDemo
//
//  Created by lexingdao on 2018/1/25.
//  Copyright © 2018年 lexingdao. All rights reserved.
//

#import "GWPlayerView.h"
// tool
//#import "GowalkNetWorkManagerTool.h"

@interface GWPlayerView ()<UIGestureRecognizerDelegate,UIAlertViewDelegate>
/** 播放的item对象 */
@property (strong , nonatomic) AVPlayerItem * playerItem;
/** 播放器view */
@property (strong , nonatomic) AVPlayerLayer * playerLayer;
/** 时间观察者 */
@property (strong , nonatomic) id timeObserve;
/** 覆盖层 */
@property (strong , nonatomic) GWPlayerMaskView * maskerView;
/** 是否正在播放 */
@property (assign , nonatomic) BOOL isPlayingEither;
/** 提示 */
@property (strong , nonatomic) UIAlertView * WWANAlertView;
@end

@implementation GWPlayerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self activeAudioSession];
        [self.layer addSublayer:self.playerLayer];
        [self addSubview:self.maskerView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerapClick)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        // 网络监听
       // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkingReachabilityDidChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    }
    return self;
}

// 点击了屏幕
- (void)tapGestureRecognizerapClick {
    if ( self.maskerView.isShowingEither ) {
        [self.maskerView hidePlayerMaskView];
    } else {
        [self.maskerView showPlayerMaskView];
    }
}

- (void)setVideoPlayerUrl:(NSString *)videoPlayerUrl {
    _videoPlayerUrl = [videoPlayerUrl copy];
    NSURL * videoURL = [NSURL URLWithString:[_videoPlayerUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    self.playerItem = [AVPlayerItem playerItemWithURL:videoURL];
    [self.videoPlayer replaceCurrentItemWithPlayerItem:self.playerItem];
    [self periodicTimeObserverForInterval];
    [self addStatusLoadedTimeRangesObserver];
    [self addNecessaryNotification];
}

- (void)play {
    //if ([GowalkNetWorkManagerTool shareNerWorkTool].networkManager.isReachableViaWWAN && self.isAllowWWANPlaying == NO) {
//        [self showWWANAlertView];
//        return;
    //}
    self.isPlayingEither = YES;
    [self.videoPlayer play];
    self.maskerView.playerButton.selected = YES;
    self.maskerView.slider.hidden = NO;
    // 隐藏覆盖层
    [self.maskerView hidePlayerMaskView];
}

//- (void)networkingReachabilityDidChange:(NSNotification *)sender {
//    AFNetworkReachabilityStatus status = [[sender.userInfo objectForKey:AFNetworkingReachabilityNotificationStatusItem] integerValue];
//    switch (status) {
//        case AFNetworkReachabilityStatusUnknown:
//        case AFNetworkReachabilityStatusNotReachable: {
//
//        } break;
//        case AFNetworkReachabilityStatusReachableViaWiFi: {
//            [self.WWANAlertView dismissWithClickedButtonIndex:self.WWANAlertView.cancelButtonIndex animated:YES];
//            if (self.isPlayingEither) {
//                [self play];
//            }
//        } break;
//        case AFNetworkReachabilityStatusReachableViaWWAN: {
//            if (self.isPlayingEither && !self.isAllowWWANPlaying) {
//                [self.videoPlayer pause];
//                self.maskerView.playerButton.selected = NO;
//                [self showWWANAlertView];
//            }
//        } break;
//        default:
//            break;
//    }
//}

- (void)showWWANAlertView {
    [self.WWANAlertView show];
    self.maskerView.slider.hidden = YES;
}

- (UIAlertView *)WWANAlertView{
    if (!_WWANAlertView) {
        _WWANAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"当前是非Wifi网络，继续播放将消耗较多的数据流量，是否继续播放？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续播放", nil];
    }
    return _WWANAlertView;
}

#pragma mark - <UIAlertViewDelegate>
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        self.isAllowWWANPlaying = YES;
        [self play];
    }
}

- (void)pause {
    self.isPlayingEither = NO;
    [self.videoPlayer pause];
    self.maskerView.playerButton.selected = NO;
}

// 播放时间进度回调
- (void)periodicTimeObserverForInterval {
    if (self.timeObserve) {
        [self.videoPlayer removeTimeObserver:self.timeObserve];
    }
    // 播放时间进度回调
    __weak typeof(self) weakself = self;
    [self.videoPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 30.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        // 当前播放秒
        float currentPlayTime = (double)weakself.playerItem.currentTime.value / weakself.playerItem.currentTime.timescale;
        float totalPlayTime = (double)weakself.playerItem.duration.value / weakself.playerItem.duration.timescale;
        [weakself.maskerView.slider setValue:currentPlayTime/totalPlayTime animated:YES];
    }];
}

- (void)addStatusLoadedTimeRangesObserver {
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];//监听status属性
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];//监听loadedTimeRanges属性
    [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];//监听播放的区域缓存是否为空
    [self.playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];//缓存可以播放的时候调用
}

- (void)addNecessaryNotification {
    // 播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    // 前台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    // 后台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackgroundNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
}

// 监听事件
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] intValue]; // 获取更改后的状态
        switch (status) {
            case AVPlayerStatusReadyToPlay: {
                NSLog(@"ReadyToPlay");
            } break;
            case AVPlayerStatusFailed: {
                NSLog(@"失败%@",self.playerItem.error);
            } break;
            case AVPlayerStatusUnknown: {
                NSLog(@"错误");
            } break;
            default: {
            } break;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        if (self.isPlayingEither) {
            CMTimeRange timeRange = [self.playerItem.loadedTimeRanges.firstObject CMTimeRangeValue]; // 缓冲时间
            NSTimeInterval timeInterval = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration); // 计算总缓冲时间 = start + duration
            CGFloat totalDuration = CMTimeGetSeconds(_playerItem.duration); // 总时间
            [self.maskerView.bufferProgressView setProgress:timeInterval / totalDuration * 1.0 animated:YES];
        }
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"])  { // 缓存为空
        if (self.isPlayingEither && !self.maskerView.slider.isTracking && [UIApplication sharedApplication].isFirstResponder) {
            self.maskerView.playerButton.selected = NO;
        }
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) { // 缓存达到可以播放的时候
        if (self.isPlayingEither && !self.maskerView.slider.isTracking && [UIApplication sharedApplication].isFirstResponder) {
            self.maskerView.playerButton.selected = YES;
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)playbackFinished {
    self.isPlayingEither = NO;
    self.maskerView.playerButton.selected = NO;
    [self.videoPlayer seekToTime:kCMTimeZero];
    [self.maskerView showPlayerMaskView];
}

- (void)enterForegroundNotification {
    [self.videoPlayer pause];
    self.maskerView.playerButton.selected = NO;
}

- (void)enterBackgroundNotification {
    [self activeAudioSession];
    [self.maskerView showPlayerMaskView];
}

- (void)activeAudioSession {
    // 如果去别的app观看直播后切到后台，然后打开app，此时可能会出现声音很小的问题，这里需要重新初始化一下AVAudioSession。
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
}

- (void)playerButtonClick:(UIButton *)sender {
//    sender.selected = !sender.selected;
    if (sender.selected == NO) {
        [self play];
    } else {
        [self pause];
    }
}

- (void)closeButtonClick:(UIButton *)sender {
    if (self.GWDelegate && [self.GWDelegate respondsToSelector:@selector(playerView:didClickCloseButtonWith:)]) {
        [self.GWDelegate playerView:self didClickCloseButtonWith:sender];
    }
}

#pragma mark slider操作
- (void)videoSliderTouchDown:(UISlider *)sender {
    [self.videoPlayer pause];
    self.maskerView.playerButton.selected = NO;
}

- (void)videoSliderValueChanged:(UISlider *)sender {
    float currentDuration = sender.value * self.playerItem.duration.value;
    [self.videoPlayer seekToTime:CMTimeMake(currentDuration , self.playerItem.duration.timescale)];
}

- (void)videoSliderTouchUpInside:(UISlider *)sender {
    float currentDuration = sender.value * self.playerItem.duration.value;
    [self.videoPlayer seekToTime:CMTimeMake(currentDuration , self.playerItem.duration.timescale) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        if (finished && self.isPlayingEither) {
            [self play];
        }
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
    self.maskerView.frame = self.bounds;
}

#pragma mark 懒加载
- (BOOL)isPlaying {
    if ([UIDevice currentDevice].systemVersion.integerValue > 10.0) {
        return self.videoPlayer.timeControlStatus == AVPlayerTimeControlStatusPlaying;
    } else {
        return self.videoPlayer.rate == 1.0;
    }
}

- (AVPlayer *)videoPlayer{
    if (!_videoPlayer) {
        _videoPlayer  = [AVPlayer playerWithPlayerItem:self.playerItem];
        if ([UIDevice currentDevice].systemVersion.integerValue >= 10.0) {
            _videoPlayer.automaticallyWaitsToMinimizeStalling = NO;
        }
    }
    return _videoPlayer;
}

- (AVPlayerItem *)playerItem {
    if (!_playerItem) {
        _playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:@""]];
    }
    return _playerItem;
}

- (AVPlayerLayer *)playerLayer{
    if (!_playerLayer) {
        _playerLayer  = [AVPlayerLayer playerLayerWithPlayer:self.videoPlayer];
    }
    return _playerLayer;
}

- (GWPlayerMaskView *)maskerView {
    if (!_maskerView) {
        _maskerView = [[GWPlayerMaskView alloc] init];
        [_maskerView.playerButton addTarget:self action:@selector(playerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_maskerView.closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_maskerView.slider addTarget:self action:@selector(videoSliderTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_maskerView.slider addTarget:self action:@selector(videoSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_maskerView.slider addTarget:self action:@selector(videoSliderTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maskerView;
}

#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UISlider class]]) {
        return NO;
    }
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.timeObserve) {
        [self.videoPlayer removeTimeObserver:self.timeObserve];
    }
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];//监听播放的区域缓存是否为空
    [self.playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];//缓存可以播放的时候调用
}

@end

@interface GWPlayerMaskView ()
/** 底部视图 */
@property (strong , nonatomic) UIView * bottomView;
@end

@implementation GWPlayerMaskView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.isShowingEither = YES;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        //
        self.bottomView = [[UIView alloc] init];
        [self addSubview:self.bottomView];
        
        self.bufferProgressView = [[UIProgressView alloc] init];
        self.bufferProgressView.backgroundColor = [UIColor clearColor];
        self.bufferProgressView.userInteractionEnabled = NO;
        self.bufferProgressView.progressTintColor = [UIColor lightTextColor];
        self.bufferProgressView.trackTintColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        [self.bottomView addSubview:self.bufferProgressView];
        // 1
        self.slider = [[UISlider alloc] init];
        self.slider.backgroundColor = [UIColor clearColor];
        [self.slider setThumbImage:[UIImage imageNamed:@"video_ThumbImage"] forState:UIControlStateNormal];
        self.slider.maximumTrackTintColor = [UIColor clearColor];
        self.slider.minimumTrackTintColor = [UIColor whiteColor];
        self.slider.minimumValue = 0.0;
        [self.bottomView addSubview:self.slider];
        // 2
        self.playerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.playerButton setImage:[UIImage imageNamed:@"video_pause"] forState:UIControlStateNormal];
        [self.playerButton setImage:[UIImage imageNamed:@"video_play"] forState:UIControlStateSelected];
        [self addSubview:self.playerButton];
        //
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.closeButton setImage:[UIImage imageNamed:@"video_close"] forState:UIControlStateNormal];
        [self addSubview:self.closeButton];
    }
    return self;
}

- (void)hidePlayerMaskView {
    self.isShowingEither = NO;
    [self.layer removeAllAnimations];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
    }];
}

- (void)showPlayerMaskView {
    self.isShowingEither = YES;
    [self.layer removeAllAnimations];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1.0;
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 1、播放按钮布局
    [self.playerButton sizeToFit];
    self.playerButton.center = self.center;
    // 2、关闭按钮布局
    [self.closeButton sizeToFit];
    
    if (@available(iOS 11.0, *)) {
        self.closeButton.frame = (CGRect){CGPointMake(CGRectGetMaxX(self.frame)-CGRectGetWidth(self.closeButton.frame)-self.safeAreaInsets.right - 15, 11),self.closeButton.frame.size};
    } else {
        self.closeButton.frame = (CGRect){CGPointMake(CGRectGetMaxX(self.frame)-CGRectGetWidth(self.closeButton.frame) - 15, 11),self.closeButton.frame.size};
    }
    
    if (@available(iOS 11.0, *)) {
        self.bottomView.frame = CGRectMake(0, self.frame.size.height - 65 - self.safeAreaInsets.bottom, self.frame.size.width, 65);
    } else {
        self.bottomView.frame = CGRectMake(0, self.frame.size.height - 65 , self.frame.size.width, 65);
    }
    // 3、缓冲进度条
    self.bufferProgressView.frame = CGRectMake(45, CGRectGetHeight(self.bottomView.frame) / 2.0 - 1, CGRectGetWidth(self.bottomView.frame) - 90, 2);
    
    self.slider.bounds = CGRectMake(0, 0, CGRectGetWidth(self.bufferProgressView.frame)+4, 40);
    self.slider.center = self.bufferProgressView.center;
}

@end

