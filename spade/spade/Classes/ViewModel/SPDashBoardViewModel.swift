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
    var likeImage: String?
    var selectedImage: String?
    /// 行数
    var row: Int = 0
    /// 高度
    var height: CGFloat = 0
    var note_count: String?
    
    init(model: SPDashBoard) {
        self.dashBoard = model
        avatarURL = blogInfoURL + model.post_url! + "/avatar"
        if model.liked == 1 {
            likeImage = "glyph-liked"
            selectedImage = "glyph-like"
        } else {
            likeImage = "glyph-like"
            selectedImage = "glyph-liked"
        }
        if model.note_count == 0 {
            self.note_count = ""
        } else {
            self.note_count = "\(model.note_count)条热度"
        }
        
        // 计算配图视图高度
        calcPictureViewSize(layout: dashBoard.photoset_layout)
    }
    
    fileprivate func calcPictureViewSize(layout: String?) {
        // 根据字符串长度 知道多少行
        row = layout?.characters.count ?? 0
        
        var temp: Int = 0
        var rowNum: Int = 0
        var originalHeight: Double = 0
        var originalWidth: Double = 0
        // 0 是第一行 1是第二行 temp 是一行几张图
        rowNum = (Int(dashBoard.photoset_layout ?? "") ?? 0).reverse()
        
        height = PictureViewOutterMargin
        var index = 0 // 图片索引
        for _ in 0..<row {
            
            temp = rowNum % 10
            rowNum /= 10
            for _ in 0..<temp {
                originalHeight = Double(dashBoard.photos?[index].original_size?.height ?? "") ?? 0
                originalWidth = Double(dashBoard.photos?[index].original_size?.width ?? "") ?? 0
            }
            height += CGFloat(originalHeight / originalWidth) * (PictureViewWidth / CGFloat(temp) + PictureViewInnerMargin)
            index = index + temp
        }
    }
    
    
    var description: String {
        return dashBoard.description
    }
    

}
