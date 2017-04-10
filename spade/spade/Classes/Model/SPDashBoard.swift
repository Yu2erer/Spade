//
//  SPDashBoard.swift
//  spade
//
//  Created by ntian on 2017/4/7.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import YYModel

class SPDashBoard: NSObject {
    
    var id: Int = 0
    // 内容
    var summary: String?
    // 名字
    var blog_name: String?
    // 链接 用来取 blog 相关信息的
    var post_url: String? {
        didSet {
            // 通过String的扩展获取 前八位https://
            // 和后18位的中间 Blog 的地址
            post_url = post_url?.getBlogString()
        }
    }
    /// 是否喜欢
    var liked: Int = 0
    /// 是否关注
    var followed: Int = 0
    
    /// 图片布局
    var photoset_layout: String?
    var photos: [SPDashBoardPicture]?
    /// 标签
    var tags: Array<String>?
    /// 时间字符串
    var date: String? {
        didSet {
            createDate = Date.nt_Date(string: date!)
        }
    }
    /// 带描述文字的时间
    var createDate: Date?
    
    
    override var description: String {
        return yy_modelDescription()
    }
    /// 类函数 - 告诉第三方框架 如果遇到数组类型的属性 数组中存放的是什么类
    class func modelContainerPropertyGenericClass() -> [String: Any] {
        return ["photos": SPDashBoardPicture.self]
    }

}
