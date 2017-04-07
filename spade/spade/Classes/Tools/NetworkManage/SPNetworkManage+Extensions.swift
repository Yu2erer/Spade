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
    
    
    func dashBoardList(since_id: Int, completion: @escaping ()->()) {
        
        let params = ["since_id": since_id]
        
        request(urlString: dashBoardURL, method: .GET, parameters: params) { (json, isSuccess) in
            
        }

    }
    
}
