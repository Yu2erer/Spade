//
//  SPDashBoardListViewModel.swift
//  spade
//
//  Created by ntian on 2017/4/7.
//  Copyright © 2017年 ntian. All rights reserved.
//

import Foundation

class SPDashBoardListViewModel {
    
    lazy var dashBoardList = [SPDashBoard]()
    
    func loadDashBoard(pullup: Bool, completion: @escaping (_ isSuccess: Bool) -> ()) {
        
        let since_id = pullup ? "\(String(describing: dashBoardList.last?.id))" : "\(String(describing: dashBoardList.first?.id))"
        
        print("sinceid \(since_id)")
        
        SPNetworkManage.shared.dashBoardList(since_id: since_id) { (list, isSuccess) in
            
            guard let array = NSArray.yy_modelArray(with: SPDashBoard.self, json: list ?? []) as? [SPDashBoard] else {
                completion(isSuccess)
                return
            }
            if pullup {
                self.dashBoardList += array
            } else {
                // 下拉刷新
                self.dashBoardList = array + self.dashBoardList
                
            }
            completion(isSuccess)
        }
    }
    
}
