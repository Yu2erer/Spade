//
//  SPBlogInfoViewModel.swift
//  spade
//
//  Created by ntian on 2017/4/18.
//  Copyright © 2017年 ntian. All rights reserved.
//

import Foundation

class SPBlogInfoViewModel {
    
    lazy var userBlogInfo = [SPBlogInfo]()
    lazy var blogInfo = SPBlogInfo()
    
    func loadUserBlogInfo(completion: @escaping (_ isSuccess: Bool)->()) {
        
        SPNetworkManage.shared.userBlogInfo { (list, isSuccess) in
            if !isSuccess {
                completion(false)
            }
            guard let array = NSArray.yy_modelArray(with: SPBlogInfo.self, json: list ?? []) as? [SPBlogInfo] else {
                completion(isSuccess)
                    return
                }
            self.userBlogInfo += array

            completion(isSuccess)
        }
        
    }
    
    func loadBlogInfo(blogName: String, completion: @escaping (_ isSuccess: Bool)->()) {
        
        SPNetworkManage.shared.blogInfo(blogName: blogName) { (list, isSuccess) in
            if !isSuccess {
                completion(false)
            }
         
            self.blogInfo.yy_modelSet(with: list ?? [:])
            print(self.blogInfo)
//            guard let array = NSArray.yy_modelArray(with: SPBlogInfo.self, json: list ?? []) as? [SPBlogInfo] else {
//                completion(isSuccess)
//                return
//            }
//            for dict in list ?? [] {
//                // 创建dashBoard模型
//                let dashBoard = SPDashBoard()
//                dashBoard.yy_modelSet(with: dict)
//                let viewModel = SPDashBoardViewModel(model: dashBoard)
//                array.append(viewModel)
//            }
            
//            print(array)
//            self.blogInfo += array
//            
            completion(isSuccess)
        }
    }
    
    
}
