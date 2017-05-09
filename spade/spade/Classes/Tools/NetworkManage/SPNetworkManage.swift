//
//  SPNetworkManage.swift
//  spade
//
//  Created by ntian on 2017/4/6.
//  Copyright © 2017年 ntian. All rights reserved.
//

import Foundation
import OAuthSwift

class SPNetworkManage {
    
    private init() {}
    
    static let shared = SPNetworkManage()
    
    var haveKeyAndSecret: Bool {
//        return false
        return userAccount.Key != nil && userAccount.Secret != nil
    }
    private static let oauthswift = OAuth1Swift(consumerKey: CONSUMERKEY!, consumerSecret: CONSUMERSECRET!, requestTokenUrl: REQUESTTOKENURL, authorizeUrl: AUTHORIZEURL, accessTokenUrl: ACCESSTOKENURL)
    
    
    /// 用户账户懒加载
    lazy var userAccount = SPUserAccount()
    
    var userLogon: Bool {
        return userAccount.oauthToken != nil && userAccount.oauthTokenSecret != nil
    }
    func loadKeyAndSecret() {
        
        let urlString = "https://leancloud.cn/1.1/classes/KeyClass?where=%7B%22usersNum%22%3A%7B%22%24lt%22%3A4%7D%7D"
        let headers = ["X-LC-Id": "ECkMpp8rkLW1mlo6zmqlmneF-gzGzoHsz",
                       "X-LC-Key": "FAfJ9C5Jtqy9WKz2e7pNp84Y",
                       "Content-Type": "application/json"]
        let params = ["limit": 1] as [String : Any]
        SPNetworkManage.oauthswift.client.request(urlString, method: .GET, parameters: params, headers: headers, body: nil, checkTokenExpiration: false, success: { (response) in
            let json = try? response.jsonObject()
            let result = json as? [String: Any]
            guard let data = result?["results"] as? [[String: Any]] else {
                return
            }
            for d in data {
                self.userAccount.Key = d["Key"] as? String
                self.userAccount.Secret = d["Secret"] as? String
                self.userAccount.objectId = d["objectId"] as? String
            }
            guard let objectId = self.userAccount.objectId else {
                // 得不到数据 改用自带的
                self.userAccount.Key = self.userAccount.CONSUMERKEY
                self.userAccount.Secret = self.userAccount.CONSUMERSECRET
                self.userAccount.saveAccount()
                return
            }
            self.increment(objectId: objectId)
            self.userAccount.saveAccount()
        }) { (error) in
            print(error.description)
        }
    }
    private func increment(objectId: String) {
        let urlString = "https://leancloud.cn/1.1/classes/KeyClass/\(objectId)"
        let headers = ["X-LC-Id": "ECkMpp8rkLW1mlo6zmqlmneF-gzGzoHsz",
                       "X-LC-Key": "FAfJ9C5Jtqy9WKz2e7pNp84Y",
                       "Content-Type": "application/json"]
        let params = ["usersNum": ["__op": "Increment", "amount": 1]]
        SPNetworkManage.oauthswift.client.request(urlString, method: .PUT, parameters: params, headers: headers, body: nil, checkTokenExpiration: false, success: { (response) in
        }) { (error) in
            print(error)
        }
    }
    
    func request(urlString: String, method: OAuthSwiftHTTPRequest.Method,parameters: [String: Any]?, completion: @escaping (_ json: Any?, _ isSuccess: Bool)->()) {
        
        guard let oauthToken = userAccount.oauthToken, let oauthTokenSecret = userAccount.oauthTokenSecret else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SPUserShouldLoginNotification), object: nil)
            completion(nil, false)
            return
        }
        SPNetworkManage.oauthswift.client.credential.oauthToken = oauthToken
        SPNetworkManage.oauthswift.client.credential.oauthTokenSecret = oauthTokenSecret
        if parameters == nil {
            SPNetworkManage.oauthswift.client.request(urlString, method: method, success: { (response) in
                completion(try? response.jsonObject(), true)
            }, failure: { (error) in
                if error.description.contains("401") {
                    // 处理token 过期等等事件
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: SPUserShouldLoginNotification), object: "cx")
                }
                completion(nil, false)
                print(error)
            })
        } else {
            SPNetworkManage.oauthswift.client.request(urlString, method: method, parameters: parameters!, success: { (response) in
                completion(try? response.jsonObject(), true)
            }) { (error) in
                if error.description.contains("401") {
                    // 处理token 过期等等事件
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: SPUserShouldLoginNotification), object: "cx")
                }
                completion(nil, false)
                print(error)
            }
        }
    }

    func loadToken(completion: @escaping (_ isSuccess: Bool)->()) {
        
        SPNetworkManage.oauthswift.authorizeURLHandler = SPOAuthViewController()
        
        let _ = SPNetworkManage.oauthswift.authorize(withCallbackURL: URL(string: "spade://oauth-callback/tumblr")!, success: { (credential, response, parameters) in
            self.userAccount.oauthToken = credential.oauthToken
            self.userAccount.oauthTokenSecret = credential.oauthTokenSecret
            self.userAccount.saveAccount()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SPUserLoginSuccessedNotification), object: nil)
            completion(true)
        }) { (error) in
            print(error.description)
            completion(false)
        }
    }
}


