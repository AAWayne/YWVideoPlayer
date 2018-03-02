[![Pod](https://img.shields.io/badge/Pod-1.0.3-orange.svg)](https://github.com/90candy)
[![Platform](https://img.shields.io/badge/Platform-iOS-ff69b4.svg)](https://github.com/90candy)
 [![License](https://img.shields.io/github/license/alibaba/dubbo.svg)](https://github.com/90candy)
[![Author](https://img.shields.io/badge/Author-阿唯不知道-blue.svg)](https://www.jianshu.com/u/0f7d26d766f4)

### 全屏模式 - 效果图
![](./效果图.png)

> 基于ijkPlayer的网络播放器，支持HTTP、RTMP、HLS(m3u8)、本地视频等多种格式
> 
> 3分钟快速集成播放器，支持小屏、全屏模式，无需手动添加任何依赖库

#### 一、推荐使用`CocoaPods`方式集成
**1、在podfile文件中添加，然后执行 `pod install`操作，文件较大，请耐心等待**

```
pod 'YWVideoPlayer', '~> 1.0.3'
```

**2、`AppDelegate.h` 文件中加入 `fullScreen ` 属性，如下**

```
#import <UIKit/UIKit.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) BOOL fullScreen;

@end
```

**3、在 `AppDelegate.m` 文件中 加入横屏方法（无需调用）**

```
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    if (self.fullScreen == YES) {
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskPortrait;
}
```

**4、在播放器控制器界面导入头文件**
*Demo 里面是在`BasePlayerViewController`中引入相关头文件*

```
#import "YWMediaPlayerView.h"
```

**5、照着`BasePlayerViewController`文件中的方式去使用即可**

```
// 这里的SecondViewController是继承了BasePlayerViewController
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
   
    // 测试链接 http、rtmp、m3u8
    // NSString *testUrl = @"http://flv2.bn.netease.com/videolib3/1604/28/fVobI0704/SD/fVobI0704-mobile.mp4";
    // NSString *testUrl = @"rtmp://live.hkstv.hk.lxdns.com/live/hks";
    NSString *testUrl = @"http://dlhls.cdn.zhanqi.tv/zqlive/49427_jmACJ.m3u8";
    [self showPlayerViewWithUrl:testUrl Title:@"视频的标题"];
    // 自动播放
    [self autoPlay];
}

@end
```


#### 二、手动拖拽到项目方式
**完善中**

-----------------------------------

**简书地址：https://www.jianshu.com/p/546df1c8a3fc**

<div align="center">    
	<img src = "http://upload-images.jianshu.io/upload_images/2822163-23eb59c7072548bb.png" width = "300" height = "100" alt="图片名称" align = center />
</div>


