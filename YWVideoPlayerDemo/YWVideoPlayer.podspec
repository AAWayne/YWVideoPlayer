Pod::Spec.new do |s|

  s.name          = "YWVideoPlayer"
  s.version       = "1.0.3"
  s.summary       = "基于ijkplayer的播放器,支持HTTP、RMTP、HLS(m3u8)、本地视频等等"
  s.description   = <<-DESC                 
		    基于ijkplayer的播放器,可播RMTP、网络视频、本地视频等等"
                  DESC
  s.homepage      = "https://github.com/90candy/YWVideoPlayer"
  s.license       = { :type => "Apache-2.0", :file => "LICENSE" }
  s.author        = { "阿唯不知道" => "920093012@qq.com" }
  s.platform      = :ios, "8.0"
  s.source        = { :git => "https://github.com/90candy/YWVideoPlayer.git", :tag => s.version }
  s.source_files  = "YWVideoPlayerDemo/YWVideoPlayer/*.{h,m}"
  s.resources     = "YWVideoPlayerDemo/YWVideoPlayer/Resources/*.png"
  s.requires_arc  = true
  s.dependency      "SDWebImage", ">=4.0.0"
  s.social_media_url = "https://www.jianshu.com/u/0f7d26d766f4"
  s.vendored_frameworks = "YWVideoPlayerDemo/IJKMediaFramework.framework"
  s.libraries     = "c++", "z", "bz2"
  s.frameworks    = ["UIKit", "Foundation", "MediaPlayer", "CoreAudio", "AudioToolbox", "Accelerate", "QuartzCore", "OpenGLES", "AVFoundation","CoreVideo","AVKit","CoreMedia","VideoToolbox","CoreTelephony"]

  # 发布命令：pod trunk push YWVideoPlayer.podspec --verbose --use-libraries --allow-warnings

 end
