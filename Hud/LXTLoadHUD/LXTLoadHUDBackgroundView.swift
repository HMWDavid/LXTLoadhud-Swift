//
//  LXTLoadHUDBackgroundView.swift
//  LXTLoadHUD
//
//  Created by 洪绵卫 on 2022/5/10.
//

import Foundation
import UIKit

// MARK: LXTBackgroundView 背景视图
open class LXTLoadHUDBackgroundView: UIView {

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
