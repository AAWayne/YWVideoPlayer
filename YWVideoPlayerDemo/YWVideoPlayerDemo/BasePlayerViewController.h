//
//  BasePlayerViewController.h
//  YWIjkplayer
//
//  Created by Candy on 2018/1/25.
//  Copyright © 2018年 com.scsskc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+YWExtend.h"
#import "YWMediaPlayerView.h"

@interface BasePlayerViewController : UIViewController <YWMediaPlayerViewDelegate>

@property (nonatomic, strong) UIView                    *playerView;      //播放器背景图片
@property (nonatomic, strong) YWMediaPlayerView         *mediaPlayerView; //播放器
@property (nonatomic, assign) BOOL                      isLiveVideo;      // 是否是视频直播

// 加载播放器视图
- (void)showPlayerViewWithUrl:(NSString *)urlString Title:(NSString *)title;
// 移除播放器视图
- (void)removePlayerView;
// 自动播放
- (void)autoPlay;

@end
