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

        self.hud.updateProgress(self.progressValue, des: "已下载：\n\(self.progressValue * 100.0) %")
        
        if self.progressValue >= 1.0 {
            self.progressValue = 0.0
            self.hud.hide()
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    @IBAction func btnClick(_ sender: UIButton) {
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerEvent), userInfo: nil, repeats: true)
        }
        self.progressHUD(self.view)
    }
    
    func progressHUD(_ sender: UIView) {
        self.hud = ZKLoadHUD.showHUD(.progress(.round), superView: sender)
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
        let hud = ZKLoadHUD.showHUD(.customView(sender), animation: .zoomIn)
        hud.activityIndicatorView.color = .red
        hud.detaiLabel.textColor = .red
        hud.backgroundView.backgroundColor = .gray
        hud.backgroundColor = .black.withAlphaComponent(0.35)
    }
}
