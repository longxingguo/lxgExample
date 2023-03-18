//
//  GWPlayerView.h
//  takePhotoDemo
//
//  Created by lexingdao on 2018/1/25.
//  Copyright © 2018年 lexingdao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class GWPlayerView,GWPlayerSlider;

@protocol GWPlayerViewDelegate <NSObject>

- (void)playerView:(GWPlayerView *)playerView didClickCloseButtonWith:(UIButton *)sender;

@end

/// 播放器
@interface GWPlayerView : UIView
/** 播放器 */
@property (strong , nonatomic) AVPlayer * videoPlayer;
/** 播放地址 */
@property (strong , nonatomic) NSString * videoPlayerUrl;
/** 代理 */
@property (weak   , nonatomic) id <GWPlayerViewDelegate> GWDelegate;
/** 是否正在播放 */
@property (assign , nonatomic , readonly) BOOL isPlaying;
/** 允许4G播放 */
@property (assign , nonatomic) BOOL isAllowWWANPlaying;
- (void)play;

- (void)pause;

@end

/// 覆盖层
@interface GWPlayerMaskView : UIView
/** 缓冲进度条 */
@property (strong , nonatomic) UIProgressView * bufferProgressView;
/** 进度条 */
@property (strong , nonatomic) UISlider * slider;
/** 播放按钮 */
@property (strong , nonatomic) UIButton * playerButton;
/** 返回按钮 */
@property (strong , nonatomic) UIButton * closeButton;
/** 是否已经在显示 */
@property (assign , nonatomic) BOOL isShowingEither;

- (void)hidePlayerMaskView;

- (void)showPlayerMaskView;

@end

