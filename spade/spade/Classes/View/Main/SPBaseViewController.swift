//
//  SPBaseViewController.swift
//  spade
//
//  Created by ntian on 2017/4/7.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class SPBaseViewController: UIViewController {
    
    /// 表格视图
    var tableView: UITableView?
    /// 刷新控件
    var refreshControl: UIRefreshControl?
    /// 上拉刷新标记
    var isPullup = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        loadData()
    }
    /// 具体实现子类负责
    func loadData() {
        self.refreshControl?.endRefreshing()
    }


}
// MARK: - 设置界面
extension SPBaseViewController {
    
    fileprivate func setupUI() {
        setupTableView()
    }
    func setupTableView() {
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView!)
        // 实现数据源方法
        tableView?.delegate = self
        tableView?.dataSource = self
        // 实例化 refreshControl
        refreshControl = UIRefreshControl()
        tableView?.addSubview(refreshControl!)
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
}
// MARK: - UITableViewDelegate, UITableViewDataSource
extension SPBaseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
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
            print("上拉刷新")
            isPullup = true
            loadData()
        }
    }
}
