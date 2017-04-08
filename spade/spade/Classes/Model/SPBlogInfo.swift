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
    
    /// 是否 follow
    var followed: Bool?
    /// 多少个 like
    var likes: Int = 0
    /// 多少个 followers
    var followers: Int = 0
    /// 个性签名吧？
    var title: String?
    /// 头像 Tumblr 太傻比了 一个头像也要数组
    var avatar: [SPBlogAvatar]?
    
    override var description: String {
        return yy_modelDescription()
    }
    

}
