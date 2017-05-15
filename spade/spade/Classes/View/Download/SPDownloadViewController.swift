//
//  SPDownloadViewController.swift
//  spade
//
//  Created by ntian on 2017/5/11.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class SPDownloadViewController: UIViewController {
    
    fileprivate lazy var tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

}
// MARK: - 设置界面
extension SPDownloadViewController {
    fileprivate func setupUI() {
        navigationItem.title = "下载"
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: PictureViewWidth, height: view.bounds.height), style: .plain)
        view.addSubview(tableView)
    }
}
