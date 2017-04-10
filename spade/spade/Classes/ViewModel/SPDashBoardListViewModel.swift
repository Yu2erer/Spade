//
//  SPDashBoardListViewModel.swift
//  spade
//
//  Created by ntian on 2017/4/9.
//  Copyright © 2017年 ntian. All rights reserved.
//

import Foundation

class SPDashBoardListViewModel {
    
    lazy var dashBoardList = [SPDashBoardViewModel]()
    
    
    func loadDashBoard(pullup: Bool, completion: @escaping (_ isSuccess: Bool) -> ()) {
        
        let since_id = pullup ? "\(String(describing: dashBoardList.last?.dashBoard.id))" : "\(String(describing: dashBoardList.first?.dashBoard.id))"
        
        SPNetworkManage.shared.dashBoardList(since_id: since_id) { (list, isSuccess) in
            
            if !isSuccess {
                completion(false)
            }
            // 定义结果可变数组
            var array = [SPDashBoardViewModel]()
            // 遍历数组 字典转模型
            for dict in list ?? [] {
                
                // 创建dashBoard模型
                let dashBoard = SPDashBoard()
                dashBoard.yy_modelSet(with: dict)
                
                let viewModel = SPDashBoardViewModel(model: dashBoard)
                
                array.append(viewModel)
                
            }
            print(array)

//            guard let array = NSArray.yy_modelArray(with: SPDashBoard.self, json: list ?? []) as? [SPDashBoard] else {
//                completion(isSuccess)
//                return
//            }
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
