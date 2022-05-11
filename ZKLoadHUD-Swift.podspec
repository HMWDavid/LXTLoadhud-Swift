#
# Be sure to run `pod lib lint ModuleA.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZKLoadHUD-Swift'
  s.version          = '0.0.1'
  s.summary          = 'ZKLoadHUD-Swift 是一个纯swift版本的HUD'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    HUD功能列表:
        1.简单的菊花 （100%）
        2.菊花底部带文字（100%）
        3.进度圆环、环形（100%）
        4.进度带文字（100%）
        5.带取消的进度圆环(底部取消按钮/右上角关闭按钮)此功能待定（0%） 直接hud.hide()
        5.隐藏（100%）
        6.自定义视图 （100%）
        7.视图偏移量offsetY、offsetX （100%）
        8.添加到自定义视图 （100%）
        9.默认大小、背景色、圆角半径（100%）
        10.动画显示/隐藏效果 （100%）
        11.可以指定父视图 （100%）
        12.默认添加至Window（100%）
        13.类方法从指定视图移除HUD（100%）
  DESC

  s.homepage         = 'http://172.29.151.11/ios/zkloadhud-swift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '丧尸先生' => '244160918@qq.com' }
  s.source           = { :git => 'http://172.29.151.11/ios/zkloadhud-swift', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'Hud/ZKLoadHUD/**/*'
  
  s.frameworks = 'UIKit', 'Foundation'
end
