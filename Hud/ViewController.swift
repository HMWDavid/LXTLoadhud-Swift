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
        let hud = ZKLoadHUD.showHUD(.activity("是奥数阿斯顿发打"))

      
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            hud.hide()
//        }
    }
}
