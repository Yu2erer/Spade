//
//  SPHomeViewController.swift
//  spade
//
//  Created by ntian on 2017/4/6.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import ZFPlayer

private let photoCellId = "photoCellId"
private let videoCellId = "videoCellId"

class SPHomeViewController: SPBaseViewController {
    
    /// 列表视图模型
    fileprivate lazy var dashBoardListViewModel = SPDashBoardListViewModel()
    fileprivate lazy var messageHud: NTMessageHud = NTMessageHud()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

    }
    /// 加载数据
    override func loadData() {
        self.refreshControl?.beginRefreshing()
        self.dashBoardListViewModel.loadDashBoard(pullup: self.isPullup,pullupCount: self.pullupCount) { (isSuccess, shouldRefresh) in
            if !isSuccess {
                self.messageHud.showMessage(view: self.view, msg: "加载失败", isError: true)
                self.refreshControl?.endRefreshing()
                self.isPullup = false
                return
            }
            // 结束刷新控件
            self.refreshControl?.endRefreshing()
            // 恢复上拉刷新标记
            self.isPullup = false
            if shouldRefresh {
                self.tableView?.reloadData()
            }
        }
    }
    
    @objc fileprivate func test() {
        let vc = SPDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    lazy var playerView: ZFPlayerView? = {
        let playerView = ZFPlayerView.shared()
        
        playerView?.stopPlayWhileCellNotVisable = true
        return playerView
    }()
    

}

// MARK: - 表格数据源方法
extension SPHomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dashBoardListViewModel.dashBoardList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let vm = dashBoardListViewModel.dashBoardList[indexPath.row]

        let cellId = (vm.dashBoard.type == "video") ? videoCellId : photoCellId
  
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SPHomeTableViewCell
        weak var weakSelf = self
        cell.viewModel = vm
        cell.cellDelegate = self
        
        if vm.dashBoard.type == "video" {
            cell.playBack = {
                
                let playerModel = ZFPlayerModel()
                playerModel.videoURL = URL(string: vm.dashBoard.video_url ?? "")
                playerModel.placeholderImageURLString = vm.dashBoard.thumbnail_url
                playerModel.indexPath = indexPath
                playerModel.tableView = tableView
                playerModel.fatherView = cell.placeholderImage
                weakSelf?.playerView?.playerModel(playerModel)
                weakSelf?.playerView?.autoPlayTheVideo()
            }
        }
        return cell
    }
}
// MARK: - SPHomeTableViewCellDelegate
extension SPHomeViewController: SPHomeTableViewCellDelegate {
    func didClickUser(user: SPDashBoard) {
        let vc = SPUserDetailViewController()
        vc.user = user
        navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - 设置界面
extension SPHomeViewController {
    
    fileprivate func setupUI() {
//        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "bar-button-camera", target: self, action: #selector(test))
        self.navigationItem.title = "Spade"
    }

  
    override func setupTableView() {
        super.setupTableView()

        tableView?.register(UINib(nibName: "SPHomeTableViewCell", bundle: nil), forCellReuseIdentifier: photoCellId)
        tableView?.register(UINib(nibName: "SPHomeVideoTableViewCell", bundle: nil), forCellReuseIdentifier: videoCellId)

        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 300
        
        tableView?.separatorStyle = .none
    }
}
