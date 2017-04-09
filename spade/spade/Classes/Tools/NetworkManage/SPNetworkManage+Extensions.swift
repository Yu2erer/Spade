//
//  SPNetworkManage+Extensions.swift
//  spade
//
//  Created by ntian on 2017/4/7.
//  Copyright © 2017年 ntian. All rights reserved.
//

import Foundation

// MARK: - 封装Tumblr 网络请求方法
extension SPNetworkManage {
    
    /// 加载 dashBoard
    func dashBoardList(since_id: String, completion: @escaping (_ list: [[String: Any]]?, _ isSuccess: Bool)->()) {
        
        let params = ["since_id": since_id]
        
        request(urlString: dashBoardURL, method: .GET, parameters: params) { (json, isSuccess) in
            
            let result = json as? [String: Any]
        
            let data = result?["response"] as? [String: Any]
//            let data = JSON(json ?? [])["response"]["posts"].arrayObject as? [[String: Any]]
            completion(data?["posts"] as? [[String: Any]], isSuccess)
        }   
    }
    
    /// 加载 BlogInfo
    func blogInfo(blogName: String, completion: @escaping (_ list: [String: Any]?, _ isSuccess: Bool)->()) {
        
        request(urlString: blogInfoURL + blogName + "/info", method: .GET, parameters: nil) { (json, isSuccess) in
            
            let result = json as? [String: Any]
            
            let data = result?["response"] as? [String: Any]
            
            completion(data?["blog"] as? [String: Any], isSuccess)
        }
    }
    

    
        
}
