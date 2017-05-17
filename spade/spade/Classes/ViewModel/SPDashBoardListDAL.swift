//
//  SPDashBoardListDAL.swift
//  spade
//
//  Created by ntian on 2017/5/17.
//  Copyright © 2017年 ntian. All rights reserved.
//

import Foundation

/// 数据访问层 Data Access Layer
class SPDashBoardListDAL {
    
    class func loadDashBoard(since_id: String, offset: String, type: String, completion: @escaping (_ list: [[String: Any]]?, _ isSuccess: Bool)->()) {
        var since_id = since_id
        if since_id == "0" {
            since_id = "nil"
        }
        if type == "home" {
            let array = NTSQLiteManager.shared.loadDashBoard(userId: "1", since_id: since_id, offset: offset)
            if array.count > 0 {
                completion(array, true)
                return
            }
        }
        SPNetworkManage.shared.dashBoardList(since_id: since_id, offset: offset, type: type) { (list, isSuccess) in
            
            if !isSuccess {
                completion(nil, false)
                return
            }
            guard let list = list else {
                completion(nil, isSuccess)
                return
            }
            NTSQLiteManager.shared.updateDashBoard(userId: "1", array: list)
            completion(list, isSuccess)
        }
            
        
        
    }
    
}
