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
    var refreshControl: NTRefreshControl?
    /// 上拉刷新标记
    var isPullup = false
    var pullupCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name(rawValue: SPUserLoginSuccessedNotification), object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc fileprivate func loginSuccess() {
        setupUI()
    }
    /// 具体实现子类负责
    func loadData() {
        self.refreshControl?.endRefreshing()
    }


}
// MARK: - 设置界面
extension SPBaseViewController {
    
    fileprivate func setupUI() {
        SPNetworkManage.shared.userLogon ? setupTableView() : ()
        SPNetworkManage.shared.userLogon ? loadData() : ()
    }
    func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView!)
        // 实现数据源方法
        tableView?.delegate = self
        tableView?.dataSource = self
        automaticallyAdjustsScrollViewInsets = false
        tableView?.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 49, right: 0)
        // 指示器缩进
        tableView?.scrollIndicatorInsets = tableView!.contentInset
        // 实例化 refreshControl
        refreshControl = NTRefreshControl()
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
            self.pullupCount += 20
            loadData()
        }
    }
}
