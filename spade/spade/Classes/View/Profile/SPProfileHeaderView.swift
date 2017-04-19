//
//  SPProfileHeaderView.swift
//  spade
//
//  Created by ntian on 2017/4/17.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class SPProfileHeaderView: UIView {

    @IBOutlet weak var followingNum: UILabel!
    @IBOutlet weak var followersNum: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var postNum: UILabel!
    
    var model: SPBlogInfo? {
        didSet {
            guard let model = model else {
                return
            }
            followersNum.text = String(model.followers)
            postNum.text = String(model.total_posts)
            followingNum.text = String(model.following)
            avatarImage.nt_setAvatarImage(urlString: model.avatarURL, placeholder: nil, isAvator: true)
        }
    }
}
