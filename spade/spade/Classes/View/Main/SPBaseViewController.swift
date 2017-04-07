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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

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
    }
}
