//
//  YWMediaPlayerView.m
//  YWIjkPlayer
//
//  Created by Candy on 2017/10/10.
//  Copyright © 2017年 com.zhiweism. All rights reserved.
//

#import "YWMediaPlayerView.h"
#import "UIImageView+WebCache.h"
#import "YWReachability.h"
#import <AVFoundation/AVFoundation.h>

#define PLACEHOlDER_IMAGE [UIImage imageNamed:@"default_load_image"]

typedef void(^Handler)(UIAlertAction *handler);

@interface UIViewController()<YWMediaPlayerViewDelegate>
@end

@interface YWMediaPlayerView()<YWMediaControlDelegate>

@property (nonatomic, strong)UIView     *view;
@property (nonatomic, strong)NSString   *title;
@property (nonatomic, strong)NSURL      *url;

@property (nonatomic, strong) UIWindow *keyWindow;
@end

@implementation YWMediaPlayerView


- (instancetype)initWithFrame:(CGRect)frame uRL:(NSURL *)url title:(NSString *)title {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.title = title;
        self.url = url;

        [self addSubview:self.view];

        [self.view addSubview:self.mediaControl];
        [self onClickPlayButton:nil];

    }
    
    return self;
    
}


-(void)playerViewWithUrl:(NSString*)urlString WithTitle:(NSString*)title WithView:(UIView*)view WithDelegate:(UIViewController*)viewController {
 
    _beginPlay = NO;
    self.frame = CGRectMake(0, 0, view.width, view.height);
    self.title = title;
    self.url = [NSURL URLWithString:urlString];

    [self addSubview:self.view];

    [self.view addSubview:self.mediaControl];
    [view addSubview:self];
    self.delegate = viewController;
//    [self onClickPlayButton:nil];
}
- (void)setTitle:(NSString *)title{
    _title=title;
    self.mediaControl.titleLabel.text = self.title;
}
- (UIView*)view {
    if (!_view) {
        _view = [[UIView alloc] initWithFrame:self.bounds];
        _view.backgroundColor = [UIColor blackColor];
    }
    
    return _view;
    
}
- (YWMediaControl*)mediaControl {
    if (!_mediaControl) {
        _mediaControl = [[YWMediaControl alloc] initWithFrame:self.bounds];
//        _mediaControl.titleLabel.text = self.title;
        _mediaControl.delegate = self;
    }
      
    return _mediaControl;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.view.frame = self.bounds;
    self.mediaControl.frame = self.view.bounds;
    CGFloat autoPlayer_H = (self.view.width / 16 * 9);
    CGFloat top = (self.view.height - autoPlayer_H)/2;
    CGRect playFrame = CGRectMake(0, top, self.view.width, autoPlayer_H);
    playFrame = CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.width, [UIApplication sharedApplication].keyWindow.height);
    if (CGRectGetWidth(self.playerFrame) != 0) {
        playFrame = self.playerFrame;
    }
    [self.player view].frame = playFrame;
//    [self.player view].frame = CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.width, [UIApplication sharedApplication].keyWindow.height);
    
    if (_previewImage) {
        _previewImage.frame = playFrame;
//        _previewImage.frame = CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.width, [UIApplication sharedApplication].keyWindow.height);
    }
    
}



- (void)playerWillShow {
    if (!self.player) {
        [self preparePlayer];
    }
    
    [self installMovieNotificationObservers];
    [self.player prepareToPlay];
    
}

- (void)playerWillHide {
    if (self.player) {
        [self.player shutdown];
        [self removeMovieNotificationObservers];
    }
    
}

- (void)removePlayer {
    [self playerWillHide];
    [self removeFromSuperview];
}

- (void)setShouldAutoplay:(BOOL)shouldAutoplay {
    _shouldAutoplay = shouldAutoplay;
    _beginPlay = (_beginPlay || shouldAutoplay);
}

/**
 *  预览图
 */
- (void)showPreviewImage:(id)imagePath {
    NSURL *pathUrl;
    if ([imagePath isKindOfClass:[NSString class]]) {
        pathUrl = [NSURL URLWithString:imagePath];
    } else if ([imagePath isKindOfClass:[NSURL class]]) {
        pathUrl = imagePath;
    }
    [self.previewImage sd_setImageWithURL:pathUrl placeholderImage:PLACEHOlDER_IMAGE];
}
- (void)showLocalPreviewImage:(NSString *)imageName {
    self.previewImage.image = [UIImage imageNamed:imageName];
}
- (void)showFirstFramePreviewImage:(NSString *)videoPath {
    self.previewImage.image = [self getFirstFrameWithVideoURL:[NSURL URLWithString:videoPath]];
    self.previewImage.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)preparePlayer {
    
#ifdef DEBUG
    [IJKFFMoviePlayerController setLogReport:YES];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
#else
    [IJKFFMoviePlayerController setLogReport:NO];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
#endif
    
    
    
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    
    if (self.player) {
        [self.player shutdown];
        [self.player.view removeFromSuperview];

        self.player=nil;
    }
    
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.url withOptions:options];
    self.player.view.frame = self.view.bounds;
    
//    self.player.view.frame = CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.width, [UIApplication sharedApplication].keyWindow.height);
    self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
    self.player.shouldAutoplay = YES;
    
    [self.view  insertSubview:self.player.view belowSubview:self.mediaControl];
    
    self.mediaControl.delegatePlayer = self.player;
  
}

- (void)setPlayerFrame:(CGRect)playerFrame {
    _playerFrame = playerFrame;
    [self.player view].frame = playerFrame;
}

- (void)setIsFullScreen:(BOOL)isFullScreen
{
    self.mediaControl.isFullscreen = isFullScreen;
}


#pragma mark XZYMediaControlDelegate

- (void)onClickMediaControl:(id)sender
{
    if (!_beginPlay) {
        return;
    }
    [self.mediaControl showAndFade];
}


- (void)onClickDone:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(playerViewClosed:)]) {
        [self.delegate playerViewClosed:self];
    } else {
        NSLog(@"%@ playerViewClosed未实现，无法响应关闭按钮",NSStringFromClass([self class]));
    }
}

- (void)onClickHUD:(UIBarButtonItem *)sender
{
    if ([self.player isKindOfClass:[IJKFFMoviePlayerController class]]) {
        IJKFFMoviePlayerController *player = self.player;
        player.shouldShowHudView = !player.shouldShowHudView;
        
        sender.title = (player.shouldShowHudView ? @"HUD On" : @"HUD Off");
    }
}

- (void)onClickPlayButton:(id)sender
{
    if (!_beginPlay) {

        BOOL canPlay = YES;

        if ([self.delegate respondsToSelector:@selector(playerViewWillBeginPlay:)]) {
            canPlay = [self.delegate playerViewWillBeginPlay:self];
        }

        if (canPlay) {
            [self preparePlayer];
            [self playerWillShow];
            [self.mediaControl setShowActivite:YES];
            [self.mediaControl refreshMediaControl];
        }
        _beginPlay = canPlay;
        return;
    }


    if ([self.player isPlaying]) {
        [self.player pause];
        [self.mediaControl refreshMediaControl];
    } else {

        [self.player play];
        [self.mediaControl refreshMediaControl];

    }
}

- (void)onClickFullscreen:(BOOL)isFull
{
    if ([self.delegate respondsToSelector:@selector(playerView:fullscreen:)]) {
        [self.delegate playerView:self fullscreen:isFull];
    }
}

- (void)didSliderTouchUpInside
{
    self.player.currentPlaybackTime = self.mediaControl.mediaProgressSlider.value;
    [self.mediaControl endDragMediaSlider];
}

- (void)didSliderValueChanged
{
    [self.mediaControl continueDragMediaSlider];
}


#pragma mark - 通知action


- (void)loadStateDidChange:(NSNotification*)notification
{
//    MPMovieLoadStateUnknown        = 0,
//    MPMovieLoadStatePlayable       = 1 << 0,
//    MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
//    MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started

    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: %d\n", (int)loadState);
        [self.mediaControl setShowActivite:NO];
    } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
        [self.mediaControl setShowActivite:YES];
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification
{

    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    switch (reason)
    {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
        {
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            
            [self failPlay];
            
            break;
            
        }
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
    NSLog(@"mediaIsPreparedToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification
{
    
    switch (_player.playbackState)
    {
        case IJKMPMoviePlaybackStateStopped: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePlaying: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePaused: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            
            
            break;
        }
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}


- (void)moviePlayFirstVideoFrameRendered:(NSNotification*)notification
{
    NSLog(@"加载第一个画面！");
    if (_previewImage) {
        _previewImage.hidden = YES;
    }
    
    [self.mediaControl setShowActivite:NO];
    [self.mediaControl performSelector:@selector(hide) withObject:nil afterDelay:2];
    
    
    
    if(![self.player isPlaying]){
        NSLog(@"检测的一次播放状态错误");
        [self.player play];
    }
    if (self.pushPlayerPause) {
        [self.player pause];
    }
    
    if (self.historyPlayingTime) {
     [self.player setCurrentPlaybackTime:[self.historyPlayingTime integerValue]];
    }

    
}

#pragma mark Install Movie Notifications

/* Register observers for the various movie object notifications. */
-(void)installMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayFirstVideoFrameRendered:)
                                                 name:IJKMPMoviePlayerFirstVideoFrameRenderedNotification
                                               object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(networkStateChange) name:kYWReachabilityChangedNotification object:nil];
    // 创建YWReachability
    YWReachability *reachability = [YWReachability reachabilityForInternetConnection];
    
    // 开始监控网络(一旦网络状态发生改变, 就会发出通知kYWReachabilityChangedNotification)
    [reachability startNotifier];
}
- (void)networkStateChange
{
    __weak typeof(self) weakSelf = self;
    // 1.检测网络状态
    YWReachability *wifi = [YWReachability reachabilityForLocalWiFi];
    
    // 2.检测手机是否能上网络
    YWReachability *connect = [YWReachability reachabilityForInternetConnection];
    
    // 3.判断网络状态
    if ([wifi currentYWReachabilityStatus] != NotReachable) {
        NSLog(@"正在使用WIFI播放");
    }
    else if ([connect currentYWReachabilityStatus] != NotReachable) {
        NSLog(@"正在使用手机自带网络播放");
        [self alertWithTitle:@"提示" message:@"当前使用移动网络是否继续播放" okTitle:@"继续播放" cancelTitle:@"关闭" okHandler:nil cancelHandler:^(UIAlertAction *handler) {
            [weakSelf playerWillHide];
        }];
    }
    else {
        NSLog(@"暂无可用网络");
        [self alertWithTitle:@"提示" message:@"似乎已经断开网络连接" okTitle:@"检查网络" cancelTitle:@"关闭" okHandler:^(UIAlertAction *handler) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
#else
            // Wi-Fi — prefs:root=WIFI
            NSURL *url = [NSURL URLWithString:@"prefs:root=General"];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
#endif
        } cancelHandler:^(UIAlertAction *handler) {
            [weakSelf playerWillHide];
        }];
    }
}
#pragma mark Remove Movie Notification Handlers

/* Remove the movie notification observers from the movie object. */
-(void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}


#pragma mark - Other

- (void)removeFromSuperview {
    if (_player) {
        [_player shutdown];
        [_player.view removeFromSuperview];
        _player = nil;
    }
    [super removeFromSuperview];
}

- (UIImageView *)previewImage {
    if (!_previewImage) {
        _previewImage = [[UIImageView alloc] init];
        [self.view insertSubview:_previewImage belowSubview:self.mediaControl];
    }
    
    return _previewImage;
    
}

#pragma mark - pravite

- (void)failPlay {
    if (self.player) {
        [self.player pause];
    }
    
    [self.mediaControl failPlayVideo];
    
    
    if ([self.delegate respondsToSelector:@selector(playerViewFailePlay:)]) {
        [self.delegate playerViewFailePlay:self];
    }
    
    
}

// 获取视频第一帧图片
- (UIImage *)getFirstFrameWithVideoURL:(NSURL *)URL {
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:URL options:opts];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(self.view.width, self.view.width / 16 * 9);
    NSError *error = nil;
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(0, 10) actualTime:NULL error:&error];
    if (!error) {
        return [UIImage imageWithCGImage:img];
    }
    return nil;
}

#pragma mark - Screen Orientation

#pragma mark - alertViewController
- (void)alertWithTitle:(NSString *)title message:(NSString *)message okTitle:(NSString *)okTitle cancelTitle:(NSString *)cancelTitle okHandler:(Handler)okHandler cancelHandler:(Handler)cancelHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okTitle  style:UIAlertActionStyleDefault handler:okHandler];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:cancelHandler];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    UIViewController *rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    [rootVC presentViewController:alertController animated:YES completion:nil];
}


@end

