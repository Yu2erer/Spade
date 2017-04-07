//
//  SPHomeViewController.swift
//  spade
//
//  Created by ntian on 2017/4/6.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

private let cellId = "cellId"

class SPHomeViewController: SPBaseViewController {
    
    fileprivate lazy var statusList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    /// 加载数据
    override func loadData() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            for i in 0..<15 {
                if self.isPullup {
                    // 将数据追加到底部
                    self.statusList.append("上拉\(i)")
                } else {
                    self.statusList.insert(i.description, at: 0)
                }
            }
            print("刷新表格")
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
        return statusList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = statusList[indexPath.row]
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
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
}
