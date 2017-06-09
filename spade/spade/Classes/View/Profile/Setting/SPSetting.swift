//
//  SPSetting.swift
//  spade
//
//  Created by ntian on 2017/4/27.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import Kingfisher

class SPSetting: UITableViewController {
    
    @IBOutlet weak var winSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        winSwitch.isOn = isSmallWindowOn
        setupUI()        
    }
    fileprivate func telegram() {
        guard let url = URL(string: "tg://join?invite=AAAAAEKmx465EHPO8MFeww") else {
            return
        }
        UIApplication.shared.openURL(url)
    }
    fileprivate func cleanCache() {
        KingfisherManager.shared.cache.calculateDiskCacheSize { (cache) in
            let actionSheet = UIActionSheet(title: "确定要清除\(cache / 1024 / 1024)M缓存吗", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "确定")
            actionSheet.tag = 0
            actionSheet.show(in: self.view)
        }
    }
    fileprivate func toService() {
        let vc = SPServiceViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    fileprivate func logOut() {
        print("退出登录")
        let actionSheet = UIActionSheet(title: "确定要退出登录吗", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "确定")
        actionSheet.tag = 1
        actionSheet.show(in: self.view)
    }
    @IBAction func windowSwitch(_ sender: UISwitch) {
        
            UserDefaults.UserSetting.set(value: !isSmallWindowOn, forKey: .isSmallWindowOn)
            isSmallWindowOn = !isSmallWindowOn
            print(UserDefaults.UserSetting.bool(forKey: .isSmallWindowOn))
       
    }
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
            let section = indexPath.section
            let row = indexPath.row
    
            if section == 1 {
                switch row {
                case 0:
                    telegram()
                case 1:
                    cleanCache()
                case 2:
                    toService()
                default:
                    break
                }
            } else if section == 2 && row == 0 {
                logOut()
            }
        }
}
extension SPSetting: UIActionSheetDelegate {
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 0 {
            switch actionSheet.tag {
            case 0:
                KingfisherManager.shared.cache.clearDiskCache()
            case 1:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: SPUserShouldLoginNotification), object: nil)
                self.navigationController?.popViewController(animated: true)
            default:
                break
            }
        }
    }
}
// MARK: - 设置界面
extension SPSetting {
    fileprivate func setupUI() {
        title = NSLocalizedString("Setting", comment: "设置")
    }
}
