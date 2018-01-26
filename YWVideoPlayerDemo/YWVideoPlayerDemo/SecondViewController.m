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
   
    NSString *mvUrl = @"http://dlhls.cdn.zhanqi.tv/zqlive/49427_jmACJ.m3u8";
    [self showPlayerViewWithUrl:mvUrl Title:@"三国"];
    [self autoPlay];
}


@end
