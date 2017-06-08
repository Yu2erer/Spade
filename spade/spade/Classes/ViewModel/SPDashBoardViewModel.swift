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
    /// 行数
    var row: Int = 0
    /// 图片高度
    var picHeight: CGFloat = 0
    /// 视频高度
    var videoHeight: CGFloat = 0
    /// 热度
    var note_count: String?
    /// 行高
    var rowHeight: CGFloat = 0
    
    init(model: SPDashBoard) {
        self.dashBoard = model

//        if inReview == true {
            avatarURL = blogInfoURL + model.post_url! + "/avatar"
//        } else {
//            avatarURL = spadeAvatarURL + model.post_url! + "/avatar"
//        }
        if model.note_count == 0 {
            self.note_count = ""
        } else {
            self.note_count = "\(model.note_count)\(NSLocalizedString("notes", comment: "热度"))"
        }
        
        // 计算配图视图高度
        calcPictureViewSize(layout: dashBoard.photoset_layout)
        updateRowHeight()
    }
    
    fileprivate func calcPictureViewSize(layout: String?) {
        // 根据字符串长度 知道多少行
        row = layout?.characters.count ?? 0
        picHeight = PictureViewOutterMargin

        var temp: Int = 0
        var rowNum: Int = 0
        var originalHeight: Double = 0
        var originalWidth: Double = 0
        // 0 是第一行 1是第二行 temp 是一行几张图
        rowNum = (Int(dashBoard.photoset_layout ?? "") ?? 0).reverse()
        
        var index = 0 // 图片索引
        for _ in 0..<row {
            
            temp = rowNum % 10
            rowNum /= 10
            for _ in 0..<temp {
                originalHeight = Double(dashBoard.photos?[index].original_size?.height ?? "") ?? 0
                originalWidth = Double(dashBoard.photos?[index].original_size?.width ?? "") ?? 0
            }
            picHeight += CGFloat(originalHeight / originalWidth) * (PictureViewWidth / CGFloat(temp) + PictureViewInnerMargin)
            index = index + temp
        }
    }
    /// 根据当前视图模型内容计算行高
    func updateRowHeight() {
        // 头像间距11 + 头像高度32 + 配图高度 + 间距11 + toolBar高度30 + 正文高度 + 线0.5
        // 头像间距11 + 头像高度32 + 间距11 + 视频占位高度 + 间距11 + toolBar高度30 + 正文高度 + 线0.5
        let margin: CGFloat = 11
        let iconHeight: CGFloat = 32
        let toolBarHeight: CGFloat = 30
        var height: CGFloat = 0
        let viewSize: CGSize = CGSize(width: PictureViewWidth - 14 - 11, height: CGFloat(MAXFLOAT))
        let font = UIFont.systemFont(ofSize: 14)
        // 计算已经能算出来的高度
        height = margin + iconHeight + margin + toolBarHeight + 0.5
        // 正文高度
        if dashBoard.summary != "" {
            height += (dashBoard.summary! as NSString).boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], attributes: [NSFontAttributeName: font], context: nil).height + margin
        } else {
            height += margin
        }
        if dashBoard.type == "photo" {
            height += picHeight
        } else if dashBoard.type == "video" {
            let thumbnail_height = CGFloat(dashBoard.thumbnail_height)
            let thumbnail_width = CGFloat(dashBoard.thumbnail_width)
            videoHeight = (thumbnail_height / thumbnail_width) * PictureViewWidth
            if videoHeight.isNaN {
                videoHeight = (720 / 1280) * PictureViewWidth
            }
            height += margin + videoHeight
        }
        rowHeight = height
    }
    
    
    var description: String {
        return dashBoard.description
    }
}
