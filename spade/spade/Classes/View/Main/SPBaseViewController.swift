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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        loadData()
    }
    /// 具体实现子类负责
    func loadData() {
        
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
}
