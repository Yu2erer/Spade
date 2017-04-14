//
//  SPHomeTableViewCell.swift
//  spade
//
//  Created by ntian on 2017/4/6.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class SPHomeTableViewCell: UITableViewCell {
    // 正文
    @IBOutlet weak var statusLabel: UILabel!
    // 名字
    @IBOutlet weak var nameLabel: UILabel!
    // 时间
    @IBOutlet weak var timeLabel: UILabel!
    // 头像
    @IBOutlet weak var iconView: UIImageView!
    /// 爱心喜欢
    @IBOutlet weak var likeIcon: UIImageView!
    /// 配图视图
    @IBOutlet weak var pictureView: SPHomePictureView!
    
    var viewModel: SPDashBoardViewModel? {
        
        didSet {
            nameLabel.text = viewModel?.dashBoard.blog_name
            statusLabel.text = viewModel?.dashBoard.summary
            iconView.nt_setAvatarImage(urlString: viewModel?.avatarURL, placeholder: nil, isAvator: true)
            likeIcon.image = viewModel?.likeImage
            timeLabel.text = viewModel?.dashBoard.createDate?.nt_dateDescription
            
            pictureView.urls = viewModel?.dashBoard.photos
            pictureView.viewModel = viewModel
        }
    }
}
