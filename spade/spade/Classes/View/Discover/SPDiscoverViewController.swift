//
//  SPDiscoverViewController.swift
//  spade
//
//  Created by ntian on 2017/4/21.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class SPDiscoverViewController: UIViewController {

    fileprivate lazy var searchBar = UISearchBar()
    fileprivate lazy var userTableView = UITableView()
    fileprivate lazy var contentScrollView = UIScrollView()
    fileprivate lazy var topBarView: SPDiscoverTopBarView = SPDiscoverTopBarView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
        
    }
}
// MARK: - UISearchBarDelegate
extension SPDiscoverViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        contentScrollView.isHidden = true
        topBarView.isHidden = true

    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        contentScrollView.isHidden = false
        topBarView.isHidden = false

    }
}
// MARK: - UIScrollViewDelegate
extension SPDiscoverViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.x >= PictureViewWidth) && scrollView == contentScrollView {
            topBarView.postBtn()

        } else if scrollView == contentScrollView {
            topBarView.userBtn()
       
        }

    }
}
// MARK: - SPDiscoverTopBarViewDelegate
extension SPDiscoverViewController: SPDiscoverTopBarViewDelegate {
    func didClickUserButton() {
        contentScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)

    }
    func didClickPostButton() {
        contentScrollView.setContentOffset(CGPoint(x: PictureViewWidth, y: 0), animated: true)
    }
}
// MARK: - 设置界面
extension SPDiscoverViewController {
    fileprivate func setupUI() {
        automaticallyAdjustsScrollViewInsets = false
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
        topBarView = Bundle.main.loadNibNamed("SPDiscoverTopBarView", owner: nil, options: nil)?.last as! SPDiscoverTopBarView
        topBarView.frame = CGRect(x: 0, y: 64, width: PictureViewWidth, height: 40.5)
        topBarView.viewDelegate = self
        view.addSubview(topBarView)
        
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 5, width: PictureViewWidth, height: 34))
        searchBar.placeholder = "搜索"
        searchBar.delegate = self
        let searchTextFeild = searchBar.subviews.first?.subviews.last
        searchTextFeild?.backgroundColor = UIColor(hex: 0xE5E5E8)
        navigationItem.titleView = searchBar
        
        contentScrollView = UIScrollView(frame: CGRect(x: 0, y: 104.5, width: PictureViewWidth, height: UIScreen.main.bounds.height - 64))
        contentScrollView.contentSize = CGSize(width: PictureViewWidth * 2, height: 200)
        contentScrollView.isPagingEnabled = true
        contentScrollView.alwaysBounceHorizontal = true
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.delegate = self
        view.addSubview(contentScrollView)

        userTableView = UITableView(frame: CGRect(x: 0, y: 0, width: PictureViewWidth, height: UIScreen.main.bounds.height - 64), style: .plain)
        contentScrollView.addSubview(userTableView)
        contentScrollView.isHidden = true
        topBarView.isHidden = true
        
    }
}
