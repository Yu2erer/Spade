//
//  SPMainViewController.swift
//  spade
//
//  Created by ntian on 2017/4/6.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class SPMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChildControllers()
    }

}

// MARK: - 设置界面
extension SPMainViewController {
    
    fileprivate func setupChildControllers() {
        
        let array = [
            ["clsName": "SPHomeViewController", "imageName": "tabbar-home"],
            ["clsName": "SPHomeViewController", "imageName": "tabbar-search"],
            ["clsName": "SPHomeViewController", "imageName": "tabbar-activity"],
            ["clsName": "SPHomeViewController", "imageName": "tabbar-profile"]
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
        vc.tabBarItem.selectedImage = UIImage(named: imageName + "-highlighted")?.withRenderingMode(.alwaysOriginal)
        // 图像居中
        vc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        let nav = SPNavigationController(rootViewController: vc)
        return nav
    }
}
