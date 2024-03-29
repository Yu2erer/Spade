//
//  SPDashBoardListViewModel.swift
//  spade
//
//  Created by ntian on 2017/4/9.
//  Copyright © 2017年 ntian. All rights reserved.
//

import Foundation
/// 上拉刷新 最大尝试次数
private let maxPullupTryTimes = 3

class SPDashBoardListViewModel {
    
    lazy var dashBoardList = [SPDashBoardViewModel]()
    /// 上拉刷新错误次数
    private var pullupErrorTimes = 0
    private var pullupCount = 0
    
    func loadDashBoard(type: String, pullup: Bool, completion: @escaping (_ isSuccess: Bool, _ shouldRefresh: Bool) -> ()) {
        
        if pullup && pullupErrorTimes > maxPullupTryTimes {
            completion(true, false)
            return
        }
        
        let since_id = pullup ? "" : "\(dashBoardList.first?.dashBoard.id ?? 0)"
        let offset = !pullup ? "" : "\(pullupCount)"
        
        SPDashBoardListDAL.loadDashBoard(since_id: since_id, offset: offset, type: type) { (list, isSuccess) in
            
//        }
//        SPNetworkManage.shared.dashBoardList(since_id: since_id, offset: offset, type: type) { (list, isSuccess) in
            
            if !isSuccess {
                completion(false, false)
            }
            // 定义结果可变数组
            var array = [SPDashBoardViewModel]()
            let lastId = self.dashBoardList.last?.dashBoard.id

            // 遍历数组 字典转模型
            for dict in list ?? [] {
                
                // 创建dashBoard模型
                let dashBoard = SPDashBoard()
                dashBoard.yy_modelSet(with: dict)
                
                let viewModel = SPDashBoardViewModel(model: dashBoard)
                
                array.append(viewModel)
                
            }
            if pullup {
                self.dashBoardList += array
                if self.dashBoardList.last?.dashBoard.id == lastId && lastId != nil {
                    print("扎心了")
                    self.pullupErrorTimes = 4
                    completion(isSuccess, false)
                    return
                }
            } else {
                self.dashBoardList = array + self.dashBoardList
            }
            // 判断上拉刷新的数据量
            if pullup && array.count == 0 {
                self.pullupErrorTimes += 1
                completion(isSuccess, false)
            } else {
                self.pullupCount += 20
                completion(isSuccess, true)
            }
        }
    }
}
