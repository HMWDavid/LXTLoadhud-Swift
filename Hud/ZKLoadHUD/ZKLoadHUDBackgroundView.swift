//
//  ZKLoadHUDBackgroundView.swift
//  ZKLoadHUD
//
//  Created by zk_01 on 2022/5/10.
//

import Foundation
import UIKit

// MARK: ZKBackgroundView 背景视图
open class ZKLoadHUDBackgroundView: UIView {

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
