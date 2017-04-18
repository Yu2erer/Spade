//
//  SPBlogInfoViewModel.swift
//  spade
//
//  Created by ntian on 2017/4/18.
//  Copyright © 2017年 ntian. All rights reserved.
//

import Foundation

class SPBlogInfoViewModel {
    
    lazy var blogInfo = [SPBlogInfo]()
    
    func loadBlogInfo(completion: @escaping (_ isSuccess: Bool)->()) {
        SPNetworkManage.shared.userBlogInfo { (list, isSuccess) in
            if !isSuccess {
                completion(false)
            }
            guard let array = NSArray.yy_modelArray(with: SPBlogInfo.self, json: list ?? []) as? [SPBlogInfo] else {
                completion(isSuccess)
                    return
                }
            self.blogInfo += array

            completion(isSuccess)
        }
        
    }
    
}
