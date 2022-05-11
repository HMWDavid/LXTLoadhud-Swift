//
//  ViewController.swift
//  Hud
//
//  Created by zk_01 on 2022/5/9.
//

import UIKit

enum ModelType: String {
    /// activity 不带文字
    case activity1      = "activity 不带文字"
    /// activity 带文字
    case activity2      = "activity 带文字"
    /// activity 添加到指定View
    case activity3      = "activity 添加到指定View"
    /// customView 自定义视图
    case customView1    = "customView 自定义视图"
    /// customView 自定义视图 添加到指定View
    case customView2    = "customView 自定义视图 添加到指定View"
    /// progress 环形进度
    case progress1      = "progress 环形进度"
    /// progress 环形进度 带文字
    case progress2      = "progress 环形进度 带文字"
    /// progress 圆形进度
    case progress3      = "progress 圆形进度"
    /// progress 圆形进度 带文字
    case progress4      = "progress 圆形进度 带文字"
    /// progress 添加到指定View
    case progress5      = "progress 添加到指定View"
}

struct Model {
    var type: ModelType
    var hudType: ZKLoadHUDMode
    var superView: UIView?
    var progressModeTipsTextEnabel: Bool = false
}

class ViewController: UIViewController {

    var hud: ZKLoadHUD!
    var timer: Timer?

    var progressValue: Float = 0.0
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource =  [Model]()
    
    var selectedModel: Model?
    
    lazy var headerView: UIImageView = {
        let headerView = UIImageView()
        headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200.0)
        headerView.image = UIImage(named: "portraitImage.jpg")
        return headerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.datas()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
       
        self.tableView.tableHeaderView = self.headerView
    }
    
    @objc func timerEvent() {
        self.progressValue += 0.1

        self.hud.updateProgress(self.progressValue, des: self.selectedModel?.progressModeTipsTextEnabel ?? false ? "已下载：\n\(self.progressValue * 100.0) %" : "")
        
        if self.progressValue >= 1.0 {
            self.progressValue = 0.0
            self.hud.hide()
            self.timer?.invalidate()
            self.timer = nil
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        cell.textLabel?.text = self.dataSource[indexPath.row].type.rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.dataSource[indexPath.row]
        self.selectedModel = model
        self.hud = ZKLoadHUD.hud(model.hudType, superView: model.superView)
        self.hud.show(.zoomIn)
        // 允许用户交互
        self.hud.isUserInteractionEnabled = false
        switch self.hud.mode {
        case .progress:
            if self.timer == nil {
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerEvent), userInfo: nil, repeats: true)
            }
        default:
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                ZKLoadHUD.hide(for: model.superView ?? ZKLoadHUD.getWindow()!, .zoomOut)
            }
        }
    }
}

extension ViewController {
    func datas() {

        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        customView.backgroundColor = .red
        let imgV = UIImageView()
        imgV.image = UIImage(named: "portraitImage.jpg")
        imgV.frame = CGRect(x: 5, y: 5, width: 40, height: 40)
        customView.addSubview(imgV)
        
        let customView2 = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        customView2.backgroundColor = .green
        let imgV2 = UIImageView()
        imgV2.image = UIImage(named: "portraitImage.jpg")
        imgV2.frame = CGRect(x: 7.5, y: 7.5, width: 35, height: 35)
        customView2.addSubview(imgV2)
        
        self.dataSource = [Model(type: .activity1, hudType: .activity("")),
                           Model(type: .activity2, hudType: .activity("loadding...")),
                           Model(type: .activity3, hudType: .activity("loadding..."), superView: self.headerView),
                           Model(type: .customView1, hudType: .customView(customView)),
                           Model(type: .customView2, hudType: .customView(customView2), superView: self.headerView),
                           Model(type: .progress1, hudType: .progress(ZKLoadHUDRoundProgressView.ProgressLayerMode.annular)),
                           Model(type: .progress2, hudType: .progress(ZKLoadHUDRoundProgressView.ProgressLayerMode.annular), progressModeTipsTextEnabel: true),
                           Model(type: .progress3, hudType: .progress(ZKLoadHUDRoundProgressView.ProgressLayerMode.round)),
                           Model(type: .progress4, hudType: .progress(ZKLoadHUDRoundProgressView.ProgressLayerMode.round), progressModeTipsTextEnabel: true),
                           Model(type: .progress5, hudType: .progress(ZKLoadHUDRoundProgressView.ProgressLayerMode.annular), superView: self.headerView)
        ]
    }
}
