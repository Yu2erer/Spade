//
//  SPProfileHeaderView.swift
//  spade
//
//  Created by ntian on 2017/4/17.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class SPProfileHeaderView: UIView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followingNum: UILabel!
    @IBOutlet weak var followersNum: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var postNum: UILabel!
    
    var model: SPBlogInfo? {
        didSet {
            guard let model = model else {
                return
            }
            followersNum.text = String(describing: model.blogs?[0].followers ?? 0)
            postNum.text = String(describing: model.blogs?[0].total_posts ?? 0)
            followingNum.text = String(model.following)
            avatarImage.nt_setAvatarImage(urlString: model.avatarURL, placeholder: nil, isAvator: true)
            nameLabel.text = String(describing: model.name ?? " ")
        }
    }
}
