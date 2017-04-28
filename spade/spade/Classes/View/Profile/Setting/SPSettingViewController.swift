//
//  SPSettingViewController.swift
//  spade
//
//  Created by ntian on 2017/4/27.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import Kingfisher

class SPSettingViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
    }
    fileprivate func telegram() {
        print("打开telegram")
    }
    fileprivate func cleanCache() {
        KingfisherManager.shared.cache.calculateDiskCacheSize { (cache) in
            let actionSheet = UIActionSheet(title: "确定要清除\(cache / 1024 / 1024)M缓存吗", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "确定")
            actionSheet.tag = 0
            actionSheet.show(in: self.view)
        }
    }
    fileprivate func logOut() {
        print("退出登录")
        let actionSheet = UIActionSheet(title: "确定要退出登录吗", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "确定")
        actionSheet.tag = 1
        actionSheet.show(in: self.view)

    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            switch row {
            case 0:
                telegram()
            case 1:
                cleanCache()
            default:
                break
            }
        } else if section == 1 && row == 0 {
            logOut()
        }
    }  
}
extension SPSettingViewController: UIActionSheetDelegate {
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 0 {
            switch actionSheet.tag {
            case 0:
                KingfisherManager.shared.cache.clearDiskCache()
            case 1:
                UserDefaults.standard.removeObject(forKey: "oauthToken")
                UserDefaults.standard.removeObject(forKey: "oauthTokenSecret")
                SPNetworkManage.shared.userAccount.oauthToken = nil
                SPNetworkManage.shared.userAccount.oauthTokenSecret = nil
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: SPUserShouldLoginNotification), object: nil)
                self.navigationController?.popViewController(animated: true)
            default:
                break
            }
        }
    }
}
// MARK: - 设置界面
extension SPSettingViewController {
    
    fileprivate func setupUI() {
        title = "设置"
    }
}
