//
//  SPDownloadViewController.swift
//  spade
//
//  Created by ntian on 2017/5/11.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import ZFPlayer
import Popover

private let downedCellId = "downedCellId"
private let downingCellId = "downingCellId"
class SPDownloadViewController: UIViewController {
    
    fileprivate lazy var downedTableView: UITableView = UITableView()
    fileprivate lazy var downingTableView: UITableView = UITableView()
    fileprivate lazy var downed = [NTDownloadTask]()
    fileprivate lazy var downing = [NTDownloadTask]()
    fileprivate var popover: Popover!
    fileprivate var popoverOptions: [PopoverOption] = [
        .type(.down),
        .blackOverlayColor(UIColor(white: 0.0, alpha: 0.6))
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        NTDownloadManager.shared.downloadDelegate = self
        initData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        playerView?.resetPlayer()
    }
    lazy var playerView: ZFPlayerView? = {
        let playerView = ZFPlayerView.shared()
        return playerView
    }()
    fileprivate func initData() {
        self.downed = NTDownloadManager.shared.finishedList()
        self.downing = NTDownloadManager.shared.unFinishedList()
        downedTableView.reloadData()
        downingTableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initData()
    }
    @objc fileprivate func loadDowningView() {
        self.popover = Popover(options: self.popoverOptions)
        if downing.count == 0 {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: PictureViewWidth * 0.4, height: 42))
            label.font = UIFont.systemFont(ofSize: 13)
            label.text = "没有下载任务"
            label.textAlignment = .center
            self.popover.show(label, point: CGPoint(x: self.view.frame.width - 33, y: 55))
        } else {
            downingTableView.frame = CGRect(x: 0, y: 0, width: PictureViewWidth * 0.4, height: CGFloat(42 * downing.count))
            self.popover.show(downingTableView, point: CGPoint(x: self.view.frame.width - 33, y: 55))
        }
    }
}
// MARK: - UITableViewDelegate, UITableViewDataSource
extension SPDownloadViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return downed.count
        } else {
            return downing.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: downedCellId, for: indexPath) as! SPDownloadedViewCell
            let fileInfo = downed[indexPath.row]
            weak var weakSelf = self
            cell.imageString = fileInfo.fileImage
            cell.playBack = {
                let playerModel = ZFPlayerModel()
                var path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
                path = "\(path)/\(fileInfo.name)"
                playerModel.videoURL = URL(fileURLWithPath: path)
                playerModel.indexPath = indexPath
                playerModel.tableView = tableView
                playerModel.fatherView = cell.fileImage
                weakSelf?.playerView?.playerModel(playerModel)
                weakSelf?.playerView?.autoPlayTheVideo()
                weakSelf?.playerView?.stopPlayWhileCellNotVisable = true
                UIApplication.shared.statusBarStyle = .default
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: downingCellId, for: indexPath) as! SPDownloadingViewCell
            cell.fileInfo = downing[indexPath.row]
            return cell
        }
    }

}
// MARK: - NTDownloadDelegate
extension SPDownloadViewController: NTDownloadDelegate {
    func finishedDownload() {
        self.popover.dismiss()
        initData()
    }
    func updateCellProgress(model: NTDownloadTask) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateProgress"), object: nil, userInfo: ["downloadModel": model])
    }
}
// MARK: - 设置界面
extension SPDownloadViewController {
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.title = "离线视频"
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "button-download", target: self, action: #selector(loadDowningView))
        downedTableView = UITableView(frame: view.bounds, style: .plain)
        downingTableView = UITableView(frame: CGRect(x: 0, y: 0, width: PictureViewWidth * 0.4, height: UIScreen.main.bounds.height / 3), style: .plain)
        downedTableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 49, right: 0)
        downedTableView.tag = 0
        downingTableView.tag = 1
        downedTableView.separatorStyle = .none
        downingTableView.separatorStyle = .none
        downedTableView.dataSource = self
        downingTableView.dataSource = self
        downedTableView.delegate = self
        downingTableView.delegate = self
        downedTableView.register(UINib(nibName: "SPDownloadedViewCell", bundle: nil), forCellReuseIdentifier: downedCellId)
        downingTableView.register(UINib(nibName: "SPDownloadingViewCell", bundle: nil), forCellReuseIdentifier: downingCellId)
        downedTableView.rowHeight = 190
        downingTableView.rowHeight = 40
        view.addSubview(downedTableView)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if tableView.tag == 0 {
            NTDownloadManager.shared.deleteTask(fileInfo: downed[indexPath.row])
            initData()
        }
    }
 
}
