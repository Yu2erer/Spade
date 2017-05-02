//
//  SPUserDetailViewController.swift
//  spade
//
//  Created by ntian on 2017/4/19.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import ZFPlayer

private let photoCellId = "photoCellId"
private let videoCellId = "videoCellId"

class SPUserDetailViewController: SPBaseViewController {

    fileprivate lazy var blogInfoViewModel = SPBlogInfoViewModel()
    fileprivate lazy var userListViewModel = SPUserListViewModel()
    fileprivate lazy var customNavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: PictureViewWidth, height: 64))
    fileprivate lazy var navItem = UINavigationItem()

    
    var user: SPDashBoard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func loadData() {
        blogInfoViewModel.loadBlogInfo(blogName: user?.post_url ?? "") { (isSuccess) in
            if !isSuccess {
                return
            }
            let blogName = self.blogInfoViewModel.blogInfo.name ?? "" + ".tumblr.com"
            self.headerView.model = self.blogInfoViewModel.blogInfo
            self.userListViewModel.loadBlogInfoList(blogName: blogName, pullup: self.isPullup, pullupCount: self.pullupCount, completion: { (isSuccess, shouldRefresh) in
                self.refreshControl?.endRefreshing()
                // 恢复上拉刷新标记
                self.isPullup = false
                if shouldRefresh {
                    self.tableView?.reloadData()
                }
            })

            
            self.headerView.model = self.blogInfoViewModel.blogInfo
        }
    }
    lazy var headerView: SPUserDetailHeaderView = {
        let headerView = UINib(nibName: "SPUserDetailHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SPUserDetailHeaderView
        headerView.frame = CGRect(x: 0, y: 0, width: PictureViewWidth, height: 95)
        headerView.headerViewDelegate = self
        return headerView
    }()
    lazy var playerView: ZFPlayerView? = {
        let playerView = ZFPlayerView.shared()
        
        return playerView
    }()
    
}
// MARK: - tableView
extension SPUserDetailViewController {
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
                weakSelf?.playerView?.stopPlayWhileCellNotVisable = !isSmallWindowOn
            }
        }
        return cell
    }
}
// MARK: - SPUserDetailHeaderViewDelegate
extension SPUserDetailViewController: SPUserDetailHeaderViewDelegate {
    func didClickPostNum() {
        tableView?.setContentOffset(CGPoint(x: 0, y: 37), animated: true)
    }
    func didClickLikeNum(user: SPBlogInfo) {
        let vc = SPUserLikesViewController()
        vc.model = user
        navigationController?.pushViewController(vc, animated: true)
    }
    func didClickAvatar() {
        guard var avatarUrl = blogInfoViewModel.blogInfo.avatarURL else {
            return
        }
        avatarUrl.removeSubrange(avatarUrl.index(avatarUrl.endIndex, offsetBy: -2)...avatarUrl.index(before: avatarUrl.endIndex))
        avatarUrl += "512"
        print(avatarUrl)
        var url = [String]()
        url.append(avatarUrl)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SPHomeCellBrowserPhotoNotification), object: self, userInfo: [SPHomeCellBrowserPhotoURLsKey: url,
                                                                                                                                          
                                                                                                                                          SPHomeCellBrowserPhotoSelectedIndexKey: 0])
    }

}
// MARK: - 设置界面
extension SPUserDetailViewController {
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        customNavigationBar.setBackgroundImage(UIImage(), for: .default)
        customNavigationBar.shadowImage = UIImage()
        navItem.leftBarButtonItem = UIBarButtonItem(target: self, action: #selector(popToParent))
        customNavigationBar.items = [navItem]
    }
    /// POP 返回到上一级 控制器
    @objc fileprivate func popToParent() {
        navigationController?.popViewController(animated: true)
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
    /// 处理导航栏
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        if offsetY >= 0 && offsetY <= 36 {
            let image = UIImage().imageWithColor(color: UIColor(white: 1, alpha: offsetY / 36))
            customNavigationBar.setBackgroundImage(image, for: .default)
            navItem.title = nil
        } else if offsetY > 36 {
            let image = UIImage().imageWithColor(color: UIColor(white: 1, alpha: 1))
            customNavigationBar.setBackgroundImage(image, for: .default)
            navItem.title = self.user?.blog_name
        }
    }
}
