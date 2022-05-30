#
# Be sure to run `pod lib lint ModuleA.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LXTLoadHUD-Swift'
  s.version          = '0.0.3'
  s.summary          = 'LXTLoadHUD-Swift 是一个纯swift版本的HUD'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    HUD功能列表:
      1.支持简单的菊花 
      2.支持菊花底部带文字
      3.支持Porgress类型圆环、环形
      4.支持Porgress类型HUD带文字
      5.支持手动隐藏
      6.支持在...秒之后自动隐藏
      7.支持调整视图偏移量offsetY、offsetX 来设置位置
      8.支持添加到指定的视图UIView中
      9.支持默认大小、背景色、圆角半径
      10.支持动画显示/隐藏效果 动画类型有.fade .zoom .zoomIn .zoomOut
      11.支持自定义视图
      12.默认添加至Window
      13.类方法从指定视图移除HUD
      14.类方法在指定的视图中找出所有HUD
  DESC

  s.homepage         = 'https://gitee.com/DaviesH/LXTLoadhud-Swift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '丧尸先生' => '244160918@qq.com' }
  s.source           = { :git => 'https://gitee.com/DaviesH/LXTLoadhud-Swift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Hud/LXTLoadHUD/**/*'
  
  s.frameworks = 'UIKit', 'Foundation'
end
