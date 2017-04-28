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
    
    override var description: String {
        return yy_modelDescription()
    }
    override init() {
        super.init()
//        UserDefaults.standard.removeObject(forKey: "oauthToken")
//        UserDefaults.standard.removeObject(forKey: "oauthTokenSecret")

        oauthToken = UserDefaults.standard.value(forKey: "oauthToken") as? String
        oauthTokenSecret = UserDefaults.standard.value(forKey: "oauthTokenSecret") as? String
        
    }
    
    func saveAccount() {
        UserDefaults.standard.set(oauthToken, forKey: "oauthToken")
        UserDefaults.standard.set(oauthTokenSecret, forKey: "oauthTokenSecret")
        UserDefaults.standard.synchronize()
    }

}
