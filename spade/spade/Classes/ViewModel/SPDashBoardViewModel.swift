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
    /// 喜欢图像 喜欢就换成爱心图
    var likeImage: UIImage?
    
    init(model: SPDashBoard) {
        self.dashBoard = model
        avatarURL = blogInfoURL + model.post_url! + "/avatar"
        if model.liked == 1 {
            likeImage = UIImage(named: "glyph-liked")
        } else {
            likeImage = UIImage(named: "glyph-like")
        }
    }
    
    var description: String {
        return dashBoard.description
    }

}
