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
    var following: Int = 0
    var total_posts: Int = 0
    var name: String? {
        didSet {
            avatarURL = blogInfoURL + name! + ".tumblr.com/avatar/96"
        }
    }
    var blogs: [SPBlogsInfo]?
    var followed: Int = 0
    var admin: Int = 0

    var avatarURL: String?
    
    /// 类函数 - 告诉第三方框架 如果遇到数组类型的属性 数组中存放的是什么类
    class func modelContainerPropertyGenericClass() -> [String: Any] {
        return ["blogs": SPBlogsInfo.self]
    }

    override var description: String {
        return yy_modelDescription()
    }
}
/// 用户信息扩展。。
class SPBlogsInfo: NSObject {
    var followed: Int = 0
    var followers: Int = 0
    var total_posts: Int = 0
}
