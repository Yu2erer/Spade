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
    private static let oauthswift = OAuth1Swift(consumerKey: CONSUMERKEY, consumerSecret: CONSUMERSECRET, requestTokenUrl: REQUESTTOKENURL, authorizeUrl: AUTHORIZEURL, accessTokenUrl: ACCESSTOKENURL)
    
    
    func request(urlString: String, method: OAuthSwiftHTTPRequest.Method,parameters: [String: Any]?, completion: @escaping (_ json: Any?, _ isSuccess: Bool)->()) {
        

        SPNetworkManage.oauthswift.client.credential.oauthToken = "YqUxedXOpUlhbIZBQrhngmFXPj87aJvslJyRX5dDulpxRD6goK"
        SPNetworkManage.oauthswift.client.credential.oauthTokenSecret = "u8vldkgoP2SZrZ4ArMU0XdUL1cbpt6ngAdiFmi3KR5k9RMoFju"
        
        
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
    
    func loadToken() {
        
        let handle = SPNetworkManage.oauthswift.authorize(withCallbackURL: "oauth-swift://oauth-callback/tumblr", success: { (credential, response, parameters) in
            
            SPNetworkManage.oauthswift.client.credential.oauthToken = credential.oauthToken
            SPNetworkManage.oauthswift.client.credential.oauthTokenSecret = credential.oauthTokenSecret
        }) { (error) in
            print(error.description)
        }
    }
}


