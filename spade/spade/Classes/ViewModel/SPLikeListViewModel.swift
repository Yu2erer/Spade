//
//  SPLikeListViewModel.swift
//  spade
//
//  Created by ntian on 2017/4/22.
//  Copyright © 2017年 ntian. All rights reserved.
//

import Foundation
private let maxPullupTryTimes = 3
class SPLikeListViewModel {
    
    lazy var likeModel = [SPDashBoardViewModel]()
    private var pullupErrorTimes = 0
    
    func loadBlogLikes(blogName: String, pullup: Bool, pullupCount: Int, completion: @escaping (_ isSuccess: Bool, _ shouldRefresh: Bool) -> ()) {
        
        if pullup && pullupErrorTimes > maxPullupTryTimes {
            completion(true, false)
            return
        }
        
        let offset = !pullup ? "" : "\(pullupCount)"
        SPNetworkManage.shared.blogLikes(blogName: blogName, offset: offset) { (list, isSuccess) in
            
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
            
            if pullup {
                if self.likeModel.last?.dashBoard.id == array.last?.dashBoard.id {
                    print("扎心了 老铁")
                    self.pullupErrorTimes = 4
                    completion(isSuccess, false)
                    return
                }
                self.likeModel += array
            } else {
                // 下拉刷新
                if self.likeModel.first?.dashBoard.id == array.first?.dashBoard.id {
                    print("没有新数据呗")
                    completion(isSuccess, false)
                    return
                }
                self.likeModel = array
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
