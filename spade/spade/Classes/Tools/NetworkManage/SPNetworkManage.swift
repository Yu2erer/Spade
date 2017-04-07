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
    
    
    func request(urlString: String, method: OAuthSwiftHTTPRequest.Method,parameters: [String: Any], completion: @escaping (_ json: Any?, _ isSuccess: Bool)->()) {
        
        SPNetworkManage.oauthswift.client.credential.oauthToken = "dTV6aFRu9gCj8IuVDspdc70Bu4SxJi0cFvXykaCQClbJayJouq"
        SPNetworkManage.oauthswift.client.credential.oauthTokenSecret = "dmMhBTyN2ukZom0PUxbEcDIiUXcECYN0luvCNUVp6UsVaOAHQH"
        
        
        SPNetworkManage.oauthswift.client.request(urlString, method: method, parameters: parameters, success: { (response) in
            completion(try? response.jsonObject(), true)
        }) { (error) in
            completion(nil, false)
            print(error)
        }
    }
}


