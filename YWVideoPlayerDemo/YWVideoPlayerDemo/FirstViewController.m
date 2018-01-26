//
//  FirstViewController.m
//  YWIjkplayer
//
//  Created by Candy on 2018/1/10.
//  Copyright © 2018年 com.scsskc. All rights reserved.
//

#import "FirstViewController.h"
#import "YWMediaPlayerView.h"
#import "AppDelegate.h"

#define kDWidth [UIScreen mainScreen].bounds.size.width
#define MinPlayerHeight (kDWidth / 16 * 9)

@interface FirstViewController () <YWMediaPlayerViewDelegate>

@property (nonatomic, strong)YWMediaPlayerView  *mediaPlayerView;
@property (nonatomic, strong)UIView             *playerView;

@end

@implementation FirstViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ((AppDelegate *) [[UIApplication sharedApplication] delegate]).fullScreen = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ((AppDelegate *) [[UIApplication sharedApplication] delegate]).fullScreen = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _playerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDWidth, MinPlayerHeight)];
    _playerView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_playerView];
    _mediaPlayerView = [[YWMediaPlayerView alloc]init];
    
    // 测试链接
    // NSString *mvUrl = @"http://flv2.bn.netease.com/videolib3/1604/28/fVobI0704/SD/fVobI0704-mobile.mp4";
    // NSString *mvUrl = @"http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8";
    NSString *mvUrl = @"http://dlhls.cdn.zhanqi.tv/zqlive/49427_jmACJ.m3u8";

    [_mediaPlayerView playerViewWithUrl:mvUrl WithTitle:@"三国演义" WithView:_playerView  WithDelegate:self];
    
    // 这里如果是直播，则隐藏进度条以及时间等控件
    _mediaPlayerView.mediaControl.totalDurationLabel.hidden = YES;
    _mediaPlayerView.mediaControl.mediaProgressSlider.hidden = YES;
    _mediaPlayerView.mediaControl.currentTimeLabel.hidden = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 自动播放
        [_mediaPlayerView.mediaControl playControl];
    });
}

/// 改变View大小布局
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft ||
        [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        _mediaPlayerView.frame = CGRectMake(0, 0, size.width,size.height);
        _mediaPlayerView.player.view.frame = CGRectMake(0, 0, size.width,size.height);
        _mediaPlayerView.mediaControl.fullScreenBtn.selected = YES;
        _mediaPlayerView.isFullScreen = YES;
        [window addSubview:_mediaPlayerView];
    } else {
        _mediaPlayerView.frame = CGRectMake(0, 0, size.width, size.width/16*9);
        _mediaPlayerView.player.view.frame = CGRectMake(0, 0, size.width, size.width/16*9);
        _mediaPlayerView.mediaControl.fullScreenBtn.selected = NO;
        _mediaPlayerView.isFullScreen = NO;
        [_playerView addSubview:_mediaPlayerView];
    }
}

/// 点击关闭按钮
- (void)playerViewClosed:(YWMediaPlayerView *)player {
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
}

/// 全屏/非全屏切换
- (void)playerView:(YWMediaPlayerView *)player fullscreen:(BOOL)fullscreen {
    
    if (fullscreen == YES) {
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    } else {
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    }
}

/// 播放失败
- (void)playerViewFailePlay:(YWMediaPlayerView *)player {
    NSLog(@"播放失败");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

