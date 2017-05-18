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
//import NEKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        let proxyDict : NSDictionary = ["HTTPEnable": Int(1), "HTTPProxy": "119.29.85.125", "HTTPPort": 2333, "HTTPSEnable": Int(1), "HTTPSProxy": "119.29.85.125", "HTTPSPort": 2333]
//        let sessionConfiguration = URLSessionConfiguration.default
//        sessionConfiguration.connectionProxyDictionary = proxyDict as? [AnyHashable : Any]
//        KingfisherManager.shared.downloader.sessionConfiguration = sessionConfiguration
        addAditions()
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        window?.rootViewController = SPMainViewController()
        window?.makeKeyAndVisible()
//        URLProtocol.registerClass(NTProxyProtocol.self)
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
        #if DEBUG
            let fpsLabel = NTFPSLabel(frame: CGRect(x: 15, y: UIScreen.main.bounds.size.height - 80, width: 55, height: 20))
            self.window?.addSubview(fpsLabel)
        #endif
        if isHaveSetting == nil {
            // 没有初始化设置
            UserDefaults.UserSetting.set(value: "init", forKey: .isHaveSetting)
            UserDefaults.UserSetting.set(value: true, forKey: .isSmallWindowOn)
        }

//        let ss = ShadowsocksAdapterFactory(serverHost: "47.88.175.52", serverPort: 1111, protocolObfuscaterFactory:         ShadowsocksAdapter.ProtocolObfuscater.Factory(), cryptorFactory: ShadowsocksAdapter.CryptoStreamProcessor.Factory(password: "jh781201", algorithm: CryptoAlgorithm.RC4MD5), streamObfuscaterFactory: ShadowsocksAdapter.StreamObfuscater.Factory())
//        let allRule = AllRule(adapterFactory: ss)
//        let manager = RuleManager(fromRules: [allRule], appendDirect: true)
//        
//        RuleManager.currentManager = manager
//        
//        let proxyServer = GCDHTTPProxyServer(address: IPAddress(fromString: "127.0.0.1"), port: 9090)
//        try! proxyServer.start()
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if (url.host == "oauth-callback") {
            OAuthSwift.handle(url: url)
        }
        return true
    }
}
