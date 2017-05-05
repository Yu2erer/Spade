//
//  SPDiscoverViewController.swift
//  spade
//
//  Created by ntian on 2017/4/21.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import SVProgressHUD
private let userCellId = "userCellId"
class SPDiscoverViewController: UIViewController {

    fileprivate lazy var searchBar = UISearchBar()
    fileprivate lazy var userTableView = UITableView()
    fileprivate lazy var postTableView = UITableView()
    fileprivate lazy var contentScrollView = UIScrollView()
    fileprivate lazy var topBarView: SPDiscoverTopBarView = SPDiscoverTopBarView()
    fileprivate lazy var messageHud: NTMessageHud = NTMessageHud()
    fileprivate lazy var customNavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 12, width: PictureViewWidth, height: 64))
    fileprivate lazy var navItem = UINavigationItem()

    fileprivate lazy var blogInfo = SPBlogInfoViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        searchBar.becomeFirstResponder()
        navigationController?.view.insertSubview(customNavigationBar, at: 1)
        navigationController?.setNavigationBarHidden(true, animated: animated)
//        navItem.titleView = topBarView
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
//        navItem.titleView = nil
        customNavigationBar.removeFromSuperview()
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
//        performSelector(onMainThread: #selector(delayHidden), with: animated, waitUntilDone: false)
    }
    func delayHidden(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    func searchWhat(What: Int, searchText: String) {
        SVProgressHUD.show()
        if What == 0 {
//            print("搜索用户")
            let blogName = searchText + ".tumblr.com"
            blogInfo.loadBlogInfo(blogName: blogName) { (isSuccess) in
                SVProgressHUD.dismiss()
                if isSuccess {
                    self.userTableView.reloadData()
                } else {
                    self.messageHud.showMessage(view: self.view, msg: "搜索不到该用户~", isError: true)
                }
            }
        } else {
            // FIXME: 懒得做咯
//            print("搜索帖子")
//            SVProgressHUD.dismiss()
        }
    }
}
// MARK: - UISearchBarDelegate
extension SPDiscoverViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        searchBar.resignFirstResponder()
        searchWhat(What: 0, searchText: searchText)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        contentScrollView.isHidden = true
//        topBarView.isHidden = true

    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        contentScrollView.isHidden = false
//        topBarView.isHidden = false
    }
}
// MARK: - UITableViewDelegate, UITableViewDataSource
extension SPDiscoverViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTableView.dequeueReusableCell(withIdentifier: userCellId, for: indexPath) as! SPFollowingTableViewCell
        cell.followBtn.isHidden = true
        cell.model = blogInfo.blogInfo
        cell.cellDelegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return blogInfo.blogInfo.name != nil ? 1 : 0
        } else {
            return 2
        }
    }
}
// MARK: - UIScrollViewDelegate
extension SPDiscoverViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.x >= PictureViewWidth) && scrollView == contentScrollView {
//            topBarView.postBtn()
        } else if scrollView == contentScrollView {
//            topBarView.userBtn()
        }
    }
}
// MARK: - SPFollowingTableViewCellDelegate
extension SPDiscoverViewController: SPFollowingTableViewCellDelegate {
    func didClickUser(name: String) {
        let vc = SPUserDetailViewController()
        vc.name = name
        navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - SPDiscoverTopBarViewDelegate
extension SPDiscoverViewController: SPDiscoverTopBarViewDelegate {
    func didClickUserButton() {
        contentScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        searchBar.placeholder = "搜索用户"
    }
    func didClickPostButton() {
        contentScrollView.setContentOffset(CGPoint(x: PictureViewWidth, y: 0), animated: true)
        searchBar.placeholder = "搜索帖子"
    }
}
// MARK: - 设置界面
extension SPDiscoverViewController {
    fileprivate func setupUI() {
        automaticallyAdjustsScrollViewInsets = false
        
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        let image = UIImage().imageWithColor(color: UIColor(white: 1, alpha: 1))
        customNavigationBar.setBackgroundImage(UIImage(), for: .default)
        customNavigationBar.shadowImage = UIImage()
        customNavigationBar.items = [navItem]

//        topBarView = Bundle.main.loadNibNamed("SPDiscoverTopBarView", owner: nil, options: nil)?.last as! SPDiscoverTopBarView
//        topBarView.frame = CGRect(x: 0, y: 0, width: PictureViewWidth, height: 40)
//        topBarView.viewDelegate = self
//        view.addSubview(topBarView)
        
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: PictureViewWidth, height: 34))
        searchBar.placeholder = "搜索用户"
        searchBar.delegate = self
        let searchTextFeild = searchBar.subviews.first?.subviews.last
        searchTextFeild?.backgroundColor = UIColor(hex: 0xE5E5E8)
        navItem.titleView = searchBar
        
        contentScrollView = UIScrollView(frame: CGRect(x: 0, y: 64, width: PictureViewWidth, height: UIScreen.main.bounds.height - 64))
        contentScrollView.contentSize = CGSize(width: PictureViewWidth, height: 0)
        contentScrollView.isPagingEnabled = true
        contentScrollView.alwaysBounceHorizontal = true
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.delegate = self
        view.addSubview(contentScrollView)

        userTableView = UITableView(frame: CGRect(x: 0, y: 5, width: PictureViewWidth, height: UIScreen.main.bounds.height - 64), style: .plain)
        userTableView.tag = 0
        userTableView.separatorStyle = .none
        userTableView.register(UINib(nibName: "SPFollowingTableViewCell", bundle: nil), forCellReuseIdentifier: userCellId)
        userTableView.rowHeight = 56
        userTableView.delegate = self
        userTableView.dataSource = self
//        postTableView = UITableView(frame: CGRect(x: PictureViewWidth, y: 0, width: PictureViewWidth, height: UIScreen.main.bounds.height), style: .plain)
//        postTableView.rowHeight = UITableViewAutomaticDimension
//        postTableView.estimatedRowHeight = 300
        contentScrollView.addSubview(userTableView)
        contentScrollView.isHidden = true
//        topBarView.isHidden = true
        
    }
}
