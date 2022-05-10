//
//  ZKLoadHUD.swift
//  ZKLoadHUD
//
//  Created by zk_01 on 2022/5/9.
//

import UIKit
/* HUD功能列表
 1.简单的菊花
 2.菊花底部带文字
 3.进度圆环
 4.进度带文字
 5.带取消的进度圆环(底部取消按钮/右上角关闭按钮)
 5.隐藏
 6.自定义视图
 7.视图偏移量offsetY、offsetX
 8.添加到自定义视图
 9.默认大小、背景色、圆角半径
 10.动画效果
 11.可以指定父视图
 12.默认添加至Window
 */

/// ZKLoadHUD的类型
public enum ZKLoadHUDMode {
    
    /// 加载中的菊花样式(String为提示语，为空时不显示)
    case activity(String)
    
    /// 自定义视图样式
    case customView(UIView)
    
    /// 进度样式
    case progress
}

/// 动画类型
public enum ZKLoadHUDAnimation {
    case fade
    case zoom
    case zoomOut
    case zoomIn
    
}
/**
 * 可自定义的HUD
 */
open class ZKLoadHUD: UIView {
    
    // MARK: 公共属性
    /// ZKLoadHUD 模式类型 默认activity(“”)
    open var mode: ZKLoadHUDMode = .activity("")
    
    /// Y轴偏移量
    public var offsetY: CGFloat = 0.0 {
        didSet {
            guard self.offsetY != oldValue else { return }
            self.backgroundView.center.y = self.center.y + self.offsetY
        }
    }
    
    /// X轴偏移量
    public var offsetX: CGFloat = 0.0 {
        didSet {
            guard self.offsetX != oldValue else { return }
            self.backgroundView.center.x = self.center.x + self.offsetX
        }
    }
    
    ///  圆角半径
    public var backgroundViewCornerRadius: CGFloat = 5.0 {
        didSet {
            guard self.backgroundViewCornerRadius != oldValue else { return }
            self.backgroundView.layer.cornerRadius = self.backgroundViewCornerRadius
        }
    }
    
    /// 内边距
    /// 调整backgroundView和其上子视图的距离
    public var padding: UIEdgeInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 10.0, right: 10.0) {
        didSet {
            guard self.padding != oldValue else { return }
            self.layoutByPattern()
        }
    }
    
    /// 显示的时间，在...之后移除
    /// 在minShowTime之后自动移除
    /// 默认一直显示
    public var minShowTime: DispatchTimeInterval = .never
    
    /// 设置提醒文字与顶部控件的距离
    /// 默认：10.0
    public var tipsLabTopMargin: CGFloat = 10.0 {
        didSet {
            guard self.tipsLabTopMargin != oldValue else { return }
            self.layoutByPattern()
        }
    }
    
    /// 背景视图（盛放子控件）
    open lazy var backgroundView: ZKBackgroundView = {
        let backView = ZKBackgroundView()
        backView.layer.cornerRadius = self.backgroundViewCornerRadius
        backView.center = self.center
        self.addSubview(backView)
        return backView
    }()

    /// 加载中菊花
    open lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        if #available(iOS 13, *) {
            // medium: 20*20,  large: 37*37
            activity.style = .large
        } else {
            activity.style = .whiteLarge
        }
        activity.hidesWhenStopped = true
        self.backgroundView.addSubview(activity)
        return activity
    }()
    
    /// 提示语
    open lazy var detaiLabel: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .center
        lab.numberOfLines = 0
        lab.font = .systemFont(ofSize: 15.0)
        lab.textColor = .white
        self.backgroundView.addSubview(lab)
        return lab
    }()
    
    // MARK: 私有属性
    /// 距离左右两边的最小外边距
    /// 调整backgroundView距离物理屏幕左右两边的距离
    private var minHorizontalMargin: CGFloat = 35.0
    
    /// 物理屏幕宽
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    /// 物理屏幕高
    private var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    // MARK: 公共方法
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupViews()
    }
    
    #warning("这个方法是临时调试设置")
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        self.removeFromSuperview()
    }
    
    /// 创建并显示一个HUD
    /// - Parameters:
    ///   - mode: 显示的类型 ZKLoadHUDMode
    ///   - superView: HUD显示的父视图  默认显示到Window
    @discardableResult
    public class func showHUD(_ mode: ZKLoadHUDMode = .activity(""), _ superView: UIView? = ZKLoadHUD.getWindow()) -> ZKLoadHUD {
        
        assert(superView != nil, "父视图为空")
        
        let hud = self.createHUD(addedTo: superView ?? UIView())
        hud.mode = mode
        
        // 根据显示模式进行布局子视图
        hud.layoutByPattern()
    
        hud.show()
        return hud
    }
    
    /// 显示HUD
    public func show() {
        // TODO: 是否需要根据动画类型显示HUD
        // 根据动画显示
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1.0
        } completion: { _ in
            // 是否一直显示HUD
            guard self.minShowTime != .never else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + self.minShowTime) {
                self.removeFromSuperview()
            }
        }
    }
    
    /// 隐藏HUD
    public func hide() {
        // TODO: 是否需要动画
        self.removeFromSuperview()
    }
    
    /// 获取window
    /// - Returns: window(可选)
    public class func getWindow() -> UIWindow? {
        if #available(iOS 13, *) {
            guard let scene = UIApplication.shared.connectedScenes.first,
                  let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
                  let window = windowSceneDelegate.window else {
                
                let win = UIApplication.shared.connectedScenes
                                    .filter { $0.activationState == .foregroundActive }
                                    .compactMap { $0 as? UIWindowScene }.first?.windows
                                    .filter { $0.isKeyWindow }.first
                return win
            }
            return window
        } else {
            if let app = UIApplication.shared.delegate {
                return app.window ?? nil
            } else {
                return nil
            }
        }
    }
    
    /// 根据模式进行布局子视图
    /// 会更据当前hud的设置进行新的布局
    public func layoutByPattern() {
        switch self.mode {
        case .activity(let tips):
            self.setActivityModeHUD(tips)
        case .customView(let view):
            print(view)
        case .progress:
            break
        }
    }
    
    // MARK: 私有方法
    
    /// 创建一个HUD并添加到父视图上
    /// - Parameter superView: 父视图
    /// - Returns: ZKLoadHUD 实例
    @discardableResult
    private class func createHUD(addedTo superView: UIView) -> ZKLoadHUD {
        let hud = ZKLoadHUD(frame: superView.bounds)
        superView.addSubview(hud)
        return hud
    }
    
    /// 配置Activity模式的hud
    /// - Parameter tips: 提醒的文字
    private func setActivityModeHUD(_ tips: String) {
        
        self.detaiLabel.text = tips
        // 设置坐标
        self.setActivityModeLayout(tips)
        // 提示字符串为空的时候隐藏
        self.detaiLabel.isHidden = tips.isEmpty
        
        // 直接开始转圈
        if !self.activityIndicatorView.isAnimating {
            self.activityIndicatorView.startAnimating()
        }
    }
    
    /// 设置Activity模式下的各个控件坐标
    /// - Parameter tips: 提示语
    private func setActivityModeLayout(_ tips: String) {
        /*
         1.计算文字大小 并 判断是否大于activityIndicatorView的宽 取最大的宽值
         2.加上margin的上下左右距离 得出 backgroundView的size
         3.在根据offsetY/offsetX确定 backgroundView的位置
         */
        
        // 父视图的宽 - 左右最小边距 - backgroundView的内边距 = tips文字能显示的最大宽度
        let maxWidth = (self.superview?.frame.width ?? self.screenWidth) -  self.padding.left - self.padding.right - self.minHorizontalMargin * 2.0
        
        assert(maxWidth > 0, "父视图宽度较小,将显示异常,请合理使用")
        let size = tips.zk_calculateTextSize(font: self.detaiLabel.font, size: CGSize(width: maxWidth, height: self.screenHeight))
        
        var activityW = 37.0
        if #available(iOS 13, *) {
            // medium: 20*20,  large: 37*37
            activityW = self.activityIndicatorView.style ==  .large ? 37.0 : 20.0
        } else {
            activityW = self.activityIndicatorView.style == .whiteLarge ? 37.0 : 20.0
        }

        // backgroundView的宽 = 文字宽或者activityW的宽 + 左右两边的内边距
        let backgroundViewWidth  = max(size.width, activityW) + self.padding.left + self.padding.right
        
        // backgroundView的高 = 上内边距 + activityW(activity的高) + detaiLabel距离activity的大小 + 文字高度 + 底部内边距
        let backgroundViewHeight = self.padding.top + activityW + self.tipsLabTopMargin + size.height + self.padding.bottom
        
        self.backgroundView.frame  = CGRect(x: 0, y: 0, width: backgroundViewWidth, height: backgroundViewHeight)
        self.backgroundView.center = CGPoint(x: self.center.x + self.offsetX, y: self.center.y + self.offsetY)
        
        self.activityIndicatorView.frame = CGRect(x: (backgroundViewWidth - activityW) / 2.0, y: self.padding.top, width: activityW, height: activityW)
        
        // 提醒文字的frame
        self.detaiLabel.frame = CGRect(x: (backgroundViewWidth -  size.width) / 2.0, y: self.activityIndicatorView.frame.maxY + self.tipsLabTopMargin, width: size.width, height: size.height)
    }
    
    /// 相关的初始化配置
    private func setupViews() {
        self.isOpaque = false
        self.backgroundColor = .clear
//        self.alpha = 0.0 // 默认隐藏
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
}

// MARK: ZKBackgroundView 背景视图
open class ZKBackgroundView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    func commonInit() {
        self.backgroundColor = .black.withAlphaComponent(0.50)
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

// MARK: 扩展
extension String {
    
    /// 动态计算字体的Size
    /// - Parameters:
    ///   - font: 字体样式
    ///   - size: 限定的大小
    /// - Returns: 字体大小
    func zk_calculateTextSize(font: UIFont, size: CGSize) -> CGSize {
        
        // 动态计算字体宽度
        let rect = self.boundingRect(with: size,
                                     options: [.usesLineFragmentOrigin,
                                               .usesFontLeading,
                                               .truncatesLastVisibleLine],
                                  attributes: [NSAttributedString.Key.font: font] ,
                                     context: nil)
        return rect.size
    }
}
