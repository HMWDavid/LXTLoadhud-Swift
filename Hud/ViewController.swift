//
//  ViewController.swift
//  Hud
//
//  Created by zk_01 on 2022/5/9.
//

import UIKit

struct Model {
    var title: String
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
        cell.textLabel?.text = self.dataSource[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.dataSource[indexPath.row]
        self.selectedModel = model
        self.hud = ZKLoadHUD.showHUD(model.hudType, superView: model.superView, animation: .fade)
        self.hud.minShowTime = .seconds(3)
        switch self.hud.mode {
        case .progress:
            if self.timer == nil {
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerEvent), userInfo: nil, repeats: true)
            }
        default:
            break
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
        
        self.dataSource = [Model(title: "activity 不带文字", hudType: .activity("")),
         Model(title: "activity 带文字", hudType: .activity("loadding...")),
         Model(title: "activity 添加到指定View", hudType: .activity("loadding..."), superView: self.headerView),
         Model(title: "customView 自定义视图", hudType: .customView(customView)),
         Model(title: "customView 自定义视图 添加到指定View", hudType: .customView(customView), superView: self.headerView),
         Model(title: "progress 环形进度", hudType: .progress(ZKLoadHUDRoundProgressView.ProgressLayerMode.annular)),
         Model(title: "progress 环形进度 带文字", hudType: .progress(ZKLoadHUDRoundProgressView.ProgressLayerMode.annular), progressModeTipsTextEnabel: true),
         Model(title: "progress 圆形进度", hudType: .progress(ZKLoadHUDRoundProgressView.ProgressLayerMode.round)),
         Model(title: "progress 圆形进度 带文字", hudType: .progress(ZKLoadHUDRoundProgressView.ProgressLayerMode.round), progressModeTipsTextEnabel: true),
         Model(title: "progress 添加到指定View", hudType: .progress(ZKLoadHUDRoundProgressView.ProgressLayerMode.annular), superView: self.headerView)
        ]
    }
}
