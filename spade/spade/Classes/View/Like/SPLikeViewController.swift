//
//  SPLikeViewController.swift
//  spade
//
//  Created by ntian on 2017/4/21.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import ZFPlayer

private let photoCellId = "photoCellId"
private let videoCellId = "videoCellId"

class SPLikeViewController: SPBaseViewController {

    fileprivate lazy var likeListViewModel = SPUserLikeListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func loadData() {
        refreshControl?.beginRefreshing()
        likeListViewModel.loadUserLikes(pullup: self.isPullup) { (isSuccess, shouldRefresh) in
            self.refreshControl?.endRefreshing()
            self.isPullup = false
            if !isSuccess {
                NTMessageHud.showMessage(targetView: self.view, message: NSLocalizedString("RefreshFeedError", comment: "加载失败"), isError: true)
                return
            }
            if shouldRefresh {
                self.tableView?.reloadData()
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        playerView?.resetPlayer()
    }
    lazy var playerView: ZFPlayerView? = {
        let playerView = ZFPlayerView.shared()
        return playerView
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }


}
// MARK: - 表格数据源方法
extension SPLikeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return likeListViewModel.userLikeModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let vm = likeListViewModel.userLikeModel[indexPath.row]
        
        let cellId = (vm.dashBoard.type == "video") ? videoCellId : photoCellId
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SPHomeTableViewCell
        weak var weakSelf = self
        cell.viewModel = vm
        cell.cellDelegate = self
        
        if vm.dashBoard.type == "video" {
            cell.playBack = {
                
                let playerModel = ZFPlayerModel()
                playerModel.videoURL = URL(string: vm.dashBoard.video_url ?? "https://127.0.0.1")
                playerModel.placeholderImageURLString = vm.dashBoard.thumbnail_url ?? ""
                playerModel.indexPath = indexPath
                playerModel.tableView = tableView
                playerModel.fatherView = cell.placeholderImage
                weakSelf?.playerView?.playerModel(playerModel)
                weakSelf?.playerView?.autoPlayTheVideo()
                weakSelf?.playerView?.stopPlayWhileCellNotVisable = !isSmallWindowOn
                UIApplication.shared.statusBarStyle = .default
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let vm = likeListViewModel.userLikeModel[indexPath.row]
        return vm.rowHeight
    }
}
// MARK: - SPHomeTableViewCellDelegate
extension SPLikeViewController: SPHomeTableViewCellDelegate {
    func didClickUser(name: String) {
        let vc = SPUserDetailViewController()
        vc.name = name
        navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - 设置界面
extension SPLikeViewController {
    fileprivate func setupUI() {
        self.navigationItem.title = NSLocalizedString("Like", comment: "喜欢")
    }
    override func setupTableView() {
        super.setupTableView()
        
        tableView?.register(UINib(nibName: "SPHomeTableViewCell", bundle: nil), forCellReuseIdentifier: photoCellId)
        tableView?.register(UINib(nibName: "SPHomeVideoTableViewCell", bundle: nil), forCellReuseIdentifier: videoCellId)
        
//        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 300
        
        tableView?.separatorStyle = .none
    }
}
