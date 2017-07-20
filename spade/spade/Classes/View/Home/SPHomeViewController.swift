//
//  SPHomeViewController.swift
//  spade
//
//  Created by ntian on 2017/4/6.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import ZFPlayer
import Popover

private let photoCellId = "photoCellId"
private let videoCellId = "videoCellId"

enum loadType: String {
    case home = "home"
    case photo = "photo"
    case video = "video"
}
class SPHomeViewController: SPBaseViewController {
    
    fileprivate var selected: String = loadType.home.rawValue
    /// 列表视图模型
    lazy var dashBoardListViewModel = SPDashBoardListViewModel()
    fileprivate var popover: Popover!
    fileprivate var popoverOptions: [PopoverOption] = [
        .type(.down),
        .blackOverlayColor(UIColor(white: 0.0, alpha: 0.6))
    ]
    fileprivate lazy var selectLoadView: SPSelectLoadView = Bundle.main.loadNibNamed("SPSelectLoadView", owner: nil, options: nil)?.last as! SPSelectLoadView


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(browserPhoto), name: NSNotification.Name(rawValue: SPHomeCellBrowserPhotoNotification), object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc fileprivate func browserPhoto(n: Notification) {
        guard let selectedIndex = n.userInfo?[SPHomeCellBrowserPhotoSelectedIndexKey] as? Int,
            let urls = n.userInfo?[SPHomeCellBrowserPhotoURLsKey] as? [String],let imageViewList = n.userInfo?[SPHomeCellBrowserPhotoImageView] as? [UIImageView] else {
            return
        }
        let vc = NTPhotoBrowserController(selectedIndex: selectedIndex, urls: urls, parentImageViews: imageViewList)
        present(vc, animated: true, completion: nil)
    }
    /// 加载数据
    override func loadData() {
        self.refreshControl?.beginRefreshing()
        self.dashBoardListViewModel.loadDashBoard(type: self.selected, pullup: self.isPullup) { (isSuccess, shouldRefresh) in
            self.refreshControl?.endRefreshing()
            self.isPullup = false
            if !isSuccess {
                NTMessageHud.showMessage(targetView: self.view, message: NSLocalizedString("RefreshFeedError", comment: "加载失败"), isError: true)
                return
            }
            if shouldRefresh {
                self.tableView?.reloadData()
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        playerView?.resetPlayer()
    }
    @objc fileprivate func test() {
        let vc = SPDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    lazy var playerView: ZFPlayerView? = {
        let playerView = ZFPlayerView.shared()
        return playerView
    }()
}
// MARK: - UITableViewDataSource
extension SPHomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dashBoardListViewModel.dashBoardList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if dashBoardListViewModel.dashBoardList.count == 0 {
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            return cell
        }
        let vm = dashBoardListViewModel.dashBoardList[indexPath.row]

        let cellId = (vm.dashBoard.type == "video") ? videoCellId : photoCellId
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SPHomeTableViewCell
        weak var weakSelf = self
        cell.viewModel = vm
        cell.cellDelegate = self
        if vm.dashBoard.type == "video" {
            cell.playBack = {
                
                let playerModel = ZFPlayerModel()
                playerModel.videoURL = URL(string: vm.dashBoard.video_url ?? "https://127.0.0.1")
                playerModel.placeholderImageURLString = vm.dashBoard.thumbnail_url ?? ""
                playerModel.indexPath = indexPath
                playerModel.tableView = tableView
                playerModel.fatherView = cell.placeholderImage
                weakSelf?.playerView?.playerModel(playerModel)
                weakSelf?.playerView?.autoPlayTheVideo()
                weakSelf?.playerView?.stopPlayWhileCellNotVisable = !isSmallWindowOn
                UIApplication.shared.statusBarStyle = .default
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if dashBoardListViewModel.dashBoardList.count == 0 {
            return 0
        }
        let vm = dashBoardListViewModel.dashBoardList[indexPath.row]
        return vm.rowHeight
    }
}
// MARK: - SPHomeTableViewCellDelegate
extension SPHomeViewController: SPHomeTableViewCellDelegate {
    func didClickUser(name: String) {
        let vc = SPUserDetailViewController()
        vc.name = name
        navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - SPSelectLoadViewDelegate
extension SPHomeViewController: SPSelectLoadViewDelegate {
    func didClickHome() {
        let button = SPTitleButton(title: NSLocalizedString("Spade", comment: "主页咯"))
        button.addTarget(self, action: #selector(clickTitleButton(btn:)), for: .touchUpInside)
        navigationItem.titleView = button
        popover.dismiss()
        if dashBoardListViewModel.dashBoardList.count == 0 {
            return
        }
        selected = loadType.home.rawValue
        dashBoardListViewModel.dashBoardList.removeAll()
        loadData()
        tableView?.selectRow(at: IndexPath.init(row: 0, section: 0), animated: false, scrollPosition: .top)

    }
    func didClickPhoto() {
        let button = SPTitleButton(title: NSLocalizedString("Photo", comment: "图片咯"))
        button.addTarget(self, action: #selector(clickTitleButton(btn:)), for: .touchUpInside)
        navigationItem.titleView = button
        popover.dismiss()
        if dashBoardListViewModel.dashBoardList.count == 0 {
            return
        }
        selected = loadType.photo.rawValue
        dashBoardListViewModel.dashBoardList.removeAll()
        loadData()
        tableView?.selectRow(at: IndexPath.init(row: 0, section: 0), animated: false, scrollPosition: .top)
    }
    func didClickVideo() {
        
        let button = SPTitleButton(title: NSLocalizedString("Video", comment: "视频咯"))
        button.addTarget(self, action: #selector(clickTitleButton(btn:)), for: .touchUpInside)
        navigationItem.titleView = button
        popover.dismiss()
        if dashBoardListViewModel.dashBoardList.count == 0 {
            return
        }
        selected = loadType.video.rawValue
        dashBoardListViewModel.dashBoardList.removeAll()
        loadData()
        tableView?.selectRow(at: IndexPath.init(row: 0, section: 0), animated: false, scrollPosition: .top)

    }
}
// MARK: - 设置界面
extension SPHomeViewController {
    
    fileprivate func setupUI() {
//        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "bar-button-camera", target: self, action: #selector(test))
        let button = SPTitleButton(title: "Spade")
        button.addTarget(self, action: #selector(clickTitleButton(btn:)), for: .touchUpInside)
        navigationItem.titleView = button
        
        selectLoadView.frame = CGRect(x: 0, y: 0, width: PictureViewWidth * 0.3, height: 120)
        selectLoadView.viewDelegate = self

    }
    @objc fileprivate func clickTitleButton(btn: UIButton) {
        
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            popover = Popover(options: popoverOptions)
            popover.show(selectLoadView, fromView: btn)
        } else {
            popover.dismiss()
        }
        popover.willDismissHandler = {
            btn.isSelected = !btn.isSelected
        }
    }
    override func setupTableView() {
        super.setupTableView()

        tableView?.register(UINib(nibName: "SPHomeTableViewCell", bundle: nil), forCellReuseIdentifier: photoCellId)
        tableView?.register(UINib(nibName: "SPHomeVideoTableViewCell", bundle: nil), forCellReuseIdentifier: videoCellId)
        // 自动行高
//        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 300
        tableView?.separatorStyle = .none
    }
}
