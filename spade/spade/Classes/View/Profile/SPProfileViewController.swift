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
    fileprivate lazy var customNavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: PictureViewWidth, height: 64))
    fileprivate lazy var navItem = UINavigationItem()
    fileprivate lazy var messageHud: NTMessageHud = NTMessageHud()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func loadData() {
        refreshControl?.beginRefreshing()
        blogInfoViewModel.loadBlogInfo(blogName: nil) { (isSuccess) in
            if (!isSuccess) {
                self.messageHud.showMessage(view: self.view, msg: "加载失败", isError: true)
                self.refreshControl?.endRefreshing()
                self.isPullup = false
                return
            }
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
    @objc fileprivate func setting() {
        let vc = UIStoryboard(name: "SPSetting", bundle: nil).instantiateInitialViewController()!
        navigationController?.pushViewController(vc, animated: true)
    }
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
        tableView?.setContentOffset(CGPoint(x: 0, y: 37), animated: true)
    }
    func didClickFollowingNum() {
        let vc = SPUserFollowingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - 设置界面
extension SPProfileViewController {
    
    fileprivate func setupUI() {
        customNavigationBar.setBackgroundImage(UIImage(), for: .default)
        customNavigationBar.shadowImage = UIImage()
        customNavigationBar.items = [navItem]
        navItem.rightBarButtonItem = UIBarButtonItem(imageName: "SettingsBarButton", target: self, action: #selector(setting))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.view.insertSubview(customNavigationBar, at: 1)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        customNavigationBar.removeFromSuperview()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        performSelector(onMainThread: #selector(delayHidden), with: animated, waitUntilDone: false)
    }
    func delayHidden(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
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
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        if offsetY >= 0 && offsetY <= 36 {
            let image = UIImage().imageWithColor(color: UIColor(white: 1, alpha: offsetY / 36))
            customNavigationBar.setBackgroundImage(image, for: .default)
            navItem.title = nil
        } else if offsetY > 36 {
            let image = UIImage().imageWithColor(color: UIColor(white: 1, alpha: 1))
            customNavigationBar.setBackgroundImage(image, for: .default)
            navItem.title = self.blogInfoViewModel.blogInfo.name
        }
    }
}
