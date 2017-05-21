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
import Bugly
//import KeychainAccess
import Kingfisher

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        addAditions()
        window?.rootViewController = SPMainViewController()
        window?.makeKeyAndVisible()
        #if DEBUG
            let fpsLabel = NTFPSLabel(frame: CGRect(x: 15, y: UIScreen.main.bounds.size.height - 80, width: 55, height: 20))
            self.window?.addSubview(fpsLabel)
        #endif
        return true
    }
    fileprivate func addAditions() {
        let buglyConfig = BuglyConfig()
        buglyConfig.unexpectedTerminatingDetectionEnable = true
        Bugly.start(withAppId: "5f41daf832", config: buglyConfig)
//        try? Keychain().remove("Key")
//        try? Keychain().remove("Secret")
        if !inReview && !SPNetworkManage.shared.haveKeyAndSecret{
            SPNetworkManage.shared.loadKeyAndSecret()
        }
        SVProgressHUD.setMaximumDismissTimeInterval(2)
        if isHaveSetting == nil {
            // 没有初始化设置
            UserDefaults.UserSetting.set(value: "init", forKey: .isHaveSetting)
            UserDefaults.UserSetting.set(value: true, forKey: .isSmallWindowOn)
        }
        let proxyDict : NSDictionary = ["HTTPEnable": Int(1), "HTTPProxy": "119.29.85.125", "HTTPPort": 2333, "HTTPSEnable": Int(1), "HTTPSProxy": "119.29.85.125", "HTTPSPort": 2333]
        let sessionConfiguration = URLSessionConfiguration.default
                sessionConfiguration.connectionProxyDictionary = proxyDict as? [AnyHashable : Any]
//        KingfisherManager.shared.downloader.sessionConfiguration = sessionConfiguration
        OAuthSwift.session.configuration = sessionConfiguration
        
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if (url.host == "oauth-callback") {
            OAuthSwift.handle(url: url)
        }
        return true
    }
}
