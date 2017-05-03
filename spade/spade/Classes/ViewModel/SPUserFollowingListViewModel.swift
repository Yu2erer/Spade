
//
//  SPUserFollowingListViewModel.swift
//  spade
//
//  Created by ntian on 2017/4/29.
//  Copyright © 2017年 ntian. All rights reserved.
//

import Foundation
private let maxPullupTryTimes = 3
class SPUserFollowingListViewModel {
    
    lazy var followingModel = [SPBlogInfo]()
    private var pullupErrorTimes = 0
    private var pullupCount = 0

    func loadFollowing(pullup: Bool, completion: @escaping (_ isSuccess: Bool, _ shouldRefresh: Bool) -> ()) {
        
        if pullup && pullupErrorTimes > maxPullupTryTimes {
            completion(true, false)
            return
        }
        
        let offset = !pullup ? "" : "\(pullupCount)"
        
        SPNetworkManage.shared.userFollowingList(offset: offset) { (list, isSuccess) in
            
            if !isSuccess {
                completion(false, false)
            }
            guard let array = NSArray.yy_modelArray(with: SPBlogInfo.self, json: list ?? []) as? [SPBlogInfo] else {
                completion(isSuccess, false)
                return
            }
            self.followingModel += array
            self.pullupCount += 20
            completion(isSuccess, true)
            
            if pullup && array.count == 0 {
                self.pullupErrorTimes += 1
                completion(isSuccess, false)
                return
            }
            
        }
    }

}
