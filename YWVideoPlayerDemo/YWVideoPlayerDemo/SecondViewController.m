//
//  SecondViewController.m
//  YWIjkplayer
//
//  Created by Candy on 2018/1/26.
//  Copyright © 2018年 com.scsskc. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.isLiveVideo = YES;
    [self.view addSubview:self.playerView];
   
    // 测试链接 http、rtmp、hls(m3u8)、本地视频等多种格式
//     NSString *testUrl = @"http://flv2.bn.netease.com/videolib3/1604/28/fVobI0704/SD/fVobI0704-mobile.mp4";
//     NSString *testUrl = @"rtmp://live.hkstv.hk.lxdns.com/live/hks";
    NSString *testUrl = @"http://dlhls.cdn.zhanqi.tv/zqlive/49427_jmACJ.m3u8";
    [self showPlayerViewWithUrl:testUrl Title:@"视频的标题"];
    [self autoPlay];
}


@end
