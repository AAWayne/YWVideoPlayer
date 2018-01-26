//
//  BasePlayerViewController.m
//  YWIjkplayer
//
//  Created by Candy on 2018/1/25.
//  Copyright © 2018年 com.scsskc. All rights reserved.
//

#import "BasePlayerViewController.h"
#import "AppDelegate.h"

@interface BasePlayerViewController ()

@end

@implementation BasePlayerViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 确保在该控制器即将消失的时候让屏幕处于非全屏状态
    ((AppDelegate *) [[UIApplication sharedApplication] delegate]).fullScreen = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

#pragma mark -- YWMediaPlayerViewDelegate

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

/// 准备播放
- (BOOL)playerViewWillBeginPlay:(YWMediaPlayerView *)player {
    NSLog(@"准备播放");
    return YES;
}

#pragma mark -- 旋转屏幕
// 改变View大小布局
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft ||
        [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        self.mediaPlayerView.frame = CGRectMake(0, 0, kDWidth, kDHeight);
        self.mediaPlayerView.player.view.frame = CGRectMake(0, 0, kDHeight, kDWidth);
        self.mediaPlayerView.mediaControl.fullScreenBtn.selected = YES;
        self.mediaPlayerView.isFullScreen = YES;
        [kDWindow addSubview:self.mediaPlayerView];
    } else {
        self.mediaPlayerView.frame = CGRectMake(0, 0, size.width, size.width/16*9);
        self.mediaPlayerView.player.view.frame = CGRectMake(0, 0, size.width, size.width/16*9);
        self.mediaPlayerView.mediaControl.fullScreenBtn.selected = NO;
        self.mediaPlayerView.isFullScreen = NO;
        [self.playerView addSubview:self.mediaPlayerView];
    }
}

#pragma mark -- 加载 & 移除
- (void)showPlayerViewWithUrl:(NSString *)urlString Title:(NSString *)title {
    [self removePlayViewSubViews];
    // 开启支持全屏模式
    ((AppDelegate *) [[UIApplication sharedApplication] delegate]).fullScreen = YES;
    [self.mediaPlayerView playerViewWithUrl:urlString WithTitle:title WithView:self.playerView WithDelegate:self];
}

- (void)removePlayerView {
    [self removePlayViewSubViews];
    // 关闭支持全屏模式 - 这里之所以关闭时因为有的应用其他界面只有一个方向
    ((AppDelegate *) [[UIApplication sharedApplication] delegate]).fullScreen = NO;
}

- (void)autoPlay {
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 自动播放
        [weakSelf.mediaPlayerView.mediaControl playControl];
    });
}


#pragma mark -- private
// 移除播放器视图上面的所有子控件
- (void)removePlayViewSubViews {
    for(int i = 0; i < self.playerView.subviews.count; i++){
        [[self.playerView.subviews objectAtIndex:i] removeFromSuperview];
    }
}



#pragma mark -- getter
- (UIView *)playerView {
    if (!_playerView) {
        _playerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDWidth, kDWidth/16*9)];
        _playerView.backgroundColor = [UIColor lightGrayColor];

    }
    return _playerView;
}

- (YWMediaPlayerView *)mediaPlayerView {
    if (!_mediaPlayerView) {
        _mediaPlayerView = [[YWMediaPlayerView alloc] init];
        if (_isLiveVideo) {
            _mediaPlayerView.mediaControl.totalDurationLabel.hidden = YES;
            _mediaPlayerView.mediaControl.mediaProgressSlider.hidden = YES;
            _mediaPlayerView.mediaControl.currentTimeLabel.hidden = YES;
        }
    }
    return _mediaPlayerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

