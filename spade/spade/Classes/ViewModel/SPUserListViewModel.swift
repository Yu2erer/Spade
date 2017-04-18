//
//  SPUserListViewModel.swift
//  spade
//
//  Created by ntian on 2017/4/18.
//  Copyright © 2017年 ntian. All rights reserved.
//

import Foundation
private let maxPullupTryTimes = 3
class SPUserListViewModel {
    
    lazy var userViewModel = [SPDashBoardViewModel]()
    private var pullupErrorTimes = 0
    
    func loadUserList(blogName: String, pullup: Bool, pullupCount: Int, completion: @escaping (_ isSuccess: Bool, _ shouldRefresh: Bool) -> ()) {
        
        if pullup && pullupErrorTimes > maxPullupTryTimes {
            completion(true, false)
            return
        }
        
        let offset = !pullup ? "" : "\(pullupCount)"
        
        SPNetworkManage.shared.userList(blogName: blogName, offset: offset) { (list, isSuccess) in
            
            if !isSuccess {
                completion(false, false)
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
            /// 上次的 最高一条的id
            let firstId = self.userViewModel.first?.dashBoard.id
            
            if pullup {
                self.userViewModel += array
            } else {
                // 下拉刷新
                self.userViewModel = array + self.userViewModel
            }
            if self.userViewModel.first?.dashBoard.id == firstId {
                print("扎心了 老铁")
                self.pullupErrorTimes = 3
                completion(isSuccess, false)
                return
            }
        


            // 判断上拉刷新的数据量
            if pullup && array.count == 0 {
                self.pullupErrorTimes += 1
                completion(isSuccess, false)
            } else {
                completion(isSuccess, true)
            }
        }
    }
    
}
