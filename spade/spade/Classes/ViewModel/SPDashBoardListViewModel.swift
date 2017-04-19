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
    
    func loadDashBoard(pullup: Bool, pullupCount: Int, completion: @escaping (_ isSuccess: Bool, _ shouldRefresh: Bool) -> ()) {
        
        if pullup && pullupErrorTimes > maxPullupTryTimes {
            completion(true, false)
            return
        }
        
        let since_id = pullup ? "" : "\(String(describing: dashBoardList.first?.dashBoard.id))"
        let offset = !pullup ? "" : "\(pullupCount)"
        
        SPNetworkManage.shared.dashBoardList(since_id: since_id, offset: offset) { (list, isSuccess) in
            
            if !isSuccess {
                completion(false, false)
            }
            /// 上次的 最高一条的id
            let firstId = self.dashBoardList.first?.dashBoard.id
            let lastId = self.dashBoardList.last?.dashBoard.id
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
            
            if pullup {
                if self.dashBoardList.last?.dashBoard.id == lastId && lastId != nil {
                    // FIXME: 此处应该有一个酷炫的 SVProgressHud 显示信息
                    print("扎心了 老铁")
                    self.pullupErrorTimes = 3
                    completion(isSuccess, false)
                    return
                }
                self.dashBoardList += array
            } else {
                if self.dashBoardList.first?.dashBoard.id == firstId && firstId != nil {
                    print("没有新数据呗")
                    completion(isSuccess, false)
                    return
                }
                // 下拉刷新
                self.dashBoardList = array + self.dashBoardList
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
