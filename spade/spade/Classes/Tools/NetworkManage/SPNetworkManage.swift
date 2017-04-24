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
    
    private static let oauthswift = OAuth1Swift(consumerKey: "Rbi5Bfim0iUYElkEWHo78I99FMbpMD3HjWKmu425UnMdahOckW", consumerSecret: "TjwKUiuWttcuV4qdjbmrUUnYUImNjWA6aJ0q6vk79ZawpLotOu", requestTokenUrl: REQUESTTOKENURL, authorizeUrl: AUTHORIZEURL, accessTokenUrl: ACCESSTOKENURL)
    
    /// 用户账户懒加载
    lazy var userAccount = SPUserAccount()
    
    var userLogon: Bool {
        return userAccount.oauthToken != nil && userAccount.oauthTokenSecret != nil
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
                completion(nil, false)
                print(error)
            })
        } else {
            SPNetworkManage.oauthswift.client.request(urlString, method: method, parameters: parameters!, success: { (response) in
                completion(try? response.jsonObject(), true)
            }) { (error) in
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


