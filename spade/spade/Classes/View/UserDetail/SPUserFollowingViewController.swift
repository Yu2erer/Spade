//
//  SPUserFollowingViewController.swift
//  spade
//
//  Created by ntian on 2017/4/29.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import ZFPlayer

private let photoCellId = "photoCellId"
private let videoCellId = "videoCellId"

class SPUserFollowingViewController: SPBaseViewController {

    fileprivate lazy var followingListViewModel = SPUserFollowingListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func loadData() {
        refreshControl?.beginRefreshing()
        followingListViewModel.loadFollowing(pullup: self.isPullup, pullupCount: self.pullupCount) { (list, shouldRefresh) in
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
        
        playerView?.stopPlayWhileCellNotVisable = true
        return playerView
    }()
    



}
// MARK: - 设置界面
extension SPUserFollowingViewController {
    fileprivate func setupUI() {
        navigationItem.title = "关注"
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
