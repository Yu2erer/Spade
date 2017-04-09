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
    
    var viewModel: SPDashBoardViewModel? {
        
        didSet {
            nameLabel.text = viewModel?.dashBoard.blog_name
            statusLabel.text = viewModel?.dashBoard.summary
            iconView.nt_setImage(urlString: viewModel?.avatarURL, placeholder: nil, isAvator: true)
            
        }
    }
}
