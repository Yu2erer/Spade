//
//  AppDelegate.swift
//  spade
//
//  Created by ntian on 2017/4/6.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import OAuthSwift
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        addAditions()
        window?.rootViewController = SPMainViewController()
        window?.makeKeyAndVisible()

        return true
    }
    fileprivate func addAditions() {
        SVProgressHUD.setMaximumDismissTimeInterval(2)
        #if DEBUG
            let fpsLabel = NTFPSLabel(frame: CGRect(x: 15, y: UIScreen.main.bounds.size.height - 80, width: 55, height: 20))
            self.window?.addSubview(fpsLabel)
        #endif
        if isHaveSetting == nil {
            // 没有初始化设置
            UserDefaults.UserSetting.set(value: "init", forKey: .isHaveSetting)
            UserDefaults.UserSetting.set(value: true, forKey: .isSmallWindowOn)
        }
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if (url.host == "oauth-callback") {
            OAuthSwift.handle(url: url)
        }
        return true
    }


}

