//
//  ViewController.swift
//  Hud
//
//  Created by zk_01 on 2022/5/9.
//

import UIKit

class ViewController: UIViewController {

    var hud: ZKLoadHUD!
    var timer: Timer?

    var progressValue: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @objc func timerEvent() {
        self.progressValue += 0.1
        self.hud.updateProgress(self.progressValue)
        
        if self.progressValue >= 1.1 {
            self.progressValue = 0.0
            self.hud.hide()
            self.timer?.invalidate()
        }
    }
    
    @IBAction func btnClick(_ sender: UIButton) {
//        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerEvent), userInfo: nil, repeats: true)
        let customV = UIView()
        customV.backgroundColor = .red
        customV.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        self.customViewHUD(customV)
    }
    
    func progressHUD(_ sender: UIView) {
        self.hud = ZKLoadHUD.showHUD(.progress(.round, ""), sender)
    }
    
    func activityHUD(_ sender: UIView) {
        let hud = ZKLoadHUD.showHUD(.activity(""))

        hud.activityIndicatorView.color = .red
        hud.detaiLabel.textColor = .red
        hud.backgroundView.backgroundColor = .gray
        hud.backgroundColor = .black.withAlphaComponent(0.35)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            hud.hide()
        }
    }
    
    func customViewHUD(_ sender: UIView) {
        let hud = ZKLoadHUD.showHUD(.customView(sender))

        hud.activityIndicatorView.color = .red
        hud.detaiLabel.textColor = .red
        hud.backgroundView.backgroundColor = .gray
        hud.backgroundColor = .black.withAlphaComponent(0.35)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            hud.hide()
        }
    }
}
