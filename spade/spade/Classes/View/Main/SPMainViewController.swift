//
//  SPMainViewController.swift
//  spade
//
//  Created by ntian on 2017/4/6.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import SVProgressHUD

class SPMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let now = Int(Date().timeIntervalSince1970)
        
//        if now < 1494393193 {
            !SPNetworkManage.shared.userLogon && !SPNetworkManage.shared.haveKeyAndSecret ? SPNetworkManage.shared.loadKeyAndSecret() : ()
//        } else {
//            print("时间没到 不要出来!")
//        }
        
        
        
        setupUI()
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
extension SPMainViewController {
    @objc fileprivate func userLogin(n: Notification) {
        print("用户登录通知")
        UserDefaults.standard.removeObject(forKey: "oauthToken")
        UserDefaults.standard.removeObject(forKey: "oauthTokenSecret")
        SPNetworkManage.shared.userAccount.oauthToken = nil
        SPNetworkManage.shared.userAccount.oauthTokenSecret = nil
        selectedIndex = 0
        SVProgressHUD.setDefaultMaskType(.gradient)
        SVProgressHUD.showInfo(withStatus: "需要重新登录")
        var when = DispatchTime.now()
        if n.object != nil {
            when = DispatchTime.now() + 2
        }
        DispatchQueue.main.asyncAfter(deadline: when) { 
            self.setupUI()
        }
        NotificationCenter.default.removeObserver(self)
    }
}
// MARK: - UITabBarControllerDelegate
extension SPMainViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        
        let idx = (childViewControllers as NSArray).index(of: viewController)
        if selectedIndex == 0 && idx == selectedIndex {
            
            let nav = childViewControllers[0] as! UINavigationController
            let vc = nav.childViewControllers[0] as! SPHomeViewController
            vc.tableView?.setContentOffset(CGPoint(x: 0, y: -124), animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: { 
                vc.loadData()
            })
        }
        return true
    }
}
// MARK: - 设置界面
extension SPMainViewController {
    fileprivate func setupUI() {
        delegate = self
        setupChildControllers()
        SPNetworkManage.shared.userLogon ? () : view.addSubview(SPLoginView.loginView())
        print(SPNetworkManage.shared.userLogon)
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin(n:)), name: NSNotification.Name(rawValue: SPUserShouldLoginNotification), object: nil)
    }
    
    fileprivate func setupChildControllers() {
        
        let array = [
            ["clsName": "SPHomeViewController", "imageName": "tabbar-home"],
            ["clsName": "SPDiscoverViewController", "imageName": "tabbar-search"],
            ["clsName": "SPLikeViewController", "imageName": "tabbar-activity"],
            ["clsName": "SPProfileViewController", "imageName": "tabbar-profile"]
        ]
        var arrayM = [UIViewController]()
        for dict in array {
            arrayM.append(controller(dict: dict))
            
        }

        viewControllers = arrayM
        
    }
    
    fileprivate func controller(dict: [String: String]) -> UIViewController {
        
        guard let clsName = dict["clsName"], let imageName = dict["imageName"], let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? UIViewController.Type else {
            return UIViewController()
        }
        let vc = cls.init()
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.selectedImage = UIImage(named: imageName + "-highlighted")
        // 图像居中
        vc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        let nav = SPNavigationController(rootViewController: vc)
        return nav
    }
}
