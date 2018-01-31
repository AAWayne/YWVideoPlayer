//
//  YWMediaPlayerView.h
//  YWIjkPlayer
//
//  Created by Candy on 2017/10/10.
//  Copyright © 2017年 com.zhiweism. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "YWMediaControl.h"
#import "UIView+YWExtend.h"

@class YWMediaPlayerView;

@protocol YWMediaPlayerViewDelegate <NSObject>

/**
 *  点击关闭按钮
 */
- (void)playerViewClosed:(YWMediaPlayerView *)player;

/**
 *  全屏/非全屏切换
 */
- (void)playerView:(YWMediaPlayerView *)player fullscreen:(BOOL)fullscreen;
/**
 *  播放失败
 */
- (void)playerViewFailePlay:(YWMediaPlayerView *)player;


@optional

- (BOOL)playerViewWillBeginPlay:(YWMediaPlayerView *)player;

@end




@interface YWMediaPlayerView : UIView


@property (nonatomic, weak)   id<YWMediaPlayerViewDelegate> delegate;
@property (nonatomic, strong) id<IJKMediaPlayback>          player;
@property (nonatomic, strong) YWMediaControl              * mediaControl;
@property (nonatomic, assign) BOOL                          shouldAutoplay;
@property (nonatomic, assign) BOOL                          isFullScreen;
@property (nonatomic, assign) BOOL                          pushPlayerPause;    // 是否push到下个界面
@property (nonatomic, assign) BOOL                          beginPlay;          // 开始播放
@property (nonatomic, assign) NSString                    * historyPlayingTime; // 历史播放时间
@property (nonatomic, strong) UIImageView                 * previewImage;       // 预览图
@property (nonatomic, strong) NSString                    * previewImageName;   // 预览图名字
@property (nonatomic, strong) NSString                    * previewImagePath;   // 预览图路径


- (instancetype)initWithFrame:(CGRect)frame uRL:(NSURL *)url title:(NSString *)title;
-(void)playerViewWithUrl:(NSString*)urlString WithTitle:(NSString*)title WithView:(UIView*)view WithDelegate:(UIViewController*)viewController;
- (void)setIsFullScreen:(BOOL)isFullScreen;


- (void)playerWillShow;
- (void)playerWillHide;
- (void)removePlayer;

/**
 *  预览图
 */
- (void)showPreviewImage:(id)imagePath;
- (void)showLocalPreviewImage:(NSString *)imageName;
// 获取视频文件的第一帧作为预览图
- (void)showFirstFramePreviewImage:(NSString *)videoPath;


@end

