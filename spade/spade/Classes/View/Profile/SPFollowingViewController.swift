//
//  SPFollowingViewController.swift
//  spade
//
//  Created by ntian on 2017/5/3.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import SVProgressHUD

private let followingCell = "followingCell"

class SPFollowingViewController: UIViewController {

    fileprivate lazy var followingListViewModel = SPUserFollowingListViewModel()
    /// 上拉刷新标记
    fileprivate var isPullup = false
    fileprivate var tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    fileprivate func loadData() {
        followingListViewModel.loadFollowing(pullup: isPullup) { (isSuccess, shouldRefresh) in
            // 恢复上拉刷新标记
            self.isPullup = false
            SVProgressHUD.dismiss()
            if !isSuccess {
                NTMessageHud.showMessage(targetView: self.view, message: NSLocalizedString("RefreshFeedError", comment: "加载失败"), isError: true)
                return
            }
            if shouldRefresh {
                self.tableView.reloadData()
            }
        }
    }
}
// MARK: - SPFollowingTableViewCellDelegate
extension SPFollowingViewController: SPFollowingTableViewCellDelegate {
    func didClickUser(name: String) {
        let vc = SPUserDetailViewController()
        vc.name = name
        navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - UITableViewDelegate, UITableViewDataSource
extension SPFollowingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = followingListViewModel.followingModel[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: followingCell, for: indexPath) as! SPFollowingTableViewCell
        cell.model = vm
        cell.cellDelegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followingListViewModel.followingModel.count
    }
    // 到最后一行 上拉刷新
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        let section = tableView.numberOfSections - 1
        
        if row < 0 || section < 0 {
            return
        }
        let count = tableView.numberOfRows(inSection: section)
        
        if row == (count - 1) && !isPullup {
            isPullup = true
            loadData()
        }
    }
}
// MARK: - 设置界面
extension SPFollowingViewController {
    fileprivate func setupUI() {
        self.title = NSLocalizedString("Following", comment: "关注")
        view.backgroundColor = UIColor.white
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(UINib(nibName: "SPFollowingTableViewCell", bundle: nil), forCellReuseIdentifier: followingCell)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 56
        view.addSubview(tableView)
        SVProgressHUD.show()
    }
}
