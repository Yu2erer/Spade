//
//  SPBlogInfo.swift
//  spade
//
//  Created by ntian on 2017/4/8.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

/// 其实就是用户信息啦
class SPBlogInfo: NSObject {
    
    /// 多少个 like
    var likes: Int = 0
    /// 多少个 followers
    var followers: Int = 0
    var following: Int = 0
    var name: String? {
        didSet {
            avatarURL = blogInfoURL + name! + ".tumblr.com/avatar/96"
        }
    }

    var avatarURL: String?
    
    
    override var description: String {
        return yy_modelDescription()
    }
    

}
