//
//  SPUserLikeListViewModel.swift
//  spade
//
//  Created by ntian on 2017/4/21.
//  Copyright © 2017年 ntian. All rights reserved.
//

import Foundation
private let maxPullupTryTimes = 3
class SPUserLikeListViewModel {
    
    lazy var userLikeModel = [SPDashBoardViewModel]()
    private var pullupErrorTimes = 0
    
    func loadUserLikes(pullup: Bool, pullupCount: Int, completion: @escaping (_ isSuccess: Bool, _ shouldRefresh: Bool) -> ()) {
        
        if pullup && pullupErrorTimes > maxPullupTryTimes {
            completion(true, false)
            return
        }
        
        let offset = !pullup ? "" : "\(pullupCount)"
        SPNetworkManage.shared.userLikes(offset: offset) { (list, isSuccess) in
            
            if !isSuccess {
                completion(false, false)
            }
            /// 上次的 最高一条的id
            let firstId = self.userLikeModel.first?.dashBoard.id
            let lastId = self.userLikeModel.last?.dashBoard.id
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
                self.userLikeModel += array
                if self.userLikeModel.last?.dashBoard.id == lastId && lastId != nil {
                    print("扎心了 老铁")
                    self.pullupErrorTimes = 4
                    completion(isSuccess, false)
                    return
                }
            } else {
                // 下拉刷新
                self.userLikeModel = array + self.userLikeModel
                if self.userLikeModel.first?.dashBoard.id == firstId && firstId != nil {
                    print("没有新数据呗")
                    completion(isSuccess, false)
                    return
                }
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
