//
//  LXTLoadHUDRoundProgressView.swift
//  LXTLoadHUD
//
//  Created by 洪绵卫 on 2022/5/10.
//

import Foundation
import UIKit

open class LXTLoadHUDRoundProgressView: UIView {

    /// 指示器的类型
    public enum ProgressLayerMode {
        /// 圆形
        case round
        /// 环形
        case annular
    }

    // MARK: 公共属性
    /// 当前进度
    /// 默认： 0.0
    public var progress: Float = 0.0 {
        didSet {
            guard self.progress != oldValue else { return }
            self.setNeedsDisplay()
        }
    }
    
    /// 指示器进度颜色
    /// 默认： 白色 .white
    public var progressTintColor: UIColor = .white {
        didSet {
            guard self.progressTintColor != oldValue else { return }
            self.setNeedsDisplay()
        }
    }
    
    /// 指示器背景色(非进度)
    /// 默认：白色 透明度 0.1
    public var backgroundTintColor: UIColor = .white.withAlphaComponent(0.1) {
        didSet {
            guard self.backgroundTintColor != oldValue else { return }
            self.setNeedsDisplay()
        }
    }
    
    /// 指示器的类型
    /// 默认为圆形
    public var mode: ProgressLayerMode = .round
    
    // MARK: 公共方法
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.isOpaque = false
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// 固定内容尺寸
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: 37.0, height: 37.0)
    }
    
    open override func draw(_ rect: CGRect) {

        switch self.mode {
        case .round:
            guard let context = UIGraphicsGetCurrentContext() else {
                return super.draw(rect)
            }
            // 画背景
            let lineWidth = 2.0
            let allRect = self.bounds
            let circleRect = allRect.insetBy(dx: lineWidth / 2.0, dy: lineWidth / 2.0)
            let center = CGPoint(x: self.bounds.width/2.0, y: self.bounds.height / 2.0)
            self.progressTintColor.setStroke()
            self.backgroundTintColor.setFill()
            context.setLineWidth(lineWidth)
            context.strokeEllipse(in: circleRect)
            
            // 画进度
            let startAngle = -(CGFloat.pi / 2.0)
            let processPath = UIBezierPath()
            processPath.lineCapStyle = .butt
            processPath.lineWidth  = lineWidth * 2.0
            let radius = (self.bounds.width - processPath.lineWidth) / 2.0
            let endAngle = CGFloat(self.progress * 2.0 * Float.pi) + startAngle
            
            processPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            
            context.setBlendMode(.copy)
            self.progressTintColor.set()
            processPath.stroke()
            
        case .annular:
            // 画背景
            let lineWidth = 2.0
            let processBackgroundPath = UIBezierPath()
            processBackgroundPath.lineWidth = lineWidth
            processBackgroundPath.lineCapStyle = .butt
            let center = CGPoint(x: self.bounds.width/2.0, y: self.bounds.height / 2.0)
            let radius = (self.bounds.width - lineWidth) / 2.0
            let startAngle = -(CGFloat.pi / 2.0)
            var endAngle = (2.0 * CGFloat.pi) + startAngle
            processBackgroundPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            self.backgroundTintColor.set()
            processBackgroundPath.stroke()
            
            // 画进度
            let processPath = UIBezierPath()
            processPath.lineWidth = lineWidth
            processPath.lineCapStyle = .square
            endAngle = CGFloat((self.progress * 2.0 * Float.pi)) + startAngle
            processPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            self.progressTintColor.set()
            processPath.stroke()
        }
    }
}
