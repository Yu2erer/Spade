//
//  SPUserAccount.swift
//  spade
//
//  Created by ntian on 2017/4/24.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class SPUserAccount: NSObject {
    
    var oauthToken: String?
    var oauthTokenSecret: String?
    // 备用
    var CONSUMERKEY = "HkEH8ZjbTtMcvcX6BYONlwHNhsFWi18voM9mqCOcYiDIiv4s3L"
    var CONSUMERSECRET = "96wNoKZPTf35pLdpFcUM3CDt7jdAkgFjtSdirWEogjtu4WoFYi"
    var Key: String?
    var Secret: String?
    var objectId: String?
    override var description: String {
        return yy_modelDescription()
    }
    override init() {
        super.init()
//        UserDefaults.standard.removeObject(forKey: "oauthToken")
//        UserDefaults.standard.removeObject(forKey: "oauthTokenSecret")
        Key = UserDefaults.standard.value(forKey: "Key") as? String
        Secret = UserDefaults.standard.value(forKey: "Secret") as? String
        oauthToken = UserDefaults.standard.value(forKey: "oauthToken") as? String
        oauthTokenSecret = UserDefaults.standard.value(forKey: "oauthTokenSecret") as? String
        
    }
    
    func saveAccount() {
        UserDefaults.standard.set(oauthToken, forKey: "oauthToken")
        UserDefaults.standard.set(oauthTokenSecret, forKey: "oauthTokenSecret")
        UserDefaults.standard.set(Key, forKey: "Key")
        UserDefaults.standard.set(Secret, forKey: "Secret")
        UserDefaults.standard.synchronize()
    }

}
