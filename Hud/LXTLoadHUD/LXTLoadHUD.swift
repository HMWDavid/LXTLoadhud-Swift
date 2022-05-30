//
//  LXTLoadHUD.swift
//  LXTLoadHUD
//
//  Created by zk_01 on 2022/5/9.
//

import UIKit
/*
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
 */

/// LXTLoadHUD的类型
public enum LXTLoadHUDMode {
    
    /// 加载中的菊花样式(String为提示语，为空时不显示)
    case activity(String)
    
    /// 自定义视图样式
    case customView(UIView)
    
    /// 进度样式: 圆形进度
    /// 底部提示的文字
    case progress(LXTLoadHUDRoundProgressView.ProgressLayerMode)
}

/// 动画类型
public enum LXTLoadHUDAnimation {
    case fade
    case zoom
    case zoomOut
    case zoomIn
    
}

// MARK: 扩展
fileprivate extension String {
    
    /// 动态计算字体的Size
    /// - Parameters:
    ///   - font: 字体样式
    ///   - size: 限定的大小
    /// - Returns: 字体大小
    func lxt_calculateTextSize(font: UIFont, size: CGSize) -> CGSize {
        
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

/**
 * 可自定义的HUD
 */
open class LXTLoadHUD: UIView {
    
    // MARK: 公共属性
    /// LXTLoadHUD 模式类型 默认activity(“”)
    open var mode: LXTLoadHUDMode = .activity("")
    
    /// Y轴偏移量
    /// 默认：0.0
    public var offsetY: CGFloat = 0.0
    
    /// X轴偏移量
    /// 默认：0.0
    public var offsetX: CGFloat = 0.0
    
    ///  圆角半径
    ///  默认： 5.0f
    public var backgroundViewCornerRadius: CGFloat = 5.0
    
    /// 内边距
    /// 调整backgroundView和其上子视图的距离
    /// 默认： UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    public var padding: UIEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    /// 显示的时间，在...之后移除
    /// 在minShowTime之后自动移除
    /// 注: mode为progress模式时无效
    /// 默认: .never 一直显示
    public var minShowTime: DispatchTimeInterval = .never
    
    /// 当隐藏时是否从父视图中移除
    /// 默认：Ture
    public var removeFromSuperViewOnHide: Bool = true
    
    /// 设置提醒文字与顶部控件的距离
    /// 默认：10.0
    public var tipsLabTopMargin: CGFloat = 10.0
    
    /// 背景视图（盛放子控件）
    open lazy var backgroundView: LXTLoadHUDBackgroundView = {
        let backView = LXTLoadHUDBackgroundView()
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
    
    /// 进度环视图
    lazy var roundProgressView: LXTLoadHUDRoundProgressView = {
        let progressV = LXTLoadHUDRoundProgressView(frame: CGRect(x: 0, y: 0, width: 37.0, height: 37.0))
        self.backgroundView.addSubview(progressV)
        return progressV
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
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupViews()
    }
    
    /// 相关的初始化配置
    private func setupViews() {
        self.isOpaque = false
        self.backgroundColor = .clear
        self.backgroundView.alpha = 0.0 // 默认隐藏
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

// MARK: 公共方法
extension LXTLoadHUD {
    
    /// 创建一个HUD 实例
    /// - Parameters:
    ///   - mode: 显示的类型 LXTLoadHUDMode
    ///   - superView: HUD显示的父视图  默认显示到Window
    /// - Returns: LXTLoadHUD 实例
    @discardableResult
    public class func hud(_ mode: LXTLoadHUDMode = .activity(""),
                          superView: UIView? = LXTLoadHUD.getWindow()) -> LXTLoadHUD {
        var tmpSuperV = superView
        if superView == nil {// 避免传入的为nil
            tmpSuperV = LXTLoadHUD.getWindow()
        }
        assert(tmpSuperV != nil, "⚠️⚠️⚠️ 父视图为空")
        
        let hud = self.createHUD(addedTo: tmpSuperV ?? UIView())
        hud.mode = mode
        return hud
    }
    
    /// 显示HUD
    /// 默认动画方式： .fade
    public func show(_ animation: LXTLoadHUDAnimation = .fade) {
        DispatchQueue.main.async {
            // 根据显示模式进行布局子视图
            self.layoutByPattern()
            
            self.animateIn(true, animtaionType: animation) { [weak self] _ in
                // 是否一直显示HUD
                guard let self = self, self.minShowTime != .never else { return }
                
                switch self.mode {
                case .progress:
                    debugPrint("[Debug] 当前类型为进度的类型，设置 minShowTime 无效")
                    return
                default:
                    break
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + self.minShowTime) {
                    self.hide(animation)
                }
            }
        }
    }
    
    /// 隐藏HUD
    /// 默认动画方式： .fade
    public func hide(_ animation: LXTLoadHUDAnimation = .fade) {
        DispatchQueue.main.async {
            self.animateIn(false, animtaionType: animation) { [weak self] _ in
                guard let self = self else { return }
                if self.removeFromSuperViewOnHide {
                    self.removeFromSuperview()
                }
            }
        }
    }
    
    /// 从指定的View上
    /// - Parameters:
    ///   - View: 指定的View
    ///   - animation: 动画效果
    public class func hide(for view: UIView, _ animation: LXTLoadHUDAnimation = .fade) {
        DispatchQueue.main.async {
           
            for item in view.subviews where item.isKind(of: LXTLoadHUD.self) {
                let itemV = item as? LXTLoadHUD
                itemV?.animateIn(false, animtaionType: animation) { _ in
                    guard let selfItem = itemV else { return }
                    if selfItem.removeFromSuperViewOnHide {
                        selfItem.removeFromSuperview()
                    }
                }
            }

        }
    }
    
    /// 查找出指定是View视图上的所有HUD
    /// - Parameter view: 对应的视图
    /// - Returns: [LXTLoadHUD]
    public class func findHUD(for view: UIView) -> [LXTLoadHUD] {
        let huds =  view.subviews.filter({ item in
            return item.isKind(of: LXTLoadHUD.self)
        }) as? [LXTLoadHUD]
        
        return huds ?? [LXTLoadHUD]()
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
        DispatchQueue.main.async {
            switch self.mode {
            case .activity(let tips):
                self.setActivityModeHUD(tips)
            case .customView(let view):
                self.setCustomViewLayout(view)
            case .progress(let progressMode):
                self.roundProgressView.mode = progressMode
                self.setProgressModeLayout("")
            }
        }
    }
    
    /// 更新进度值
    /// - Parameter progress: 进度值 0.0  ~ 1.0
    /// - Parameter des: 描述
    public func updateProgress(_ progress: Float, des: String = "") {
//        assert(progress >= 0.0 && progress < 1.0, "⚠️⚠️⚠️进度值: \(progress)有误！")
        var progressTemp = progress
        if progress < 0.0 {
            progressTemp = 0.0
        }
        if progress > 1.0 {
            progressTemp = 1.0
        }
        switch self.mode {
        case .progress:
            debugPrint("[Debug] progress = \(progressTemp)")
            DispatchQueue.main.async {
                if !des.isEmpty {
                    self.setProgressModeLayout(des)
                }
                self.roundProgressView.progress = progressTemp
            }
        default:
            debugPrint("[Debug] 非 progress 类型的HUD")
        }
    }
}

// MARK: 私有方法
extension LXTLoadHUD {
        
    /// 创建一个HUD并添加到父视图上
    /// - Parameter superView: 父视图
    /// - Returns: LXTLoadHUD 实例
    @discardableResult
    private class func createHUD(addedTo superView: UIView) -> LXTLoadHUD {
        let hud = LXTLoadHUD(frame: superView.bounds)
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
    
    /// 动画显示和隐藏
    /// - Parameters:
    ///   - animatingIn: 是否为进入
    ///   - animtaionType: 动画类型
    ///   - completion: 动画结束回调
    func animateIn(_ animatingIn: Bool, animtaionType: LXTLoadHUDAnimation, completion:@escaping (Bool)->()) {
        var type = animtaionType
        // 自动确定正确的缩放动画类型
        if animtaionType == .zoom {
            type = animatingIn ? .zoomIn : .zoomOut
        }
        
        let small = CGAffineTransform(scaleX: 0.5, y: 0.5)
        let large = CGAffineTransform(scaleX: 1.5, y: 1.5)
        
        // 设置起始状态
        if animatingIn && self.backgroundView.alpha == 0.0 && type == .zoomIn {
            self.backgroundView.transform = small
        } else if (animatingIn && self.backgroundView.alpha == 0.0 && type == .zoomOut) {
            self.backgroundView.transform = large
        }
        
        // 动画
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .beginFromCurrentState, animations: {
            if animatingIn {
                self.backgroundView.transform = CGAffineTransform.identity
            } else if (!animatingIn && type == .zoomIn) {
                self.backgroundView.transform = large
            } else if (!animatingIn && type == .zoomOut) {
                self.backgroundView.transform = small
            }
            self.backgroundView.alpha = animatingIn ? 1.0 : 0.0
        }, completion: completion)
    }
}

// MARK: 布局子视图
extension LXTLoadHUD {
    // MARK: Activity 模式的布局
    /// 设置Activity模式下的各个控件坐标
    /// - Parameter tips: 提示语
    private func setActivityModeLayout(_ tips: String) {
        /*
         1.计算文字大小 并 判断是否大于activityIndicatorView的宽 取最大的宽值
         2.加上padding的上下左右距离 得出 backgroundView的size
         3.在根据offsetY/offsetX确定 backgroundView的位置
         */
        
        // 父视图的宽 - 左右最小边距 - backgroundView的内边距 = tips文字能显示的最大宽度
        // 最大能显示的宽度
        let maxWidth = (self.superview?.frame.width ?? self.screenWidth) -  self.padding.left - self.padding.right - self.minHorizontalMargin * 2.0
        
        assert(maxWidth > 0, "⚠️⚠️⚠️ 父视图宽度较小,将显示异常,请合理使用")
        guard maxWidth > 0 else {
            print("⚠️⚠️⚠️ 父视图宽度较小,将显示异常,请合理使用")
            return
        }
        
        // 计算文字大小
        let size = tips.lxt_calculateTextSize(font: self.detaiLabel.font, size: CGSize(width: maxWidth, height: self.screenHeight))
        
        // 文字为空时，取消detaiLabel与上面视图的间距
        let tempTipsLabTopMargin = tips.isEmpty ? 0.0 : self.tipsLabTopMargin
        
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
        let backgroundViewHeight = self.padding.top + activityW + tempTipsLabTopMargin + (tips.isEmpty ? 0.0 : size.height) + self.padding.bottom
        
        self.backgroundView.frame  = CGRect(x: 0, y: 0, width: backgroundViewWidth, height: backgroundViewHeight)
        self.backgroundView.center = CGPoint(x: self.center.x + self.offsetX, y: self.center.y + self.offsetY)
        
        self.activityIndicatorView.frame = CGRect(x: (backgroundViewWidth - activityW) / 2.0, y: self.padding.top, width: activityW, height: activityW)
        
        // 提醒文字的frame
        self.detaiLabel.frame = CGRect(x: (backgroundViewWidth -  size.width) / 2.0, y: self.activityIndicatorView.frame.maxY + tempTipsLabTopMargin, width: size.width, height: size.height)
        self.detaiLabel.isHidden = tips.isEmpty
    }
    
    // MARK: 设置进度模式下的布局
    private func setProgressModeLayout(_ tips: String) {
        /*
         1.计算文字大小 并 判断是否大于self.roundProgressView.intrinsicContentSize的宽 取最大的宽值
         2.加上padding的上下左右距离 得出 backgroundView的size
         3.在根据offsetY/offsetX确定 backgroundView的位置
         */
        
        self.detaiLabel.text = tips
        
        // 文字为空时，取消detaiLabel与上面视图的间距
        let tempTipsLabTopMargin = tips.isEmpty ? 0.0 : self.tipsLabTopMargin
        
        // 最大能显示的宽度
        let maxWidth = (self.superview?.frame.width ?? self.screenWidth) -  self.padding.left - self.padding.right - self.minHorizontalMargin * 2.0
        
        assert(maxWidth > 0, "⚠️⚠️⚠️ 父视图宽度较小,将显示异常,请合理使用")
        guard maxWidth > 0 else {
            print("⚠️⚠️⚠️ 父视图宽度较小,将显示异常,请合理使用")
            return
        }
        
        // 计算文字大小
        let size = tips.lxt_calculateTextSize(font: self.detaiLabel.font, size: CGSize(width: maxWidth, height: self.screenHeight))
        
        // backgroundView的宽 = 文字宽或者activityW的宽 + 左右两边的内边距
        let backgroundViewWidth  = max(self.roundProgressView.intrinsicContentSize.width, size.width) + self.padding.left + self.padding.right
        
        // backgroundView的高 = 上内边距 + activityW(activity的高) + detaiLabel距离activity的大小 + 文字高度 + 底部内边距
        let backgroundViewHeight = self.padding.top + self.roundProgressView.intrinsicContentSize.height + tempTipsLabTopMargin + (tips.isEmpty ? 0.0 : size.height) + self.padding.bottom
        
        self.backgroundView.frame  = CGRect(x: 0, y: 0, width: backgroundViewWidth, height: backgroundViewHeight)
        self.backgroundView.center = CGPoint(x: self.center.x + self.offsetX, y: self.center.y + self.offsetY)
        
        self.roundProgressView.frame = CGRect(x: (backgroundViewWidth - self.roundProgressView.intrinsicContentSize.width) / 2.0,
                                              y: self.padding.top,
                                              width: self.roundProgressView.intrinsicContentSize.width,
                                              height: self.roundProgressView.intrinsicContentSize.height)
        
        // 提醒文字的frame
        self.detaiLabel.frame = CGRect(x: (backgroundViewWidth -  size.width) / 2.0, y: self.roundProgressView.frame.maxY + tempTipsLabTopMargin, width: size.width, height: size.height)
        self.detaiLabel.isHidden = tips.isEmpty
    }
    
    // MARK: 设置自定义视图模式下的布局
    private func setCustomViewLayout(_ customView: UIView) {
        assert(customView.bounds.size.width > 0 || customView.bounds.size.height > 0, "请设置自定义视图\(customView)的size")
        
        // 必须宽高有值
        if customView.bounds.size.width <= 0 || customView.bounds.size.height <= 0 {
            print("请正确的设置自定义视图\(customView)的size")
            return
        }
        
        // backgroundView的宽
        let backgroundViewWidth  = customView.bounds.size.width + self.padding.left + self.padding.right
        
        // backgroundView的高
        let backgroundViewHeight = self.padding.top + customView.bounds.size.height + self.padding.bottom
        
        self.backgroundView.frame  = CGRect(x: 0, y: 0, width: backgroundViewWidth, height: backgroundViewHeight)
        self.backgroundView.center = CGPoint(x: self.center.x + self.offsetX, y: self.center.y + self.offsetY)
        self.backgroundView.addSubview(customView)
        customView.center = CGPoint(x: self.backgroundView.frame.width / 2.0, y: self.backgroundView.frame.height / 2.0)
    }
}
