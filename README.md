
## LXTLoadHUD-Swift 是纯Swift版本的HUD
![activity 不带文字](https://tva1.sinaimg.cn/large/e6c9d24egy1h2tu581h4vg209o0ledk5.gif)![activity 带文字](https://tva1.sinaimg.cn/large/e6c9d24egy1h2tu57u1hkg209o0leq89.gif)![activity 添加到指定View](https://tva1.sinaimg.cn/large/e6c9d24egy1h2tu57g0ybg209o0le79o.gif)
![customView 自定义视图](https://tva1.sinaimg.cn/large/e6c9d24egy1h2tu56r889g209o0leaf2.gif)![customView 自定义视图 添加到指定View](https://tva1.sinaimg.cn/large/e6c9d24egy1h2tu56gdh7g209o0legqs.gif)![progress 环形进度](https://tva1.sinaimg.cn/large/e6c9d24egy1h2tu5664h2g209o0len4y.gif)
![progress 环形进度 带文字](https://tva1.sinaimg.cn/large/e6c9d24egy1h2tu55biphg209o0leqb1.gif)![progress 圆形进度](https://tva1.sinaimg.cn/large/e6c9d24egy1h2tu54zjfkg209o0leahp.gif)![progress 圆形进度 带文字](https://tva1.sinaimg.cn/large/e6c9d24egy1h2tu54s8r9g209o0lewn0.gif)
![progress 添加到指定View](https://tva1.sinaimg.cn/large/e6c9d24egy1h2tu54h6cqg209o0lednu.gif)
 ##### LXTLoadHUD-Swift功能列表:
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
        let hud = LXTLoadHUD.hud(.activity(tipsText), superView: self.view)
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
##### 部分灵感来自MBProgressHUD Github仓库：https://github.com/jdg/MBProgressHUD



