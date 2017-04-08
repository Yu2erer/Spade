//
//  SPHomeViewController.swift
//  spade
//
//  Created by ntian on 2017/4/6.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import Kingfisher

private let cellId = "cellId"

class SPHomeViewController: SPBaseViewController {
    
    /// 列表视图模型
    fileprivate lazy var dashBoardViewModel = SPDashBoardListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        SPNetworkManage.shared.blogInfo(blogName: "ntian.tumblr.com") { (json, isSuccess) in
            print(json)
        }

        
    }
    
    /// 加载数据
    override func loadData() {
        
        dashBoardViewModel.loadDashBoard(pullup: self.isPullup) { (isSuccess) in
            
            // 结束刷新控件
            self.refreshControl?.endRefreshing()
            // 恢复上拉刷新标记
            self.isPullup = false
            self.tableView?.reloadData()
        }
    }
    
    @objc fileprivate func test() {
        let vc = SPDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    
}

// MARK: - 表格数据源方法
extension SPHomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dashBoardViewModel.dashBoardList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SPHomeTableViewCell
        cell.statusLabel?.text = dashBoardViewModel.dashBoardList[indexPath.row].summary
        cell.nameLabel.text = dashBoardViewModel.dashBoardList[indexPath.row].blog_name
        
        
        return cell
    }
}
// MARK: - 设置界面
extension SPHomeViewController {
    
    fileprivate func setupUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "bar-button-camera", target: self, action: #selector(test))
    }
    override func setupTableView() {
        super.setupTableView()
        tableView?.register(UINib(nibName: "SPHomeTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 300
        
        tableView?.separatorStyle = .none
    }
}
