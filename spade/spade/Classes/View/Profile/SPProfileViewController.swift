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
        setupUI()
    }
    override func loadData() {
        blogInfoViewModel.loadBlogInfo(blogName: nil) { (isSuccess) in
            if (!isSuccess) { return }
            let blogName = self.blogInfoViewModel.blogInfo.name ?? "" + ".tumblr.com"
            self.headerView.model = self.blogInfoViewModel.blogInfo
            self.userListViewModel.loadBlogInfoList(blogName: blogName, pullup: self.isPullup, pullupCount: self.pullupCount) { (isSuccess, shouldRefresh) in
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
        headerView.frame = CGRect(x: 0, y: 0, width: PictureViewWidth, height: 95)
        headerView.headerViewDelegate = self
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
// MARK: - SPProfileHeaderViewDelegate
extension SPProfileViewController: SPProfileHeaderViewDelegate {
    func didClickPostNum() {
        tableView?.setContentOffset(CGPoint(x: 0, y: 35), animated: true)
    }
}
// MARK: - 设置界面
extension SPProfileViewController {
    
    fileprivate func setupUI() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    override func setupTableView() {
        super.setupTableView()
        
        tableView?.register(UINib(nibName: "SPHomeTableViewCell", bundle: nil), forCellReuseIdentifier: photoCellId)
        tableView?.register(UINib(nibName: "SPHomeVideoTableViewCell", bundle: nil), forCellReuseIdentifier: videoCellId)
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 300
        tableView?.tableHeaderView = headerView
        tableView?.separatorStyle = .none
    }
    /// 处理导航栏
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        if offsetY >= 0 && offsetY <= 36 {
            let image = UIImage().imageWithColor(color: UIColor(white: 1, alpha: offsetY / 36))
            navigationController?.navigationBar.setBackgroundImage(image, for: .default)
            self.navigationItem.title = nil
        } else if offsetY > 36 {
            let image = UIImage().imageWithColor(color: UIColor(white: 1, alpha: 1))
            navigationController?.navigationBar.setBackgroundImage(image, for: .default)
            self.navigationItem.title = self.blogInfoViewModel.blogInfo.name
        }
    }

}
