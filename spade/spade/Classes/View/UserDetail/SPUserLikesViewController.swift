//
//  SPUserLikesViewController.swift
//  spade
//
//  Created by ntian on 2017/4/22.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import ZFPlayer

private let photoCellId = "photoCellId"
private let videoCellId = "videoCellId"

class SPUserLikesViewController: SPBaseViewController {
    
    fileprivate lazy var likeListViewModel = SPLikeListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    var model: SPBlogInfo?
    
    override func loadData() {
        refreshControl?.beginRefreshing()
        likeListViewModel.loadBlogLikes(blogName: model?.name ?? "" + ".tumblr.com", pullup: self.isPullup, pullupCount: self.pullupCount) { (list, shouldRefresh) in
            self.refreshControl?.endRefreshing()
            // 恢复上拉刷新标记
            self.isPullup = false
            if shouldRefresh {
                self.tableView?.reloadData()
            }
        }
    }
    lazy var playerView: ZFPlayerView? = {
        let playerView = ZFPlayerView.shared()
        
        return playerView
    }()
    
    
}
// MARK: - 表格数据源方法
extension SPUserLikesViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return likeListViewModel.likeModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let vm = likeListViewModel.likeModel[indexPath.row]
        
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
                weakSelf?.playerView?.stopPlayWhileCellNotVisable = !isSmallWindowOn
            }
        }
        return cell
    }
}
// MARK: - SPHomeTableViewCellDelegate
extension SPUserLikesViewController: SPHomeTableViewCellDelegate {
    func didClickUser(user: SPDashBoard) {
        print(user)
        let vc = SPUserDetailViewController()
        vc.user = user
        navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - 设置界面
extension SPUserLikesViewController {
    fileprivate func setupUI() {
        navigationItem.title = "喜欢"
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

