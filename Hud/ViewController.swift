//
//  ViewController.swift
//  Hud
//
//  Created by zk_01 on 2022/5/9.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnClick(_ sender: UIButton) {
        let hud = ZKLoadHUD.showHUD(.activity("是奥数阿斯顿发打发斯蒂芬阿斯顿发送到发阿斯蒂芬阿斯蒂芬阿斯蒂芬阿斯顿发送到发斯蒂芬二哥和东方国际于今日退回电饭锅发挥人大嘎多舒服按规定改"))

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            hud.hide()
        }
    }
}
