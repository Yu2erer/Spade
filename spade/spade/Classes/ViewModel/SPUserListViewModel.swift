//
//  SPUserListViewModel.swift
//  spade
//
//  Created by ntian on 2017/4/18.
//  Copyright © 2017年 ntian. All rights reserved.
//

import Foundation

class SPUserListViewModel {
    
    lazy var userViewModel = [SPDashBoardViewModel]()
    
    
    func loadUserList(blogName: String, pullup: Bool, pullupCount: Int, completion: @escaping (_ isSuccess: Bool) -> ()) {
        
        let offset = !pullup ? "" : "\(pullupCount)"
        
        SPNetworkManage.shared.userList(blogName: blogName, offset: offset) { (list, isSuccess) in
            
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
            
            if pullup {
                self.userViewModel += array
            } else {
                // 下拉刷新
                self.userViewModel = array + self.userViewModel
            }
            completion(isSuccess)
        }
    }
    
}
