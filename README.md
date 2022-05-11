
## ZKLoadHUD-Swift 是纯Swift版本的HUD
 ##### ZKLoadHUD-Swift功能列表:
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
 ##### 简单的使用方法：
        // 提示的文本
        let tipsText = "loading..."
        // 创建并显示HUD,指定父视图为self.view（默认父视图：window）
        let hud = ZKLoadHUD.hud(.activity(tipsText), superView: self.view)
        // 在2秒后自动隐藏
        hud.minShowTime = DispatchTimeInterval.seconds(2)
        // 指定显示的动画
        hud.show(.zoomIn)
        
        /*
         * // 在指定的地方隐藏它
         * DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
         *     hud.hide()
         *     // 带动画的方式隐藏
         *     // hud.hide(.zoomOut)
         * }****
         */
##### 更多使用例子请下载后运行.xcworkspace



