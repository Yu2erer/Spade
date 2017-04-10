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
    
    /// 配图视图大小
    var pictureViewSize = CGSize()
    
    init(model: SPDashBoard) {
        self.dashBoard = model
        avatarURL = blogInfoURL + model.post_url! + "/avatar"
        if model.liked == 1 {
            likeImage = UIImage(named: "glyph-liked")
        } else {
            likeImage = UIImage(named: "glyph-like")
        }
        
        // 计算配图视图大小
        pictureViewSize = calcPictureViewSize(layout: dashBoard.photoset_layout)
    }
    
    fileprivate func calcPictureViewSize(layout: String?) -> CGSize {
        
        // 根据字符串长度 知道多少行 如果为 nil 就默认是 1行1张
        let row = layout?.characters.count ?? 1
        
        var height = PictureViewOutterMargin
        if row == 1 {
            
            // 取出第一张照片的高度
            guard let originalHeight = dashBoard.photos?[0].original_size?.height else {
                return CGSize()
            }
            // 计算高度
            height += CGFloat(Double(originalHeight)! * 0.37)

            return CGSize(width: PictureViewWidth, height: height)
        }
        return CGSize()
      
    }
    
    
    var description: String {
        return dashBoard.description
    }

}
