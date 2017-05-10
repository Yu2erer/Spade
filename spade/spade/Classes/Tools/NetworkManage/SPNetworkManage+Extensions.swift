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
    func dashBoardList(since_id: String, offset: String, type: String, completion: @escaping (_ list: [[String: Any]]?, _ isSuccess: Bool)->()) {
        var params = [String: String]()
        if type == "home" {
            params = ["since_id": since_id,
                          "offset": offset,
                          "limit": "20"]
        } else {
            params = ["since_id": since_id,
                          "offset": offset,
                          "limit": "20",
                          "type": type]
        }
        request(urlString: dashBoardURL, method: .GET, parameters: params) { (json, isSuccess) in
            
            let result = json as? [String: Any]
        
            let data = result?["response"] as? [String: Any]
            completion(data?["posts"] as? [[String: Any]], isSuccess)
        }   
    }
    
    func userList(blogName: String, offset: String, completion: @escaping (_ list: [[String: Any]]?, _ isSuccess: Bool)->()) {
        
        let params = ["offset": offset,
                      "limit": "20"]
        
        request(urlString: blogInfoURL + blogName + "/posts", method: .GET, parameters: params) { (json, isSuccess) in
            
            let result = json as? [String: Any]
            
            let data = result?["response"] as? [String: Any]
            completion(data?["posts"] as? [[String: Any]], isSuccess)
        }
    }
    
    /// 加载 BlogInfo
    func blogInfo(blogName: String, completion: @escaping (_ list: [String: Any]?, _ isSuccess: Bool)->()) {
        
        request(urlString: blogInfoURL + blogName + "/posts", method: .GET, parameters: nil) { (json, isSuccess) in
            
            let result = json as? [String: Any]
            let data = result?["response"] as? [String: Any]

            completion(data?["blog"] as? [String: Any], isSuccess)
        }
    }
    /// 加载用户 blogInfo
    func userBlogInfo(completion: @escaping (_ list: [String: Any]?, _ isSuccess: Bool)->()) {
        
        request(urlString: infoURL, method: .GET, parameters: nil) { (json, isSuccess) in
            let result = json as? [String: Any]
            let data = result?["response"] as? [String: Any]

            completion(data?["user"] as? [String: Any], isSuccess)
        }
    }
    /// 加载用户 Likes
    func userBlogLikes(offset: String, completion: @escaping (_ list: [[String: Any]]?, _ isSuccess: Bool)->()) {
        
        let params = ["offset": offset,
                      "limit": "20"]
        request(urlString: likesURL, method: .GET, parameters: params) { (json, isSuccess) in
            let result = json as? [String: Any]
            let data = result?["response"] as? [String: Any]
            completion(data?["liked_posts"] as? [[String: Any]], isSuccess)
        }
    }
    func blogLikes(blogName: String, offset: String, completion: @escaping (_ list: [[String: Any]]?, _ isSuccess: Bool)->()) {
        
        let params = ["offset": offset,
                      "limit": "20"]
        
        request(urlString: blogInfoURL + blogName + "/likes", method: .GET, parameters: params) { (json, isSuccess) in
            let result = json as? [String: Any]
            let data = result?["response"] as? [String: Any]
            completion(data?["liked_posts"] as? [[String: Any]], isSuccess)
        }
    }
    func userLike(id: Int64, reblogKey: String, completion: @escaping (_ isSuccess: Bool)->()) {
        
        let params = ["id": "\(id)",
                      "reblog_key": reblogKey]
        
        request(urlString: like, method: .POST, parameters: params) { (json, isSuccess) in
            completion(isSuccess)
        }
    }
    func userUnLike(id: Int64, reblogKey: String, completion: @escaping (_ isSuccess: Bool)->()) {
        
        let params = ["id": "\(id)",
            "reblog_key": reblogKey]
        request(urlString: unLike, method: .POST, parameters: params) { (json, isSuccess) in
            completion(isSuccess)
        }
    }
    func userFollowingList(offset: String, completion: @escaping (_ list: [[String: Any]]?, _ isSuccess: Bool)->()) {
        
        let params = ["offset": offset,
                      "limit": "20"]
        
        request(urlString: followingURL, method: .GET, parameters: params) { (json, isSuccess) in
            
            let result = json as? [String: Any]
            
            let data = result?["response"] as? [String: Any]
            completion(data?["blogs"] as? [[String: Any]], isSuccess)
        }
    }
    func userFollow(blogUrl: String, completion: @escaping (_ isSuccess: Bool)->()) {
        let params = ["url": blogUrl]
        request(urlString: follow, method: .POST, parameters: params) { (json, isSuccess) in
            completion(isSuccess)
        }
    }
    func userUnFollow(blogUrl: String, completion: @escaping (_ isSuccess: Bool)->()) {
        let params = ["url": blogUrl]
        request(urlString: unFollow, method: .POST, parameters: params) { (json, isSuccess) in
            completion(isSuccess)
        }
    }

    

    
        
}
