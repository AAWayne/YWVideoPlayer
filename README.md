# YWVideoPlayer
基于ijkPlayer的播放器，支持网络视频、RTMP直播、视频转播等

### 3分钟快速集成播放器

#### 一、使用 `Pod` 导入方式
**1、在podfile文件中添加，然后执行 `pod install`操作，由于使用的 `IJKMediaFramework.framework` 较大，请耐心等待**

```
pod 'YWVideoPlayer', '~> 1.0.0'
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
**4、照着`BasePlayerViewController`文件中的方式去使用即可**

```
// 这里的SecondViewController是继承了BasePlayerViewController
#import "SecondViewController.h"
@interface SecondViewController ()
@end
@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.isLiveVideo = YES; // 设置为直播
    [self.view addSubview:self.playerView];
    NSString *mvUrl = @"http://dlhls.cdn.zhanqi.tv/zqlive/49427_jmACJ.m3u8";
    [self showPlayerViewWithUrl:mvUrl Title:@"三国"];
    // 自动播放
    [self autoPlay];
}

@end
```

 

#### 二、手动拖拽到项目方式
**完善中**

