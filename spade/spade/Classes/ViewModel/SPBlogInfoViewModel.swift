//
//  SPBlogInfoViewModel.swift
//  spade
//
//  Created by ntian on 2017/4/18.
//  Copyright © 2017年 ntian. All rights reserved.
//

import Foundation

class SPBlogInfoViewModel {
    
    lazy var blogInfo = SPBlogInfo()
    
    func loadUserBlogInfo(completion: @escaping (_ isSuccess: Bool)->()) {
        
        SPNetworkManage.shared.userBlogInfo { (list, isSuccess) in
            if !isSuccess {
                completion(false)
            }
            self.blogInfo.yy_modelSet(with: list ?? [:])
            print(self.blogInfo)

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
            
            completion(isSuccess)
        }
    }
    
    
}
