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
//import StoreKit
//import KeychainAccess

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
        #else
            let buglyConfig = BuglyConfig()
            buglyConfig.unexpectedTerminatingDetectionEnable = true
            Bugly.start(withAppId: "5f41daf832", config: buglyConfig)
        #endif
        return true
    }
    fileprivate func addAditions() {
//        try? Keychain().remove("Key")
//        try? Keychain().remove("Secret")
//        SPNetworkManage.shared.getInReview()
        if !inReview && !SPNetworkManage.shared.haveKeyAndSecret{
            SPNetworkManage.shared.loadKeyAndSecret()
        }
        SVProgressHUD.setMaximumDismissTimeInterval(2)
        if isHaveSetting == nil {
            // 没有初始化设置
            UserDefaults.UserSetting.set(value: "init", forKey: .isHaveSetting)
            UserDefaults.UserSetting.set(value: true, forKey: .isSmallWindowOn)
        }
        
        if inReview == false {
            let sessionConfiguration = URLSessionConfiguration.default
            sessionConfiguration.connectionProxyDictionary = proxyDict as? [AnyHashable : Any]
            OAuthSwift.session.configuration = sessionConfiguration
        }
//        let VERIFY_RECEIPT_URL = "https://buy.itunes.apple.com/verifyReceipt"
//        let ITMS_SANDBOX_VERIFY_RECEIPT_URL = "https://sandbox.itunes.apple.com/verifyReceipt"

//        let refreshReceiptRequest = SKReceiptRefreshRequest(receiptProperties: [:])
//        refreshReceiptRequest.start()
//        let receiptURL = Bundle.main.appStoreReceiptURL
//        let receiptData = try? Data(contentsOf: receiptURL!)
//        let encodeStr = receiptData?.base64EncodedString(options: .endLineWithLineFeed)
//        let url = URL(string: ITMS_SANDBOX_VERIFY_RECEIPT_URL)
//        let request = NSMutableURLRequest(url: url!)
//        request.httpMethod = "POST"
//        let payload = NSString(string: "{\"receipt-data\" : \"" + encodeStr! + "\"}") as String
//        let payloadData = payload.data(using: .utf8)
//        request.httpBody = payloadData
//        
//        let result = try? NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: nil)
//
//        
//        let dict = try? JSONSerialization.jsonObject(with: result!, options: [])
//        print(dict as? [String: Any])
  
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if (url.host == "oauth-callback") {
            OAuthSwift.handle(url: url)
        }
        return true
    }
}
