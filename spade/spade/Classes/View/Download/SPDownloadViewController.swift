//
//  SPDownloadViewController.swift
//  spade
//
//  Created by ntian on 2017/5/11.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import ZFPlayer
private let downedCellId = "downedCellId"
class SPDownloadViewController: UIViewController {
    
    fileprivate lazy var downedTableView: UITableView = UITableView()
    fileprivate lazy var downed = [NTDownloadTask]()
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
        downedTableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initData()
    }

    @objc fileprivate func loadDowningView() {
    }
    

}
// MARK: - UITableViewDelegate, UITableViewDataSource
extension SPDownloadViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return downed.count
        } else {
            return 0
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
            return UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
    }

}
// MARK: - NTDownloadDelegate
extension SPDownloadViewController: NTDownloadDelegate {
    func finishedDownload() {
        initData()
        
    }
}
// MARK: - 设置界面
extension SPDownloadViewController {
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.title = "离线视频"
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "队列", style: .plain, target: self, action: #selector(loadDowningView))
        downedTableView = UITableView(frame: view.bounds, style: .plain)
        downedTableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 49, right: 0)
        downedTableView.tag = 0
        downedTableView.separatorStyle = .none
        downedTableView.dataSource = self
        downedTableView.delegate = self
        downedTableView.register(UINib(nibName: "SPDownloadedViewCell", bundle: nil), forCellReuseIdentifier: downedCellId)
        downedTableView.rowHeight = 190
        view.addSubview(downedTableView)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if tableView.tag == 0 {
            NTDownloadManager.shared.deleteTask(fileInfo: downed[indexPath.row])
            initData()
        }
    }
 
}
