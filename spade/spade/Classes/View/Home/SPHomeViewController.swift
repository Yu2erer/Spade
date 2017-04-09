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
    fileprivate lazy var dashBoardListViewModel = SPDashBoardListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
//        SPNetworkManage.shared.blogInfo(blogName: "ntian.tumblr.com") { (json, isSuccess) in
//            print(json)
//        }

        
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    
    /// 加载数据
    override func loadData() {
        
        dashBoardListViewModel.loadDashBoard(pullup: self.isPullup) { (isSuccess) in
            
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
        return dashBoardListViewModel.dashBoardList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SPHomeTableViewCell
    
        let vm = dashBoardListViewModel.dashBoardList[indexPath.row]
        cell.viewModel = vm
        
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pan = scrollView.panGestureRecognizer
        let velocity = pan.velocity(in: scrollView).y
        
        if velocity < -5 {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        } else if velocity > 5{
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }

    }
}
