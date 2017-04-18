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
    @IBOutlet weak var likeNum: UILabel!
    @IBOutlet weak var followersNum: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    
    var model: SPBlogInfo? {
        didSet {
            guard let model = model else {
                return
            }
            followersNum.text = String(model.followers)
            likeNum.text = String(model.likes)
            followingNum.text = String(model.following)
            avatarImage.nt_setAvatarImage(urlString: model.avatarURL, placeholder: nil, isAvator: true)
        }
    }
}
