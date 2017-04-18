//
//  SPProfileViewController.swift
//  spade
//
//  Created by ntian on 2017/4/17.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import ZFPlayer

private let photoCellId = "photoCellId"
private let videoCellId = "videoCellId"

class SPProfileViewController: SPBaseViewController {

    fileprivate lazy var blogInfoViewModel = SPBlogInfoViewModel()
    fileprivate lazy var userListViewModel = SPUserListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func loadData() {
        blogInfoViewModel.loadBlogInfo { (isSuccess) in
            if (!isSuccess) { return }
            let blogName = self.blogInfoViewModel.blogInfo[0].name ?? "" + ".tumblr.com"
            self.userListViewModel.loadUserList(blogName: blogName, pullup: self.isPullup, pullupCount: self.pullupCount) { (isSuccess, shouldRefresh) in
                self.refreshControl?.endRefreshing()
                // 恢复上拉刷新标记
                self.isPullup = false
                if shouldRefresh {
                    self.tableView?.reloadData()
                }
            }
        }
    }
    lazy var headerView: SPProfileHeaderView = {
        let headerView = UINib(nibName: "SPProfileHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SPProfileHeaderView
        headerView.frame = CGRect(x: 0, y: 0, width: PictureViewWidth, height: 100)
        return headerView
    }()
    lazy var playerView: ZFPlayerView? = {
        let playerView = ZFPlayerView.shared()
        
        playerView?.stopPlayWhileCellNotVisable = true
        return playerView
    }()

    


}
// MARK: - tableView
extension SPProfileViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userListViewModel.userViewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        self.navigationItem.title = self.blogInfoViewModel.blogInfo[0].name
        headerView.model = blogInfoViewModel.blogInfo[0]
        
        let vm = userListViewModel.userViewModel[indexPath.row]
        
        let cellId = (vm.dashBoard.type == "video") ? videoCellId : photoCellId
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SPHomeTableViewCell
        weak var weakSelf = self
        cell.viewModel = vm
        
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
// MARK: - 设置界面
extension SPProfileViewController {
    
    override func setupTableView() {
        super.setupTableView()
        
        tableView?.register(UINib(nibName: "SPHomeTableViewCell", bundle: nil), forCellReuseIdentifier: photoCellId)
        tableView?.register(UINib(nibName: "SPHomeVideoTableViewCell", bundle: nil), forCellReuseIdentifier: videoCellId)
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 300
        tableView?.tableHeaderView = headerView
        tableView?.separatorStyle = .none
    }
}
