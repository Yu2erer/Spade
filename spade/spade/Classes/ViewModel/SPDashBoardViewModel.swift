//
//  SPDashBoardViewModel.swift
//  spade
//
//  Created by ntian on 2017/4/9.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

/// 单条DashBoard视图模型
class SPDashBoardViewModel: CustomStringConvertible {
    
    /// dashBoard 模型
    var dashBoard: SPDashBoard
    /// 头像
    var avatarURL: String?
    
    init(model: SPDashBoard) {
        self.dashBoard = model
        avatarURL = blogInfoURL + model.post_url! + "/avatar"
    }
    
    var description: String {
        return dashBoard.description
    }

}
